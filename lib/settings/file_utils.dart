import 'package:navinotes/packages.dart';
import 'package:path/path.dart' as path;

IconData getFileIcon(String? filePath) {
  if (filePath == null) return Icons.insert_drive_file;
  final ext = path.extension(filePath).toLowerCase();
  switch (ext) {
    case '.pdf':
      return Icons.picture_as_pdf;
    case '.doc':
    case '.docx':
      return Icons.description;
    case '.xls':
    case '.xlsx':
    case '.csv':
      return Icons.table_chart;
    case '.ppt':
    case '.pptx':
      return Icons.slideshow;
    case '.txt':
      return Icons.article;
    case '.zip':
    case '.rar':
    case '.7z':
      return Icons.archive;
    case '.jpg':
    case '.jpeg':
    case '.png':
    case '.gif':
      return Icons.image;
    case '.mp3':
    case '.wav':
      return Icons.audio_file;
    case '.mp4':
    case '.mov':
    case '.avi':
      return Icons.video_file;
    default:
      return Icons.insert_drive_file;
  }
}

/// Handles opening a file with appropriate application based on file type
Future<void> handleOpenFile(Content file, BuildContext context) async {
  if (!context.mounted) return;

  try {
    final filePath = file.file;
    if (filePath == null || filePath.isEmpty) {
      MessageDisplayService.showErrorMessage(
        context,
        'Cannot open file: No file path available',
      );
      return;
    }

    final fileEntity = File(filePath);
    if (!await fileEntity.exists()) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'File not found: ${path.basename(filePath)}',
        );
      }
      return;
    }

    final ext = path.extension(filePath).toLowerCase();

    // Handle PDF files with custom viewer
    if (ext == '.pdf') {
      if (file.id != null) {
        NavigationHelper.navigateToPdfView(file.id!);
      } else {
        if (context.mounted) {
          MessageDisplayService.showErrorMessage(
            context,
            'Cannot open PDF: Invalid file reference',
          );
        }
      }
      return;
    }
    //TODO test this
    // For other file types, try to open with system default app
    final result = await OpenFile.open(filePath);

    if (result.type != ResultType.done) {
      throw Exception(result.message);
    }
  } catch (e) {
    if (context.mounted) {
      MessageDisplayService.showErrorMessage(
        context,
        'Failed to open file: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }
}

//TODO test this
Future<void> handleFileDownload(Content file, BuildContext context) async {
  try {
    final sourcePath = file.file;
    if (sourcePath == null || sourcePath.isEmpty) {
      MessageDisplayService.showErrorMessage(context, 'No file to download');
      return;
    }

    final fileEntity = File(sourcePath);
    if (!await fileEntity.exists()) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(context, 'File not found');
      }
      return;
    }

    // Ask permission
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (context.mounted) {
          MessageDisplayService.showErrorMessage(
            context,
            'Storage permission denied',
          );
        }
        return;
      }
    }

    // Get Downloads path via plugin
    final downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(
      'Download',
    );

    final fileName = path.basename(sourcePath);
    final destPath = path.join(downloadsPath, fileName);

    await fileEntity.copy(destPath);
    if (context.mounted) {
      MessageDisplayService.showMessage(context, 'File saved to: $destPath');
    }
  } catch (e) {
    debugPrint(e.toString());
    if (context.mounted) {
      MessageDisplayService.showErrorMessage(context, 'Download failed');
    }
  }
}

Future<void> handleContentDelete({
  required Content file,
  required BuildContext context,
  required VoidCallback onSuccess,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Delete File'),
          content: const Text('Are you sure you want to delete this file?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
  );

  if (confirmed != true) return;

  try {
    final filePath = file.file;
    if (filePath != null && filePath.isNotEmpty) {
      final fileEntity = File(filePath);
      if (await fileEntity.exists()) {
        await fileEntity.delete();
      }
    }

    // Delete from database
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.deleteContent(file.id!);

    // Update the UI
    if (context.mounted) {
      MessageDisplayService.showMessage(context, 'File deleted successfully');
    }
    onSuccess();
  } catch (e) {
    debugPrint('Error deleting file: $e');
    if (context.mounted) {
      MessageDisplayService.showErrorMessage(
        context,
        'Failed to delete file: ${e.toString()}',
      );
    }
  }
}

Future<Directory> getFilesDirectory() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final filesDir = Directory('${appDocDir.path}/files');
  // Create the files directory if it doesn't exist
  if (!await filesDir.exists()) {
    await filesDir.create(recursive: true);
  }
  return filesDir;
}

Future<int?> saveFileToDb({
  required PlatformFile pickedFile,
  required BuildContext context,
  required int boardId,
}) async {
  if (isNull(pickedFile.path)) return null;

  try {
    final dbHelper = DatabaseHelper.instance;
    final filesDir = await getFilesDirectory();
    if (context.mounted) {
      final currentUser = getCurrentUserFromSession(context);
      final file = File(pickedFile.path!);
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      final savedFile = await file.copy('${filesDir.path}/$fileName');
      final currentTimestamp = generateUnixTimestamp();
      // Create content entry for the file

      final content = Content(
        guid: generateGUID(currentUser!.id!),
        type: AppContentType.file,
        metaData: {
          ContentMetadataKey.originalFileName: pickedFile.name,
          ContentMetadataKey.fileSize: pickedFile.size,
          ContentMetadataKey.fileExtension: pickedFile.extension,
        },
        boardId: boardId,
        title: pickedFile.name,
        file: savedFile.path,
        createdAt: currentTimestamp,
        updatedAt: currentTimestamp,
        fileNeedSync: true,
      );

      return dbHelper.insertContent(content);
    }
  } catch (e) {
    debugPrint('Error saving file ${pickedFile.name}: $e');
    if (context.mounted) {
      MessageDisplayService.showErrorMessage(
        context,
        'Error saving file ${pickedFile.name}: $e',
      );
    }
    return null;
  }
  return null;
}
