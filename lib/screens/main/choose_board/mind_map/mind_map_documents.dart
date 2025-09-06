import 'package:navinotes/packages.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/settings/db_helpers.dart';
import 'vm.dart';

class MindMapDocuments extends StatefulWidget {
  const MindMapDocuments({super.key, required this.boardTheme});
  final BoardTheme boardTheme;

  @override
  State<MindMapDocuments> createState() => _MindMapDocumentsState();
}

class _MindMapDocumentsState extends State<MindMapDocuments> {
  List<Content> _contents = const [];
  bool _loading = true;
  List<MindMapFilterType> _selectedFilters = const [
    MindMapFilterType.showPdf,
    MindMapFilterType.showNotes,
    MindMapFilterType.showImages,
  ];

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    try {
      final vm = Provider.of<MindMapVm>(context, listen: false);
      final data = await DatabaseHelper.instance.getAllContents(vm.boardId);
      if (!mounted) return;
      setState(() {
        _contents = data;
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
    Color bgColor = AppTheme.transparent;
    switch (widget.boardTheme) {
      case BoardTheme.plain:
        bgColor = AppTheme.ghostWhite;
        break;
      default:
    }

    final notes =
        _contents.where((c) => c.type == AppContentType.note).toList();
    final files =
        _contents.where((c) => c.type == AppContentType.file).toList();
    final pdfs = files.where((c) => _isPdf(c.file)).toList();
    final images = files.where((c) => _isImage(c.file)).toList();

    final showNotes = _selectedFilters.contains(MindMapFilterType.showNotes);
    final showPdfs = _selectedFilters.contains(MindMapFilterType.showPdf);
    final showImages = _selectedFilters.contains(MindMapFilterType.showImages);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(right: BorderSide(color: AppTheme.lightGray)),
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
                              child: Column(
                                spacing: 10,
                                children:
                                    notes
                                        .map(
                                          (n) => _imgRow(
                                            img: Images.file2,
                                            title: n.title,
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
                              child: Column(
                                spacing: 10,
                                children: [
                                  if (showPdfs)
                                    ...pdfs.map(
                                      (f) => _imgRow(
                                        img: Images.pdf,
                                        title:
                                            f.title.isNotEmpty
                                                ? f.title
                                                : (f.file ?? 'PDF File'),
                                      ),
                                    ),
                                  if (showImages)
                                    ...images.map(
                                      (f) => _imgRow(
                                        img: Images.imgCopy,
                                        title:
                                            f.title.isNotEmpty
                                                ? f.title
                                                : (f.file ?? 'Image'),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          Text(
                            'Drag and drop a document to create a new mind map',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.asbestos,
                              fontWeight: getFontWeight(400),
                              height: 1.43,
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

Widget _imgRow({required String title, String? img, String? right}) {
  return Row(
    children: [
      Expanded(
        child: Row(
          spacing: 15,
          children: [
            if (isNotNull(img))
              SVGImagePlaceHolder(
                imagePath: img!,
                size: 14,
                color: AppTheme.steelBlue,
              ),
            Expanded(
              child: Text(
                title,
                style: AppTheme.text.copyWith(
                  color: AppTheme.wetAsphalt,
                  height: 1.43,
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
            color: AppTheme.asbestos,
            fontSize: 12.0,
            height: 1.33,
          ),
        ),
    ],
  );
}

Widget _section({required String title, int? count, required Widget child}) {
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
                color: AppTheme.wetAsphalt,
                fontWeight: getFontWeight(500),
                height: 1.43,
              ),
            ),
          ),
          if (isNotNull(count))
            Text(
              count.toString(),
              style: AppTheme.text.copyWith(
                color: AppTheme.asbestos,
                fontSize: 12.0,
                height: 1.33,
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
