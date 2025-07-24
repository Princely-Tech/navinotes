import 'package:navinotes/packages.dart';
import 'package:path/path.dart' as path;

/// Handles opening a file with appropriate application based on file type
Future<void> handleOpenFile(Content file, BuildContext context) async {
  if (!context.mounted) return;

  try {
    final filePath = file.file;
    if (filePath == null || filePath.isEmpty) {
      _showError(context, 'Cannot open file: No file path available');
      return;
    }

    final fileEntity = File(filePath);
    if (!await fileEntity.exists()) {
      _showError(context, 'File not found: ${path.basename(filePath)}');
      return;
    }

    final ext = path.extension(filePath).toLowerCase();

    // Handle PDF files with custom viewer
    if (ext == '.pdf') {
      if (file.id != null) {
        NavigationHelper.navigateToPdfView(file.id!);
      } else {
        _showError(context, 'Cannot open PDF: Invalid file reference');
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
    _showError(
      context,
      'Failed to open file: ${e.toString().replaceAll('Exception: ', '')}',
    );
  }
}

void _showError(BuildContext context, String message) {
  if (context.mounted) {
    MessageDisplayService.showErrorMessage(context, message);
  }
}

//TODO download not working properly
Future<void> handleFileDownload(Content file, BuildContext context) async {
  try {
    final filePath = file.file;
    if (filePath == null || filePath.isEmpty) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to download file: File path is empty',
        );
      }
      return;
    }

    final fileEntity = File(filePath);
    if (!await fileEntity.exists()) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to download file: File not found',
        );
      }
      return;
    }

    final fileName = path.basename(filePath);
    // final directory = await getDownloadsDirectory();
    Directory? directory;
    if (Platform.isAndroid) {
      directory =
          await getExternalStorageDirectory(); // Not public, but accessible
      // You may try accessing public directory via path tricks if needed
    } else if (Platform.isIOS) {
      directory =
          await getApplicationDocumentsDirectory(); // Only sandboxed access
    } else {
      directory = await getDownloadsDirectory(); // Desktop
    }
    if (directory == null) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to download file: Could not access Downloads directory',
        );
      }
      return;
    }
    final downloadPath = '${directory.path}/$fileName';
    await fileEntity.copy(downloadPath);

    if (context.mounted) {
      MessageDisplayService.showMessage(
        context,
        'File downloaded to Downloads folder',
      );
    }
  } catch (e) {
    debugPrint('Error downloading file: $e');
    if (context.mounted) {
      MessageDisplayService.showErrorMessage(
        context,
        'Failed to download file: ${e.toString()}',
      );
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
