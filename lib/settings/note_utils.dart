import 'package:navinotes/packages.dart';

Future<void> goToNotePageWithContent({
  required Content content,
  required BuildContext context,
}) async {
  if (isNull(content.id)) {
    MessageDisplayService.showErrorMessage(context, 'Content ID not found!');
    return;
  }
  if (isNotNull(content.file)) {
    return handleOpenFile(content, context);
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
  String? title,
  String? contentBody,
}) async {
  debugPrint('Creating content in DB');
  debugPrint('Template: ${template.type.toString()}');
  debugPrint('Board ID: $boardId');
  debugPrint('Title: $title');
  debugPrint('Content Body: $contentBody');
  setLoading(true);
  try {
    final currentUser = getCurrentUserFromSession(context);
    if (isNotNull(currentUser)) {
      final currentTimestamp = generateUnixTimestamp();
      // Create a new Content object with default values
      final content = Content(
        guid: generateGUID(currentUser!.id!),
        type: AppContentType.note,
        metaData: {ContentMetadataKey.template: template.type.toString()},
        boardId: boardId,
        content: contentBody ?? '', // Empty by default
        createdAt: currentTimestamp,
        updatedAt: currentTimestamp,
        title: title ?? 'New Note - ${template.type.toString()}',
        coverImage: null,
      );
      // Insert into database
      final contentId = await DatabaseHelper.instance.insertContent(content);

      if (contentId == 0) {
        if (context.mounted) {
          MessageDisplayService.showErrorMessage(
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
      MessageDisplayService.showDefaultError(context);
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
    // case 'Date created':
    default:
      return NoteSortType.createdAt;
  }
}

AppContentType stringToAppContentType(String sortType) {
  return stringToEnum<AppContentType>(sortType, AppContentType.values);
}

formatSessionDate(CourseTimeline timeline) {
  String date = timeline.week;
  if (isNotNull(timeline.due)) {
    date += ', ${timeline.due}';
  }
  return date;
}

String getBoardDescription(Board board) {
  return board.description ??
      'Explore foundational concepts and key principles in this subject area through a mix of theoretical learning and practical application. This course offers an engaging introduction designed to build a solid understanding for further study';
}
