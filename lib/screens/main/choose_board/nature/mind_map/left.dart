import 'package:navinotes/packages.dart';
import 'vm.dart';

class BoardNatureMindMapLeft extends StatelessWidget {
  const BoardNatureMindMapLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNatureMindMapVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.linen,
            border: Border(
              right: BorderSide(color: AppTheme.burntLeather.withAlpha(0x33)),
            ),
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
                      CustomInputField(
                        prefixIcon: SVGImagePlaceHolder(
                          imagePath: Images.leaf,
                          size: 16,
                        ),
                        hintText: 'Search anything...',
                        constraints: BoxConstraints(maxHeight: 38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: AppTheme.burntLeather.withAlpha(0x4C),
                          ),
                        ),
                        hintStyle: AppTheme.text.copyWith(
                          color: AppTheme.slateGray,
                          fontFamily: AppTheme.fontCrimsonText,
                          height: 1.43,
                        ),
                      ),
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
                            _imgRow(
                              img: Images.file2,
                              title: 'Enzyme Kinetics',
                            ),
                          ],
                        ),
                      ),

                      _section(
                        title: 'Recent Imports',
                        count: 5,
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
                      _section(
                        title: 'Filters',
                        child: Column(
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              MindMapFilterType.values
                                  .map((filter) => _filterItem(filter, vm))
                                  .toList(),
                        ),
                      ),
                      _section(
                        title: 'Tags',
                        child: Column(
                          spacing: 10,
                          children: [
                            _imgRow(title: 'Cellular Processes', right: 'IIII'),
                            _imgRow(title: 'Genetic Studies', right: 'III'),
                            _imgRow(title: 'Metabolic Pathways', right: 'II'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _bottomItem(),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomItem() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.burntLeather.withAlpha(0x33)),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: Row(
              spacing: 10,
              children: [
                ProfilePic(size: 32),
                Expanded(
                  child: Text(
                    'janesmith',
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.text.copyWith(
                      color: AppTheme.coffee,
                      fontSize: 16.0,
                      fontFamily: AppTheme.fontCrimsonText,
                      height: 1.50,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SVGImagePlaceHolder(imagePath: Images.ques3, size: 16),
        ],
      ),
    );
  }

  Widget _filterItem(MindMapFilterType type, BoardNatureMindMapVm vm) {
    bool isSelected = vm.selectedFilters.contains(type);
    return AppButton.text(
      onTap: () => vm.updateSelectedFilters(type),
      spacing: 7,
      text: type.toString(),
      mainAxisSize: MainAxisSize.min,
      prefix:
          isSelected
              ? SVGImagePlaceHolder(imagePath: Images.check, size: 16)
              : Container(
                width: 16,
                height: 16,
                decoration: ShapeDecoration(
                  color: AppTheme.lightSage,
                  shape: CircleBorder(
                    side: BorderSide(color: AppTheme.deepMoss.withAlpha(0x4C)),
                  ),
                ),
              ),
      style: AppTheme.text.copyWith(
        color: AppTheme.coffee,
        fontFamily: AppTheme.fontCrimsonText,
        height: 1.43,
      ),
    );
  }

  Widget _imgRow({required String title, String? img, String? right}) {
    return Row(
      children: [
        Expanded(
          child: Row(
            spacing: 10,
            children: [
              if (isNotNull(img))
                SVGImagePlaceHolder(
                  imagePath: img!,
                  size: 14,
                  color: AppTheme.sageMist,
                ),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.text.copyWith(
                    color: AppTheme.coffee,
                    fontFamily: AppTheme.fontCrimsonText,
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
              color: AppTheme.deepMoss,
              fontSize: 12.0,
              fontFamily: AppTheme.fontCrimsonText,
              height: 1.33,
            ),
          ),
      ],
    );
  }

  Widget _section({required String title, int? count, required Widget child}) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: AppTheme.text.copyWith(
                  color: AppTheme.darkMossGreen,
                  fontFamily: AppTheme.fontLibreBaskerville,
                  height: 1.43,
                ),
              ),
              if (isNotNull(count))
                TextSpan(
                  text: ' $count',
                  style: AppTheme.text.copyWith(
                    color: AppTheme.coffee,
                    fontFamily: AppTheme.fontLibreBaskerville,
                    height: 1.43,
                  ),
                ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}
