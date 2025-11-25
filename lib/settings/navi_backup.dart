import 'package:navinotes/packages.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as path;

class NaviBackupService {
  static const String currentSchemaVersion = '1.0.0';

  static Future<File?> exportBoard({
    required Board board,
    required BuildContext context,
  }) async {
    try {
      final db = DatabaseHelper.instance;
      final contents = await db.getAllContents(board.id);

      final filesInfo = <Map<String, dynamic>>[];
      final fileContents = <String, List<int>>{};

      for (final content in contents) {
        final filePath = content.file;
        if (filePath != null && filePath.isNotEmpty) {
          final file = File(filePath);
          if (await file.exists()) {
            final fileName = path.basename(file.path);
            filesInfo.add({
              'content_id': content.id,
              'file_name': fileName,
              'original_path': file.path,
            });
            fileContents['files/$fileName'] = await file.readAsBytes();
          }
        }
      }

      final metadata = {
        'schema_version': currentSchemaVersion,
        'exported_at': DateTime.now().toIso8601String(),
        'board': board.toMap(),
        'contents': contents.map((c) => c.toMap()).toList(),
        'files': filesInfo,
      };

      final sqlStatements = _generateSql(board: board, contents: contents);

      final archive = Archive();

      final metadataBytes = utf8.encode(jsonEncode(metadata));
      archive.addFile(
        ArchiveFile('metadata.json', metadataBytes.length, metadataBytes),
      );

      final sqlBytes = utf8.encode(sqlStatements.join('\n'));
      archive.addFile(ArchiveFile('data.sql', sqlBytes.length, sqlBytes));

      fileContents.forEach((relativePath, bytes) {
        archive.addFile(ArchiveFile(relativePath, bytes.length, bytes));
      });

      final zipEncoder = ZipEncoder();
      final encoded = zipEncoder.encode(archive);

      if (encoded == null) {
        throw Exception('Failed to encode board export archive');
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final exportDir = Directory(path.join(appDocDir.path, 'exports'));
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      final safeName = board.name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = path.join(exportDir.path, '${safeName}_$timestamp.navi');
      final exportFile = File(filePath);
      await exportFile.writeAsBytes(encoded, flush: true);

      // Best-effort: also place a copy in a user-visible Downloads folder
      await _saveToDownloads(exportFile);

      await handleFileSharing(
        exportFile,
        context: context,
        successMessage: 'Board exported successfully',
        errorMessage: 'Failed to share exported board',
      );

      return exportFile;
    } catch (e) {
      debugPrint('Error exporting board: $e');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to export board: ${e.toString()}',
        );
      }
      return null;
    }
  }

  static Future<File?> exportUserData({
    required BuildContext context,
    required User? user,
  }) async {
    try {
      final db = DatabaseHelper.instance;
      final boards = await db.getAllBoards();

      final allContents = <Content>[];
      final filesInfo = <Map<String, dynamic>>[];
      final fileContents = <String, List<int>>{};

      for (final board in boards) {
        final contents = await db.getAllContents(board.id);
        allContents.addAll(contents);

        for (final content in contents) {
          final filePath = content.file;
          if (filePath != null && filePath.isNotEmpty) {
            final file = File(filePath);
            if (await file.exists()) {
              final fileName = path.basename(file.path);
              filesInfo.add({
                'board_id': board.id,
                'content_id': content.id,
                'file_name': fileName,
                'original_path': file.path,
              });
              final archivePath = 'files/${board.id}/${content.id}_$fileName';
              fileContents[archivePath] = await file.readAsBytes();
            }
          }
        }
      }

      final metadata = {
        'schema_version': currentSchemaVersion,
        'exported_at': DateTime.now().toIso8601String(),
        'user': user?.toJson(),
        'boards': boards.map((b) => b.toMap()).toList(),
        'contents': allContents.map((c) => c.toMap()).toList(),
        'files': filesInfo,
      };

      final archive = Archive();

      final metadataBytes = utf8.encode(jsonEncode(metadata));
      archive.addFile(
        ArchiveFile('metadata.json', metadataBytes.length, metadataBytes),
      );

      fileContents.forEach((relativePath, bytes) {
        archive.addFile(ArchiveFile(relativePath, bytes.length, bytes));
      });

      final zipEncoder = ZipEncoder();
      final encoded = zipEncoder.encode(archive);

      if (encoded == null) {
        throw Exception('Failed to encode data export archive');
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final exportDir = Directory(path.join(appDocDir.path, 'exports'));
      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      final userIdPart = user?.id?.toString() ?? 'local_user';
      final safeName = 'user_${userIdPart}_data';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = path.join(exportDir.path, '${safeName}_$timestamp.navi');
      final exportFile = File(filePath);
      await exportFile.writeAsBytes(encoded, flush: true);

      await _saveToDownloads(exportFile);

      await handleFileSharing(
        exportFile,
        context: context,
        successMessage: 'Data exported successfully',
        errorMessage: 'Failed to share exported data',
      );

      return exportFile;
    } catch (e) {
      debugPrint('Error exporting user data: $e');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to export data: ${e.toString()}',
        );
      }
      return null;
    }
  }

  static Future<void> _saveToDownloads(File exportFile) async {
    try {
      if (!Platform.isAndroid) {
        // For now we only handle Android explicitly; other platforms keep the
        // file in the app documents directory and rely on sharing.
        return;
      }

      final status = await Permission.storage.request();
      if (!status.isGranted) return;

      final downloadsDir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD,
      );

      final targetPath = path.join(
        downloadsDir,
        path.basename(exportFile.path),
      );
      await exportFile.copy(targetPath);
    } catch (e) {
      // Don't fail the overall export if Downloads write fails; just log it.
      debugPrint('Error saving export to Downloads: $e');
    }
  }

  static List<String> _generateSql({
    required Board board,
    required List<Content> contents,
  }) {
    String esc(String? value) {
      if (value == null) return 'NULL';
      final escaped = value.replaceAll("'", "''");
      return "'" + escaped + "'";
    }

    String escJson(dynamic value) {
      if (value == null) return 'NULL';
      return esc(jsonEncode(value));
    }

    final stmts = <String>[];

    final b = board.toMap();
    stmts.add(
      'INSERT OR REPLACE INTO boards (id, user_id, type, name, customization, is_public, cover_image_need_sync, description, subject, level, term, cover_image, course_info, course_timelines, syllabus_content_id, mind_map_data, created_at, updated_at, synced_at) VALUES ('
      "${esc(b['id'])}, "
      "${b['user_id']}, "
      "${esc(b['type'])}, "
      "${esc(b['name'])}, "
      "${escJson(b['customization'])}, "
      "${b['is_public'] ?? 0}, "
      "${b['cover_image_need_sync'] ?? 0}, "
      "${esc(b['description'])}, "
      "${esc(b['subject'])}, "
      "${esc(b['level'])}, "
      "${esc(b['term'])}, "
      "${esc(b['cover_image'])}, "
      "${esc(b['course_info'])}, "
      "${esc(b['course_timelines'])}, "
      "${esc(b['syllabus_content_id'])}, "
      'NULL, '
      "${b['created_at'] ?? 0}, "
      "${b['updated_at'] ?? 0}, "
      "${b['synced_at'] ?? 0});",
    );

    for (final c in contents) {
      final m = c.toMap();
      stmts.add(
        'INSERT OR REPLACE INTO contents (id, type, meta_data, board_id, title, cover_image, tags, content, drawing, file, created_at, voice_notes, cover_image_need_sync, file_need_sync, updated_at, synced_at, mind_map_x, mind_map_y, connected_content_ids, node_color, node_shape, node_width, node_height) VALUES ('
        "${esc(m['id'])}, "
        "${esc(m['type'])}, "
        "${esc(m['meta_data'])}, "
        "${esc(m['board_id'])}, "
        "${esc(m['title'])}, "
        "${esc(m['cover_image'])}, "
        "${esc(m['tags'])}, "
        "${esc(m['content'])}, "
        "${esc(m['drawing'])}, "
        "${esc(m['file'])}, "
        "${m['created_at'] ?? 0}, "
        "${esc(m['voice_notes'])}, "
        "${m['cover_image_need_sync'] ?? 0}, "
        "${m['file_need_sync'] ?? 0}, "
        "${m['updated_at'] ?? 0}, "
        "${m['synced_at'] ?? 0}, "
        "${m['mind_map_x'] ?? 'NULL'}, "
        "${m['mind_map_y'] ?? 'NULL'}, "
        "${esc(m['connected_content_ids'])}, "
        "${esc(m['node_color'])}, "
        "${esc(m['node_shape'])}, "
        "${m['node_width'] ?? 'NULL'}, "
        "${m['node_height'] ?? 'NULL'});",
      );
    }

    return stmts;
  }

  static Future<bool> importBoard({
    required File file,
    required BuildContext context,
    required SessionManager sessionVm,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final metadataFile = archive.files.firstWhere(
        (f) => f.name == 'metadata.json',
        orElse:
            () => throw Exception('Invalid .navi file: missing metadata.json'),
      );

      final metadataString = utf8.decode(metadataFile.content as List<int>);
      final metadata = jsonDecode(metadataString) as Map<String, dynamic>;

      final boardMap = Map<String, dynamic>.from(metadata['board']);
      final contentsList =
          (metadata['contents'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
      final filesInfo =
          (metadata['files'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();

      final importedBoard = Board.fromMap(boardMap);

      final db = DatabaseHelper.instance;
      final existingBoards = await db.getAllBoards();
      final conflictById =
          existingBoards.where((b) => b.id == importedBoard.id).toList();
      final conflictByName =
          existingBoards.where((b) => b.name == importedBoard.name).toList();

      if (conflictById.isNotEmpty || conflictByName.isNotEmpty) {
        final shouldOverwrite = await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Import Board'),
              content: Text(
                'A board with the same ' +
                    (conflictById.isNotEmpty ? 'ID' : 'name') +
                    " already exists. Do you want to overwrite it?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Overwrite'),
                ),
              ],
            );
          },
        );

        if (shouldOverwrite != true) {
          return false;
        }

        await _deleteBoardAndContents(importedBoard.id);
      }

      final filesDir = await getFilesDirectory();
      final filePathByContentId = <String, String>{};

      for (final info in filesInfo) {
        final contentId = info['content_id'] as String;
        final fileName = info['file_name'] as String;
        final archivePath = 'files/$fileName';

        final archiveFile = archive.files.firstWhere(
          (f) => f.name == archivePath,
          orElse: () => throw Exception('Missing file $archivePath in archive'),
        );

        final targetPath = path.join(
          filesDir.path,
          '${DateTime.now().millisecondsSinceEpoch}_$fileName',
        );
        final outFile = File(targetPath);
        await outFile.writeAsBytes(
          archiveFile.content as List<int>,
          flush: true,
        );

        filePathByContentId[contentId] = targetPath;
      }

      final boardToInsert = importedBoard;
      await db.insertBoard(boardToInsert);

      for (final map in contentsList) {
        final contentId = map['id'] as String;
        if (filePathByContentId.containsKey(contentId)) {
          map['file'] = filePathByContentId[contentId];
        }
        final content = Content.fromMap(map);
        await db.insertContent(content);
      }

      await sessionVm.getAllBoard();

      if (context.mounted) {
        MessageDisplayService.showMessage(
          context,
          'Board imported successfully',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error importing board: $e');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to import board: ${e.toString()}',
        );
      }
      return false;
    }
  }

  static Future<void> deleteBoardWithConfirmation({
    required BuildContext context,
    required Board board,
    required SessionManager sessionVm,
  }) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Board'),
          content: Text(
            "This will permanently delete '${board.name}' including all its notes, files, and flashcards. This action cannot be undone.\n\nAre you sure you want to continue?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      await _deleteBoardAndContents(board.id);
      await sessionVm.getAllBoard();

      if (context.mounted) {
        MessageDisplayService.showMessage(
          context,
          'Board deleted successfully',
        );
        NavigationHelper.pop();
      }
    } catch (e) {
      debugPrint('Error deleting board: $e');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to delete board: ${e.toString()}',
        );
      }
    }
  }

  static Future<void> _deleteBoardAndContents(String boardId) async {
    final db = DatabaseHelper.instance;
    final contents = await db.getAllContents(boardId);

    for (final content in contents) {
      final filePath = content.file;
      if (filePath != null && filePath.isNotEmpty) {
        final file = File(filePath);
        if (await file.exists()) {
          try {
            await file.delete();
          } catch (e) {
            debugPrint('Error deleting file during overwrite: $e');
          }
        }
      }
    }

    final database = await db.database;
    await database.delete(
      'contents',
      where: 'board_id = ?',
      whereArgs: [boardId],
    );
    await database.delete('boards', where: 'id = ?', whereArgs: [boardId]);
  }
}
