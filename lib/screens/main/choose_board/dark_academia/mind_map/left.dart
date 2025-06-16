import 'package:navinotes/packages.dart';
import 'vm.dart';

class DarkAcademiaMindMapLeft extends StatelessWidget {
  const DarkAcademiaMindMapLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkAcademiaMindMapVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(color: Apptheme.burntClove.withAlpha(255)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ScrollableController(
                  mobilePadding: EdgeInsets.all(15),
                  child: RoyalGoldHeaderSection(
                    title: 'Advanced Biology',
                    child: Column(
                      spacing: 30,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _section(
                          title: 'Documents',
                          count: 12,
                          child: Column(
                            spacing: 25,
                            children: [
                              _imgRow(
                                img: Images.book2,
                                title: 'Cell Division Notes',
                              ),
                              _imgRow(
                                img: Images.pdf,
                                title: 'Genetic Disorders.pdf',
                              ),
                              _imgRow(
                                img: Images.scroll,
                                title: 'Enzyme Kinetics',
                              ),
                            ],
                          ),
                        ),

                        _section(
                          title: 'Recent Imports',
                          count: 3,
                          child: Column(
                            spacing: 25,
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
                        _section(
                          title: 'Filters',
                          child: Column(
                            spacing: 15,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                DarkAcademiaMindMapFilterType.values
                                    .map((filter) => _filterItem(filter, vm))
                                    .toList(),
                          ),
                        ),
                        _section(
                          title: 'Tags',
                          child: Column(
                            spacing: 25,
                            children: [
                              _imgRow(
                                title: 'Cellular Processes',
                                right: 'IIII',
                              ),
                              _imgRow(title: 'Genetic Studies', right: 'III'),
                              _imgRow(title: 'Metabolic Pathways', right: 'II'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterItem(
    DarkAcademiaMindMapFilterType type,
    DarkAcademiaMindMapVm vm,
  ) {
    bool isSelected = vm.selectedFilters.contains(type);
    return AppButton.text(
      onTap: () => vm.updateSelectedFilters(type),
      spacing: 10,
      text: type.toString(),
      mainAxisSize: MainAxisSize.min,
      prefix: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Apptheme.walnutBronze),
          ),
        ),
        padding: EdgeInsets.all(3),
        child: Container(
          width: 8,
          height: 8,
          color: isSelected ? Apptheme.goldenSaffron : null,
        ),
      ),
      style: TextStyle(
        color: Apptheme.creamMist,
        fontFamily: Apptheme.fontPlayfairDisplay,
        height: 1.43,
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
                  size: 18,
                  color: Apptheme.walnutBronze,
                ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Apptheme.creamMist,
                    fontFamily: Apptheme.fontPlayfairDisplay,
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
            style: TextStyle(
              color: Apptheme.walnutBronze,
              fontSize: 12.0,
              fontFamily: Apptheme.fontPlayfairDisplay,
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
                style: TextStyle(
                  color: Apptheme.creamMist.withAlpha(0xE5),
                  fontSize: 16.0,
                  fontFamily: Apptheme.fontPlayfairDisplay,
                  height: 1.50,
                ),
              ),
            ),
            if (isNotNull(count))
              Text(
                count.toString(),
                style: TextStyle(
                  color: Apptheme.goldenSaffron,
                  fontFamily: Apptheme.fontPlayfairDisplay,
                  height: 1.43,
                ),
              ),
          ],
        ),
        child,
      ],
    );
  }
}
