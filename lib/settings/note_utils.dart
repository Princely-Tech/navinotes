import 'package:navinotes/packages.dart';

Future<T?> goToNotePageWithContent<T>({
  required Content content,
  required BuildContext context,
}) async {
  if (isNull(content.id)) {
    ErrorDisplayService.showErrorMessage(context, 'Content ID not found!');
    return null;
  }
  BoardNoteTemplate template = getNoteTemplateFromString(
    content.metaData[ContentMetadataKey.template],
  );
  return NavigationHelper.navigateToNoteWithTemplate(
    template: template,
    contentId: content.id!,
  );
}

Future<void> createContentInDb({
  required BoardNoteTemplate template,
  required BuildContext context,
  required int boardId,
  required Function(bool) setLoading,
}) async {
  setLoading(true);
  try {
    final sessionManager =
        NavigationHelper.navigatorKey.currentContext!.read<SessionManager>();
    final currentUser = sessionManager.user;
    if (isNull(currentUser)) {
      if (context.mounted) {
        ErrorDisplayService.showErrorMessage(context, 'User not logged in');
      }
      NavigationHelper.logOut();
    } else {
      final currentTimestamp = generateUnixTimestamp();
      // Create a new Content object with default values
      final content = Content(
        guid: generateGUID(currentUser!.id!),
        type: AppContentType.note.toString(),
        metaData: {ContentMetadataKey.template: template.type.toString()},
        boardId: boardId,
        content: '', // Empty by default
        createdAt: currentTimestamp,
        updatedAt: currentTimestamp,
        title: 'New Note - ${template.type.toString()}',
        coverImage: null,
      );
      // Insert into database
      final contentId = await DatabaseHelper.instance.insertContent(content);

      if (contentId == 0) {
        if (context.mounted) {
          ErrorDisplayService.showErrorMessage(
            context,
            'Content creation failed',
          );
        }
      } else {
        debugPrint('Created content $contentId');
        // Navigate based on the template
        return NavigationHelper.navigateToNoteWithTemplate(
          template: template,
          contentId: contentId,
        );
      }
    }
  } catch (e) {
    debugPrint('Error creating note: $e');
    if (context.mounted) {
      ErrorDisplayService.showDefaultError(context);
    }
  } finally {
    setLoading(false);
  }
}
String noteSortTypeToString(NoteSortType sortType) {
  switch (sortType) {
    case NoteSortType.updatedAt:
      return 'Last modified';
    case NoteSortType.createdAt:
      return 'Date created';
  }
}

NoteSortType stringToNoteSortType(String sortType) {
  switch (sortType) {
    case 'Last modified':
      return NoteSortType.updatedAt;
    case 'Date created':
      return NoteSortType.createdAt;
    default:
      throw 'Invalid sort type: $sortType';
  }
}

