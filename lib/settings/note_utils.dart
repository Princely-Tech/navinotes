import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/models/page_format.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/packages.dart' as quill;

Future<void> goToNotePageWithContent({
  required Content content,
  required BuildContext context,
}) async {
  if (isNull(content.id)) {
    MessageDisplayService.showErrorMessage(context, 'Content ID not found!');
    return;
  }
  return NavigationHelper.navigateToContent(content);

  // if (isNotNull(content.file)) {
  //   return NavigationHelper.navigateToContent(content);
  // // }
  // BoardNoteTemplate template = getNoteTemplateFromString(
  //   content.metaData[ContentMetadataKey.template],
  // );
  // return NavigationHelper.navigateToNoteWithTemplate(
  //   template: template,
  //   contentId: content.id!,
  // );
}

// create node in mindmap
Future<void> createNodeInMindMap({
  required String boardId,
  required String text,
  String? connectedContentId,
}) async {
  // Create new mind map content
  final content = Content(
    title: text.isEmpty ? 'New Node' : text,
    type: AppContentType.mindmapNode,
    boardId: boardId,
    createdAt: generateUnixTimestamp(),
    updatedAt: generateUnixTimestamp(),
    metaData: {},
    connectedContentIds:
        connectedContentId != null ? jsonEncode([connectedContentId]) : null,
    nodeWidth: 200.0,
    nodeHeight: 100.0,
  );

  // Save to database
  await DatabaseHelper.instance.insertContent(content);

  final newContent = await DatabaseHelper.instance.getContentById(content.id);

  if (newContent != null) {
    return NavigationHelper.navigateToContent(newContent, replace: true);
  }
}

Future<void> createContentInDb({
  required BoardNoteTemplate template,
  required BuildContext context,
  required String boardId,
  required Function(bool) setLoading,
  String? title,
  String? contentBody,
  String? connectedContentId,
}) async {
  debugPrint('Creating content in DB');
  debugPrint('Template: ${template.type.toString()}');
  debugPrint('Board ID: $boardId');
  debugPrint('Title: $title');
  debugPrint('Content Body: $contentBody');
  setLoading(true);

  List<NotePage> _notePages = [];

  if (contentBody != null && contentBody.isNotEmpty) {
    // Convert plain text directly to Quill Delta JSON
    final textContentJson = jsonEncode([
      {"insert": "$contentBody\n"},
    ]);

    final newPage = NotePage(
      noteId: generateGUID(),
      pageNumber: _notePages.length + 1,
      format: PageFormat.defaultFormat,
      template: template,
      createdAt: generateUnixTimestamp(),
      updatedAt: generateUnixTimestamp(),
      textContent: textContentJson,
    );

    _notePages.add(newPage);
  }

  final pagesData = _notePages.map((page) => page.toMap()).toList();

  debugPrint('Pages Data: $pagesData');

  try {
    final currentUser = getCurrentUserFromSession(context);
    if (isNotNull(currentUser)) {
      final currentTimestamp = generateUnixTimestamp();
      // Create a new Content object with default values
      final content = Content(
        type: AppContentType.note,
        metaData: {
          ContentMetadataKey.template: template.type.toString(),
          'pages': pagesData,
        },
        boardId: boardId,
        content: contentBody ?? '', // Empty by default
        createdAt: currentTimestamp,
        updatedAt: currentTimestamp,
        title: title ?? 'New Note - ${template.type.toString()}',
        coverImage: null,
        connectedContentIds:
            connectedContentId != null
                ? jsonEncode([connectedContentId])
                : null,
      );

      // Insert into database
      final status = await DatabaseHelper.instance.insertContent(content);

      if (!status) {
        if (context.mounted) {
          MessageDisplayService.showErrorMessage(
            context,
            'Content creation failed',
          );
        }
      } else {
        debugPrint('Content created successfully ${content.id}');
        // After inserting, we fetch the content back to get the string ID
        final newContent = await DatabaseHelper.instance.getContentById(
          content.id,
        );

        if (newContent != null) {
          return NavigationHelper.navigateToContent(newContent, replace: true);
        }
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
  return board.description ?? '';
}
