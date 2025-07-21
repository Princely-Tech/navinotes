import 'package:navinotes/packages.dart';

class NoteTemplateVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardNoteTemplate selectedTemplate = noteTemplateBlank;
  final dbHelper = DatabaseHelper.instance;
  BuildContext context;
  Board? board;
  NoteTemplateVm({
    required this.scaffoldKey,
    required this.context,
    required this.board,
  });

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  double dotSize = 0;
  String selectedSection = noteTemplatesSections[0];
  void updateSelectedSection(String section) {
    selectedSection = section;
    notifyListeners();
  }

  void updateSelectedTemplate(BoardNoteTemplate template) {
    selectedTemplate = template;
    notifyListeners();
  }

  void updateDotSize(double value) {
    dotSize = value;
    notifyListeners();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  // void goToUploadPdf() {
  //   NavigationHelper.push(Routes.uploadPdf);
  // }

  // void goToImportNotes() {
  //   NavigationHelper.push(Routes.importNotes);
  // }

  Future<void> createNote() async {
    _setLoading(true);
    try {
      final sessionManager =
          NavigationHelper.navigatorKey.currentContext!.read<SessionManager>();
      final currentUser = sessionManager.user;

      if (isNull(currentUser)) {
        if (context.mounted) {
          ErrorDisplayService.showMessage(
            context,
            'User not logged in',
            isError: true,
          );
        }
        _setLoading(false);
        return;
      }

      final currentTimestamp = generateUnixTimestamp();

      // Create a new Content object with default values
      final content = Content(
        guid: generateGUID(currentUser!.id!),
        type: AppContentType.note.toString(),
        metaData: {
          ContentMetadataKey.template: selectedTemplate.type.toString(),
        },
        boardId: board!.id!,
        content: '', // Empty by default
        createdAt: currentTimestamp,
        updatedAt: currentTimestamp,
        title: 'New Note',
        coverImage: null,
      );
      // // // Insert into database
      final contentId = await dbHelper.insertContent(content);

      if (contentId == 0) {
        if (context.mounted) {
          ErrorDisplayService.showMessage(
            context,
            'Failed to save note to database',
            isError: true,
          );
        }
        _setLoading(false);
      }

      debugPrint('Created content $contentId');

      // Navigate based on the template
      if (isNotNull(selectedTemplate.route)) {
        NavigationHelper.navigateToNoteTemplateRoute(
          selectedTemplate.route!,
          contentId,
        );
      } else {
        NavigationHelper.navigateToNoteCreation(selectedTemplate, contentId);
      }
    } catch (e) {
      debugPrint('Error creating note: $e');
      if (context.mounted) {
        ErrorDisplayService.showDefaultError(context);
      }
    } finally {
      _setLoading(false);
    }
  }

  // Future<void> createNote() async {
  //   _setLoading(true);
  //   try {
  //     await dbHelper.insertContent(Content());
  //     if (isNotNull(selectedTemplate.route)) {
  //       NavigationHelper.push(selectedTemplate.route!);
  //     } else {
  //       NavigationHelper.navigateToNoteCreation(selectedTemplate);
  //     }
  //   } catch (e) {
  //     // debugPrint('Error creating note: $e');
  //     // if (context.mounted) {
  //     //   ErrorDisplayService.showDefaultError(context);
  //     // }
  //   } finally {
  //     _setLoading(false);
  //   }
  // }
}
