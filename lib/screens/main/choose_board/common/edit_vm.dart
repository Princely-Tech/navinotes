import 'package:navinotes/packages.dart';

class BoardEditVm extends ChangeNotifier {
  BoardEditVm({this.scaffoldKey, required this.board});
  Board board;
  // bool _isLoading = true;
  String? _error;
  // bool _showSuccess = false;
  // String? _successMessage;

  GlobalKey<ScaffoldState>? scaffoldKey;
  final GlobalKey courseTimelineKey = GlobalKey();

  void scrollToCourseTimeline() {
    final context = courseTimelineKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

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

  CourseTimeline? getNextSession() {
    final now = DateTime.now();
    if (isNotNull(board) && isNotNull(board.courseTimeLines)) {
      for (var session in board.courseTimeLines!) {
        if (isNotNull(session.due)) {
          final dueDate = DateTime.parse(session.due!);
          // If the session's due date is today or in the future
          if (dueDate.isAfter(now) ||
              (dueDate.year == now.year &&
                  dueDate.month == now.month &&
                  dueDate.day == now.day)) {
            return session;
          }
        }
      }
    }
    return null; // Return null if no upcoming sessions
  }

  Future<void> goToBoardNotes() async {
    await NavigationHelper.navigateToBoardNotes(board);
    loadFiles(board.id!);
  }

  Future<void> goToNewNoteTemplate() async {
    if (isNotNull(board)) {
      await NavigationHelper.gotToNewNoteTemplate(board);
      loadFiles(board.id!);
    }
  }

  bool importingPdf = false;

  // Board? get board => _board;
  // bool get isLoading => _isLoading;
  String? get error => _error;
  // bool get showSuccess => _showSuccess;
  // String? get successMessage => _successMessage;

  bool savingFiles = false;

  void updateSelectedTab(EditBoardTab tab) {
    selectedTab = tab;
    notifyListeners();
  }

  // Initialize the ViewModel with board data
  Future<void> initialize() async {
    debugPrint('Initializing board with ID: ${board.id}');
    loadFiles(board.id!);
  }

  Future<void> importPdfFile(BuildContext context) async {
    try {
      importingPdf = true;
      notifyListeners();
      final currentUser = getCurrentUserFromSession(context);
      if (isNotNull(currentUser)) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        // if (isNotNull(result) && result!.files.isNotEmpty) {
        final pickedFile = result!.files.first;

        if (context.mounted) {
          int? id = await saveFileToDb(
            pickedFile: pickedFile,
            context: context,
            boardId: board.id!,
          );

          if (isNotNull(id)) {
            if (context.mounted) {
              MessageDisplayService.showMessage(
                context,
                'Successfully imported PDF file',
              );
            }
            await NavigationHelper.navigateToPdfView(id!);
            loadFiles(id);
          }
        }
        loadFiles(board.id!);
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
      importingPdf = false;
      notifyListeners();
    }
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
          int successCount = 0;

          for (var pickedFile in result.files) {
            if (context.mounted) {
              await saveFileToDb(
                pickedFile: pickedFile,
                context: context,
                boardId: board.id!,
              );
              successCount++;
            }
          }

          if (context.mounted) {
            if (successCount > 0) {
              MessageDisplayService.showMessage(
                context,
                'Successfully imported $successCount file(s)',
              );
              loadFiles(board.id!);
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

  Future uploadSyllabus({
    required BuildContext context,
    required ApiServiceProvider apiServiceProvider,
  }) async {
    try {
      if (uploadingSyllabus) return;
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
            final updatedBoard = board.copyWith(
              courseTimeLines: timeLines,
              courseInfo: CourseInfo.fromMap(
                response['response']['course_info'],
              ),
            );
            await dbHelper.updateBoard(updatedBoard);

            if (context.mounted) {
              MessageDisplayService.showMessage(
                context,
                'Syllabus uploaded successfully',
              );
            }
            return NavigationHelper.navigateToBoardPopup(board, replace: true);
          } else {
            throw Exception('Failed to process syllabus');
          }
        }
      }
      loadFiles(board.id!);
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

  Widget returnSelectedTabItem(Widget overviewTab) {
    switch (selectedTab) {
      case EditBoardTab.overview:
        return overviewTab;
      case EditBoardTab.uploads:
        return BoardEditUploads(this);
      case EditBoardTab.assignments:
        return BoardEditAssignment(this);
    }
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}
