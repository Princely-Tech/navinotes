import 'package:navinotes/packages.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/settings/db_helpers.dart';
import 'package:navinotes/settings/board_theme.dart';
import 'vm.dart';

class MindMapDocuments extends StatefulWidget {
  const MindMapDocuments({super.key, required this.boardTheme});
  final BoardTheme boardTheme;

  @override
  State<MindMapDocuments> createState() => _MindMapDocumentsState();
}

class _MindMapDocumentsState extends State<MindMapDocuments> {
  List<Content> _contents = const [];
  List<Content> _decks = const [];
  final Map<int, int> _deckCardCounts = {};
  bool _loading = true;
  List<MindMapFilterType> _selectedFilters = const [
    MindMapFilterType.showPdf,
    MindMapFilterType.showNotes,
    MindMapFilterType.showImages,
    MindMapFilterType.showDecks,
  ];

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    try {
      final vm = Provider.of<MindMapVm>(context, listen: false);

      if (vm.baseContent == null) return;

      final data = await DatabaseHelper.instance.getAllContents(
        vm.baseContent!.boardId,
      );
      final decks = data.where((d) => d.type == AppContentType.flashcardDeck).toList();

      // Prefetch deck card counts once to avoid recalculating in build
      final Map<int, int> counts = {};
      await Future.wait(
        decks.where((d) => d.id != null).map((d) async {
          final c = await DatabaseHelper.instance.getDeckCardsCount(d.id!);
          counts[d.id!] = c;
        }),
      );
      if (!mounted) return;
      setState(() {
        _contents = data;
        _decks = decks;
        _deckCardCounts
          ..clear()
          ..addAll(counts);
        _loading = false;
      });
    } catch (e) {
      debugPrint('Failed to load contents: $e');
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _toggleFilter(MindMapFilterType type) {
    setState(() {
      if (_selectedFilters.contains(type)) {
        _selectedFilters = _selectedFilters.where((f) => f != type).toList();
      } else {
        _selectedFilters = [..._selectedFilters, type];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeValues = widget.boardTheme.values;
    final bgColor = themeValues.backgroundColor == AppTheme.transparent 
        ? AppTheme.ghostWhite 
        : themeValues.backgroundColor;

    final notes =
        _contents.where((c) => c.type == AppContentType.note).toList();
    final files =
        _contents.where((c) => c.type == AppContentType.file).toList();
    final pdfs = files.where((c) => _isPdf(c.file)).toList();
    final images = files.where((c) => _isImage(c.file)).toList();

    final showNotes = _selectedFilters.contains(MindMapFilterType.showNotes);
    final showPdfs = _selectedFilters.contains(MindMapFilterType.showPdf);
    final showImages = _selectedFilters.contains(MindMapFilterType.showImages);
    final showDecks = _selectedFilters.contains(MindMapFilterType.showDecks);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(right: BorderSide(color: themeValues.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ScrollableController(
              mobilePadding: EdgeInsets.all(15),
              child:
                  _loading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                        spacing: 30,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MindMapFilterSelect(
                            selectedFilters: _selectedFilters,
                            onToggle: _toggleFilter,
                          ),
                          if (showNotes)
                            _section(
                              title: 'Notes',
                              count: notes.length,
                              boardTheme: widget.boardTheme,
                              child: Column(
                                spacing: 10,
                                children:
                                    notes
                                        .map(
                                          (n) => _tappableRow(
                                            context: context,
                                            content: n,
                                            img: Images.file2,
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          if (showPdfs || showImages)
                            _section(
                              title: 'Imports',
                              count:
                                  (showPdfs ? pdfs.length : 0) +
                                  (showImages ? images.length : 0),
                              boardTheme: widget.boardTheme,
                              child: Column(
                                spacing: 10,
                                children: [
                                  if (showPdfs)
                                    ...pdfs.map(
                                      (f) => _tappableRow(
                                        context: context,
                                        content: f,
                                        img: Images.pdf,
                                      ),
                                    ),
                                  if (showImages)
                                    ...images.map(
                                      (f) => _tappableRow(
                                        context: context,
                                        content: f,
                                        img: Images.img,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          if (showDecks)
                            _section(
                              title: 'Flashcard Decks',
                              count: _decks.length,
                              boardTheme: widget.boardTheme,
                              child: Column(
                                spacing: 10,
                                children:
                                    _decks
                                        .map(
                                          (d) => _tappableDeckRow(
                                            context: context,
                                            deck: d,
                                            count: _deckCardCounts[d.id] ?? 0,
                                            boardTheme: widget.boardTheme,
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          Text(
                            'Drag and drop a document to create a new mind map',
                            style: AppTheme.text.copyWith(
                              color: themeValues.borderColor,
                              fontWeight: getFontWeight(400),
                              height: 1.43,
                              fontFamily: themeValues.fontFamily,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tappableRow({
    required BuildContext context,
    required Content content,
    required String img,
  }) {
    final title =
        content.title.isNotEmpty ? content.title : (content.file ?? 'Untitled');
    return Draggable<Content>(
      data: content,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 200,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.dodgerBlue, width: 2),
          ),
          child: _imgRow(title: title, img: img, boardTheme: widget.boardTheme),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _imgRow(title: title, img: img, boardTheme: widget.boardTheme),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final vm = Provider.of<MindMapVm>(context, listen: false);
          final targetNodeId = vm.attachingNodeId;
          if (targetNodeId != null && content.id != null) {
            vm.attachContentToNodeById(targetNodeId, content.id!);
            MessageDisplayService.showMessage(context, 'Attachment added');
          } else {
            // Not in attach mode: ensure any stale mode is cleared
            vm.cancelAttachMode();
          }
        },
        child: _imgRow(title: title, img: img, boardTheme: widget.boardTheme),
      ),
    );
  }

  bool _isPdf(String? path) {
    if (path == null) return false;
    final lower = path.toLowerCase();
    return lower.endsWith('.pdf');
  }

  bool _isImage(String? path) {
    if (path == null) return false;
    final lower = path.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp');
  }
}

Widget _tappableDeckRow({
  required BuildContext context,
  required Content deck,
  required int count,
  required BoardTheme boardTheme,
}) {
  return Draggable<Content>(
    data: deck,
    feedback: Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.dodgerBlue, width: 2),
        ),
        child: _imgRow(
          title: deck.title,
          img: Images.flashCards,
          right: '$count cards',
          boardTheme: boardTheme,
        ),
      ),
    ),
    childWhenDragging: Opacity(
      opacity: 0.5,
      child: _imgRow(
        title: deck.title,
        img: Images.flashCards,
        right: '$count cards',
        boardTheme: boardTheme,
      ),
    ),
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final vm = Provider.of<MindMapVm>(context, listen: false);
        final targetNodeId = vm.attachingNodeId;
        if (targetNodeId != null && deck.id != null) {
          vm.attachContentToNodeById(targetNodeId, deck.id!);
          MessageDisplayService.showMessage(context, 'Attachment added');
        } else {
          vm.cancelAttachMode();
        }
      },
      child: _imgRow(
        title: deck.title,
        img: Images.flashCards,
        right: '$count cards',
        boardTheme: boardTheme,
      ),
    ),
  );
}

Widget _imgRow({
  required String title, 
  required String img, 
  String? right,
  BoardTheme? boardTheme,
}) {
  final themeValues = boardTheme?.values;
  return Row(
    spacing: 10,
    children: [
      Expanded(
        child: Row(
          spacing: 15,
          children: [
            if (isNotNull(img))
              SVGImagePlaceHolder(
                imagePath: img,
                size: 14,
                color: themeValues?.color1 ?? AppTheme.steelBlue,
              ),
            Expanded(
              child: Text(
                title,
                style: AppTheme.text.copyWith(
                  color: themeValues?.color1 ?? AppTheme.wetAsphalt,
                  height: 1.43,
                  fontFamily: themeValues?.fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
      if (isNotNull(right))
        Text(
          right!,
          style: AppTheme.text.copyWith(
            color: themeValues?.borderColor ?? AppTheme.asbestos,
            fontSize: 12.0,
            height: 1.33,
            fontFamily: themeValues?.fontFamily,
          ),
        ),
    ],
  );
}

Widget _section({
  required String title, 
  int? count, 
  required Widget child,
  BoardTheme? boardTheme,
}) {
  final themeValues = boardTheme?.values;
  return Column(
    spacing: 20,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        spacing: 10,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTheme.text.copyWith(
                color: themeValues?.color1 ?? AppTheme.wetAsphalt,
                fontWeight: getFontWeight(500),
                height: 1.43,
                fontFamily: themeValues?.fontFamily,
              ),
            ),
          ),
          if (isNotNull(count))
            Text(
              count.toString(),
              style: AppTheme.text.copyWith(
                color: themeValues?.borderColor ?? AppTheme.asbestos,
                fontSize: 12.0,
                height: 1.33,
                fontFamily: themeValues?.fontFamily,
              ),
            ),
        ],
      ),
      child,
    ],
  );
}

class MindMapFilterSelect extends StatelessWidget {
  const MindMapFilterSelect({
    super.key,
    required this.selectedFilters,
    required this.onToggle,
  });

  final List<MindMapFilterType> selectedFilters;
  final void Function(MindMapFilterType) onToggle;

  @override
  Widget build(BuildContext context) {
    return _section(
      title: 'Filters',
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            MindMapFilterType.values
                .map((filter) => _filterItem(filter))
                .toList(),
      ),
    );
  }

  Widget _filterItem(MindMapFilterType type) {
    final isSelected = selectedFilters.contains(type);
    return AppButton.text(
      onTap: () => onToggle(type),
      spacing: 10,
      text: type.toString(),
      mainAxisSize: MainAxisSize.min,
      prefix:
          isSelected
              ? Icon(Icons.check_box, color: AppTheme.dodgerBlue, size: 16)
              : Container(
                width: 16,
                height: 16,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: AppTheme.dodgerBlue),
                  ),
                ),
              ),
      style: AppTheme.text.copyWith(color: AppTheme.wetAsphalt),
    );
  }
}
