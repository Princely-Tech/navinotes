import 'package:navinotes/packages.dart';

class BoardEditVm extends ChangeNotifier {
  BoardEditVm({this.scaffoldKey});
  Board? _board;
  bool _isLoading = true;
  String? _error;
  bool _showSuccess = false;
  String? _successMessage;

  GlobalKey<ScaffoldState>? scaffoldKey;

  EditBoardTab selectedTab = EditBoardTab.overview;

  bool fetchingFiles = false;
  List<Content> uploadedFiles = [];
  bool uploadingSyllabus = false;

  void updateUploadSyllabus(bool value) {
    uploadingSyllabus = value;
    notifyListeners();
  }

  Future<void> loadFiles(int boardId, {BuildContext? context}) async {
    fetchingFiles = true;
    notifyListeners();
    try {
      uploadedFiles = await DatabaseHelper.instance.getAllFiles(boardId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading files: $e');
      if (context != null && context.mounted) {
        MessageDisplayService.showErrorMessage(context, 'Failed to load files');
      }
    } finally {
      fetchingFiles = false;
      notifyListeners();
    }
  }

  void openDrawer() {
    scaffoldKey?.currentState?.openDrawer();
  }

  Board? get board => _board;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get showSuccess => _showSuccess;
  String? get successMessage => _successMessage;

  bool savingFiles = false;

  void updateSelectedTab(EditBoardTab tab) {
    selectedTab = tab;
    notifyListeners();
  }

  // Initialize the ViewModel with board data
  Future<void> initialize(
    int boardId, {
    bool showSuccess = false,
    String? message,
  }) async {
    debugPrint('Initializing board with ID: $boardId');
    _showSuccess = showSuccess;
    _successMessage = message;

    if (boardId > 0) {
      await _loadBoard(boardId);
      loadFiles(boardId);
    } else {
      _error = 'Your board cannot be loaded at this time. Please try again';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadBoard(int boardId) async {
    try {
      _isLoading = true;
      _error = null;
      _board = null; // Clear previous board data
      notifyListeners();

      final dbHelper = DatabaseHelper.instance;
      final board = await dbHelper.getBoard(boardId);

      debugPrint('Board loaded: ${board.name}');

      _board = board;
      _error = null;
    } catch (e) {
      debugPrint('Error loading board: $e');
      _error = 'Failed to load board: ${e.toString()}';
      _board = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void dismissSuccess() {
    _showSuccess = false;
    _successMessage = null;
    notifyListeners();
  }

  Future<void> importFiles(BuildContext context) async {
    try {
      savingFiles = true;
      notifyListeners();
      final currentUser = getCurrentUserFromSession(context);
      if (isNotNull(currentUser)) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            'pdf',
            'doc',
            'docx',
            'ppt',
            'pptx',
            'xls',
            'xlsx',
            'txt',
          ],
          allowMultiple: true,
        );

        if (isNotNull(result) && result!.files.isNotEmpty) {
          final dbHelper = DatabaseHelper.instance;
          final appDocDir = await getApplicationDocumentsDirectory();
          final filesDir = Directory('${appDocDir.path}/files');

          // Create the files directory if it doesn't exist
          if (!await filesDir.exists()) {
            await filesDir.create(recursive: true);
          }

          int successCount = 0;

          for (var pickedFile in result.files) {
            try {
              if (pickedFile.path == null) continue;

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
                boardId: _board!.id!,
                title: pickedFile.name,
                file: savedFile.path,
                createdAt: currentTimestamp,
                updatedAt: currentTimestamp,
                fileNeedSync: true,
              );

              await dbHelper.insertContent(content);

              // content.syncToBackend(apiServiceProvider); //TODO Work on synching created files to backend
              successCount++;
            } catch (e) {
              debugPrint('Error saving file ${pickedFile.name}: $e');
              if (context.mounted) {
                MessageDisplayService.showErrorMessage(
                  context,
                  'Error saving file ${pickedFile.name}: $e',
                );
              }
            }
          }

          if (context.mounted) {
            if (successCount > 0) {
              MessageDisplayService.showMessage(
                context,
                'Successfully imported $successCount file(s)',
              );
              loadFiles(board!.id!);
            } else {
              MessageDisplayService.showErrorMessage(
                context,
                'No files were imported',
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error importing files: $e');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Error importing files',
        );
      }
    } finally {
      savingFiles = false;
      notifyListeners();
    }
  }

  void uploadSyllabus({
    required BuildContext context,
    required ApiServiceProvider apiServiceProvider,
  }) async {
    try {
      updateUploadSyllabus(true);
      final currentUser = getCurrentUserFromSession(context);
      if (isNotNull(currentUser)) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'docx', 'txt'],
        );

        if (isNotNull(result) && result!.files.isNotEmpty) {
          final dbHelper = DatabaseHelper.instance;
          final file = File(result.files.first.path!);

          final imageBody = FormDataRequest.post(
            ApiEndpoints.boardSyllabus,
            files: {'syllabus_file': file},
          );

          final response = await apiServiceProvider.apiService
              .sendFormDataRequest(imageBody);

          if (response['response'] == null) {
            throw Exception('Failed to process syllabus. Try again');
          }
          print("Response == :");
          print("response $response");
          print("response ${response['response']}");
          print("weekly_outline ${response['response']['weekly_outline']}");
          print("course_info ${response['response']['course_info']}");

          final List<dynamic> syllabusData =
              response['response']['weekly_outline'];
          final List<CourseTimeline> timeLines =
              syllabusData.map((item) => CourseTimeline.fromMap(item)).toList();

          // Update the board with the new syllabus
          if (isNotNull(board)) {
            final updatedBoard = board!.copyWith(
              courseTimeLines: timeLines,
              courseInfo: CourseInfo.fromMap(
                response['response']['course_info'],
              ),
            );
            await dbHelper.updateBoard(updatedBoard);

            NavigationHelper.navigateToBoardPopup(board!, replace: true);

            if (context.mounted) {
              MessageDisplayService.showMessage(
                context,
                'Syllabus uploaded successfully',
              );
            }
          } else {
            throw Exception('Failed to process syllabus');
          }
        }
      }
    } catch (e) {
      debugPrint('Error Uploading syllabus $e');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Error uploading syllabus. Try again',
        );
      }
    } finally {
      updateUploadSyllabus(false);
    }
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}
