import 'package:navinotes/packages.dart';
import 'vm.dart';

final titleTextStyle = Apptheme.text.copyWith(
  color: const Color(0xCCF4F1E8),
  fontFamily: Apptheme.fontPlayfairDisplay,
);

class DarkAcademiaMindMapRight extends StatelessWidget {
  const DarkAcademiaMindMapRight({super.key});

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
                    title: 'Customization',
                    child: Column(
                      spacing: 30,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _typography(vm),
                        _nodeStyling(vm),
                        AppButton(
                          onTap: () {},
                          text: 'Apply Changes',
                          color: Apptheme.goldenSaffron,
                          style: TextStyle(
                            color: Apptheme.burntClove.withAlpha(0xFF),
                            fontSize: 16.0,
                            fontFamily: Apptheme.fontPlayfairDisplay,
                            fontWeight: getFontWeight(500),
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

  Widget _shapeItem(DarkAcademiaMindMapVm vm, int index) {
    bool isSelected = vm.shape == index;
    bool radiusIs2 = index == 1 || index == 3;
    return InkWell(
      onTap: () => vm.updateShape(index),
      child: Container(
        decoration: ShapeDecoration(
          color: isSelected ? Apptheme.iceBlue : Apptheme.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected ? Apptheme.vividBlue : Apptheme.lightGray,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Container(
          width: 32,
          height: 24,
          decoration: BoxDecoration(
            color: Apptheme.white,
            borderRadius: BorderRadius.circular(radiusIs2 ? 2 : 8),
          ),
        ),
      ),
    );
  }

  Widget _lineItem(DarkAcademiaMindMapVm vm, String line) {
    bool isSelected = vm.selectedLine == line;
    Color color = isSelected ? Apptheme.vividBlue : Apptheme.white;
    return InkWell(
      onTap: () => vm.updateLine(line),
      child: OutlinedChild(
        size: 48,
        decoration: BoxDecoration(
          color: isSelected ? Apptheme.iceBlue : Apptheme.transparent,
          border: Border.all(color: color),
        ),
        child: SVGImagePlaceHolder(imagePath: line, color: color),
      ),
    );
  }

  Widget _connectionLines(DarkAcademiaMindMapVm vm) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: _section(
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
                children: [
                  _lineItem(vm, Images.squiglyLine),
                  _lineItem(vm, Images.straightLine),
                  _lineItem(vm, Images.zaggedLine),
                  _lineItem(vm, Images.curvyLine),
                ],
              ),
            ),
            _titleSection(
              title: 'Connection Color',
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double width = (constraints.maxWidth / 4) - 10;
                  if (width < 50) {
                    width = 50;
                  }
                  return ScrollableController(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            [
                                  Apptheme.goldenSaffron,
                                  Apptheme.walnutBronze,
                                  Apptheme.rustWood,
                                  Apptheme.gumMetalBlue,
                                ]
                                .map(
                                  (color) => Container(
                                    height: 24,
                                    width: width,
                                    color: color,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nodeStyling(DarkAcademiaMindMapVm vm) {
    return _section(
      title: 'Node Styling',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          _titleSection(
            title: 'Node Shape',
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
            child: ScrollableController(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children:
                    BorderStyleItem.values
                        .map((item) => _borderStyleItem(vm, item))
                        .toList(),
              ),
            ),
          ),
          _connectionLines(vm),
        ],
      ),
    );
  }

  Widget _borderStyleItem(DarkAcademiaMindMapVm vm, BorderStyleItem item) {
    String text = item.toString();
    bool isSelected = vm.borderStyleItem == item;
    return InkWell(
      onTap: () => vm.updateBorderItem(item),
      child: Container(
        decoration: ShapeDecoration(
          color: isSelected ? Apptheme.iceBlue : Apptheme.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected ? Apptheme.transparent : Apptheme.white,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Apptheme.text.copyWith(
            color: isSelected ? Apptheme.strongBlue : Apptheme.pastelBloom,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _typography(DarkAcademiaMindMapVm vm) {
    return _section(
      title: 'Typography',
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            constraints: BoxConstraints(minHeight: 30),
            fillColor: Apptheme.moltenBrown,
            label: 'Font Family',
            labelStyle: titleTextStyle,
            style: Apptheme.text.copyWith(color: Apptheme.walnutBronze),
            selectItems: [],
          ),
          _titleSection(
            title: 'Font Size',
            child: CustomSlider(
              slider: Slider(value: 0.7, onChanged: (value) {}),
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
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _titleSection(
              title: 'Opacity',
              child: CustomSlider(
                slider: Slider(value: 0.7, onChanged: (value) {}),
              ),
            ),
          ),
          _titleSection(
            title: 'Color Tone',
            spacing: 5,
            child: Row(
              spacing: 10,
              children: [
                Text('Cooler', style: titleTextStyle.copyWith(fontSize: 12.0)),
                Expanded(
                  child: CustomSlider(
                    slider: Slider(value: 0.7, onChanged: (value) {}),
                  ),
                ),
                Text('Warmer', style: titleTextStyle.copyWith(fontSize: 12.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weightItem(DarkAcademiaMindMapVm vm, FontWeight fontWeight) {
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
    return InkWell(
      onTap: () => vm.updateFontWeight(fontWeight),
      child: Container(
        decoration: ShapeDecoration(
          color: Apptheme.moltenBrown,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color:
                  isSelected
                      ? Apptheme.goldenSaffron.withAlpha(0x66)
                      : Apptheme.walnutBronze.withAlpha(0x33),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Apptheme.text.copyWith(
            color:
                isSelected
                    ? Apptheme.goldenSaffron
                    : Apptheme.creamMist.withAlpha(0xB2),
            fontSize: 12.0,
            fontFamily: Apptheme.fontPlayfairDisplay,
          ),
        ),
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

  Widget _section({required String title, required Widget child}) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Apptheme.text.copyWith(
            color: Apptheme.creamMist.withAlpha(0xE5),
            fontSize: 16.0,
            fontFamily: Apptheme.fontPlayfairDisplay,
            height: 1.50,
          ),
        ),
        child,
      ],
    );
  }
}
