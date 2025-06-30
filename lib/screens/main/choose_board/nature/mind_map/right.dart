import 'package:navinotes/packages.dart';
import 'vm.dart';

final titleTextStyle = AppTheme.text.copyWith(
  color: AppTheme.coffee,
  fontFamily: AppTheme.fontCrimsonText,
  fontSize: 12.0,
);

class BoardNatureMindMapRight extends StatelessWidget {
  const BoardNatureMindMapRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNatureMindMapVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightSage,
            border: Border(
              left: BorderSide(color: AppTheme.burntLeather.withAlpha(0x33)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ScrollableController(
                  mobilePadding: EdgeInsets.all(15),
                  child: EditHeaderSection(
                    theme: BoardTheme.nature,
                    title: 'Mind Map Styling',
                    child: Column(
                      spacing: 30,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _typography(vm),
                        _section(
                          icon: Images.waterDrop,
                          title: 'Opacity',
                          child: Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: CustomSlider(
                                  slider: Slider(
                                    value: 0.7,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                              Text(
                                '80%',
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.darkMossGreen,
                                  fontSize: 12.0,
                                  fontFamily: AppTheme.fontCrimsonText,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _section(
                          icon: Images.draw,
                          title: 'Color Tone',
                          child: Column(
                            spacing: 5,
                            children: [
                              Row(
                                spacing: 10,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Cooler',
                                      style: titleTextStyle.copyWith(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Warmer',
                                      style: titleTextStyle.copyWith(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CustomSlider(
                                trackShape: GradientSliderTrackShape(
                                  activeColor: AppTheme.dodgerBlue,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.deepMoss,
                                      AppTheme.deepPeach.withAlpha(0xFF),
                                    ],
                                  ),
                                ),
                                slider: Slider(
                                  value: 0.7,
                                  onChanged: (value) {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        _nodeStyling(vm),
                        _connectionLines(vm),
                        AppButton(
                          onTap: () {},
                          minHeight: 36,
                          text: 'Apply Changes',
                          prefix: Icon(Icons.check, color: AppTheme.white),
                          color: AppTheme.deepMoss,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.white,
                            fontFamily: AppTheme.fontCrimsonText,
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

  Widget _shapeItem(BoardNatureMindMapVm vm, int index) {
    bool isSelected = vm.shape == index;
    String imagePath = Images.circle;
    switch (index) {
      case 1:
        imagePath = Images.rect;
        break;
      case 2:
        imagePath = Images.leaf;
        break;
      case 3:
        imagePath = Images.ques;
        break;
      default:
        imagePath = Images.circle;
    }
    return _selectContainer(
      onTap: () => vm.updateShape(index),
      isSelected: isSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SVGImagePlaceHolder(
          imagePath: imagePath,
          size: 12,
          color: isSelected ? AppTheme.white : AppTheme.coffee,
        ),
      ),
    );
  }

  Widget _lineItem(BoardNatureMindMapVm vm, BordeLineType line) {
    bool isSelected = vm.selectedLine == line;
    return _selectContainer(
      isSelected: isSelected,
      onTap: () => vm.updateLine(line),
      child: Text(
        line.toString(),
        textAlign: TextAlign.center,
        style: AppTheme.text.copyWith(
          color: isSelected ? AppTheme.white : AppTheme.coffee,
          fontSize: 12.0,
          fontFamily: AppTheme.fontCrimsonText,
        ),
      ),
    );
  }

  Widget _connectionLines(BoardNatureMindMapVm vm) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: _section(
        icon: Images.connection,
        title: 'Connection Lines',
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleSection(
              title: 'Line Type',
              child: CustomGrid(
                spacing: 10,
                mobile: 2,
                largeDesktop: 2,
                children:
                    BordeLineType.values
                        .map((item) => _lineItem(vm, item))
                        .toList(),
              ),
            ),
            _titleSection(
              title: 'Connection Color',
              child: ScrollableController(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children: [
                    ...[
                      AppTheme.deepMoss,
                      AppTheme.burntLeather.withAlpha(0xFF),
                      AppTheme.sageMist,
                      AppTheme.deepPeach.withAlpha(0xFF),
                    ].map(
                      (color) => Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.white, width: 2),
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    OutlinedChild(
                      size: 24,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: AppTheme.deepMoss),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 15,
                        color: AppTheme.deepMoss,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nodeStyling(BoardNatureMindMapVm vm) {
    return _section(
      icon: Images.copy2,
      title: 'Node Styling',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          _titleSection(
            title: 'Note Shape',
            child: ScrollableController(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: List.generate(4, (index) => _shapeItem(vm, index)),
              ),
            ),
          ),
          _titleSection(
            title: 'Border Style',
            child: CustomGrid(
              spacing: 10,
              mobile: 2,
              largeDesktop: 2,
              children:
                  BorderStyleItem.values
                      .map((item) => _borderStyleItem(vm, item))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _borderStyleItem(BoardNatureMindMapVm vm, BorderStyleItem item) {
    String text = item.toString();
    bool isSelected = vm.borderStyleItem == item;
    return _selectContainer(
      isSelected: isSelected,
      onTap: () => vm.updateBorderItem(item),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTheme.text.copyWith(
          color: isSelected ? AppTheme.white : AppTheme.coffee,
          fontSize: 12.0,
        ),
      ),
    );
  }

  Widget _typography(BoardNatureMindMapVm vm) {
    return _section(
      icon: Images.leaf,
      title: 'Typography',
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            constraints: BoxConstraints(maxHeight: 38),
            fillColor: AppTheme.linen,
            label: 'Font Family',
            labelStyle: titleTextStyle,
            style: AppTheme.text.copyWith(color: AppTheme.coffee),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(
                color: AppTheme.burntLeather.withAlpha(0x33),
              ),
            ),
          ),
          _titleSection(
            title: 'Font Size',
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: CustomSlider(
                    slider: Slider(value: 0.7, onChanged: (value) {}),
                  ),
                ),
                Text(
                  '14px',
                  style: AppTheme.text.copyWith(
                    color: AppTheme.darkMossGreen,
                    fontSize: 12.0,
                    fontFamily: AppTheme.fontCrimsonText,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
          _titleSection(
            title: 'Font Weight',
            child: ScrollableController(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  _weightItem(vm, FontWeight.w300),
                  _weightItem(vm, FontWeight.w400),
                  _weightItem(vm, FontWeight.w500),
                  _weightItem(vm, FontWeight.w600),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weightItem(BoardNatureMindMapVm vm, FontWeight fontWeight) {
    String text = '';
    switch (fontWeight) {
      case FontWeight.w300:
        text = 'Light';
        break;
      case FontWeight.w400:
        text = 'Regular';
        break;
      case FontWeight.w500:
        text = 'Medium';
        break;
      case FontWeight.w600:
        text = 'Bold';
        break;
      default:
        throw Exception('Invalid font weight');
    }
    bool isSelected = vm.fontWeight == fontWeight;
    return _selectContainer(
      isSelected: isSelected,
      onTap: () => vm.updateFontWeight(fontWeight),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTheme.text.copyWith(
          color: isSelected ? AppTheme.white : AppTheme.coffee,
          fontSize: 12.0,
          fontFamily: AppTheme.fontCrimsonText,
        ),
      ),
    );
  }

  Widget _selectContainer({
    required bool isSelected,
    required Widget child,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: isSelected ? AppTheme.deepMoss : AppTheme.linen,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  isSelected
                      ? AppTheme.deepMoss
                      : AppTheme.burntLeather.withAlpha(0x19),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: child,
      ),
    );
  }

  Widget _titleSection({
    required String title,
    required Widget child,
    double spacing = 10,
  }) {
    return Column(
      spacing: spacing,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(title, style: titleTextStyle), child],
    );
  }

  Widget _section({
    required String title,
    required String icon,
    required Widget child,
  }) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 6,
          children: [
            SVGImagePlaceHolder(
              imagePath: icon,
              size: 12,
              color: AppTheme.deepMoss,
            ),
            Expanded(
              child: Text(
                title,
                style: AppTheme.text.copyWith(
                  color: AppTheme.darkMossGreen,
                  fontFamily: AppTheme.fontCrimsonText,
                  height: 1.43,
                ),
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }
}
