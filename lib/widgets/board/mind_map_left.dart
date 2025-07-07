import 'package:navinotes/packages.dart';

class MindMapLeft extends StatelessWidget {
  const MindMapLeft({super.key, required this.boardTheme});
  final BoardTheme boardTheme;
  @override
  Widget build(BuildContext context) {
    Color bgColor = AppTheme.transparent;
    switch (boardTheme) {
      case BoardTheme.plain:
        bgColor = AppTheme.ghostWhite;
        break;
      default:
    }
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
              child: Column(
                spacing: 30,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section(
                    title: 'Documents',
                    count: 12,
                    child: Column(
                      spacing: 10,
                      children: [
                        _imgRow(
                          img: Images.file2,
                          title: 'Cell Division Notes',
                        ),
                        _imgRow(
                          img: Images.pdf,
                          title: 'Genetic Disorders.pdf',
                        ),
                        _imgRow(img: Images.file2, title: 'Enzyme Kinetics'),
                      ],
                    ),
                  ),

                  _section(
                    title: 'Recent Imports',
                    count: 3,
                    child: Column(
                      spacing: 10,
                      children: [
                        _imgRow(
                          img: Images.pdf,
                          title: 'Immunology Review.pdf',
                        ),
                        _imgRow(
                          img: Images.imgCopy,
                          title: 'Neuron Structure.jpg',
                        ),
                      ],
                    ),
                  ),
                  MindMapFilterSelect(),
                  _section(
                    title: 'Tags',
                    child: Column(
                      spacing: 25,
                      children: [
                        _imgRow(title: 'Cellular Processes', right: '111'),
                        _imgRow(title: 'Genetic Studies', right: '111'),
                        _imgRow(title: 'Metabolic Pathways', right: '11'),
                      ],
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

class MindMapFilterSelect extends StatefulWidget {
  const MindMapFilterSelect({super.key});

  @override
  State<MindMapFilterSelect> createState() => _MindMapFilterSelectState();
}

class _MindMapFilterSelectState extends State<MindMapFilterSelect> {
  List<MindMapFilterType> selectedFilters = [
    MindMapFilterType.showPdf,
    MindMapFilterType.showNotes,
  ];
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

  void updateSelectedFilters(MindMapFilterType filter) {
    setState(() {
      selectedFilters.contains(filter)
          ? selectedFilters.remove(filter)
          : selectedFilters.add(filter);
    });
  }

  Widget _filterItem(MindMapFilterType type) {
    bool isSelected = selectedFilters.contains(type);
    return AppButton.text(
      onTap: () => updateSelectedFilters(type),
      spacing: 10,
      text: type.toString(),
      mainAxisSize: MainAxisSize.min,
      prefix:
          isSelected
              ? Container(
                width: 16,
                height: 16,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: AppTheme.dodgerBlue),
                  ),
                ),
              )
              : Icon(Icons.check_box, color: AppTheme.dodgerBlue, size: 16),
      style: AppTheme.text.copyWith(color: AppTheme.wetAsphalt),
    );
  }
}
