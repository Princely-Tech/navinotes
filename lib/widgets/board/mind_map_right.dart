import 'package:navinotes/packages.dart';

enum MindMapBorderStyleItem {
  shadow,
  border,
  glow,
  noBorder;

  @override
  toString() {
    switch (this) {
      case shadow:
        return 'Shadow';
      case border:
        return 'Border';
      case glow:
        return 'Glow';
      case noBorder:
        return 'No Border';
    }
  }
}

final titleTextStyle = AppTheme.text.copyWith(
  color: AppTheme.asbestos,
  fontSize: 12.0,
);

class MindMapRight extends StatelessWidget {
  const MindMapRight({super.key, required this.boardTheme});
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
        border: Border(left: BorderSide(color: AppTheme.lightGray)),
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
                  _typography(),
                  _nodeStyling(),
                  AppButton(
                    onTap: () {},
                    text: 'Apply Changes',
                    color: AppTheme.steelBlue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectionLines() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: _section(
        title: 'Connection Lines',
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LineTypeSelect(),
            _titleSection(
              title: 'Connection Color',
              child: ScrollableController(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children:
                      [
                            AppTheme.steelBlue,
                            AppTheme.emerald,
                            AppTheme.mediumOrchid,
                            AppTheme.orange,
                            AppTheme.coralRed,
                            AppTheme.wetAsphalt,
                          ]
                          .map(
                            (color) => Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nodeStyling() {
    return _section(
      title: 'Node Styling',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          MindMapShapeSelect(),
          MindMapBorderStyleSelect(),
          _connectionLines(),
        ],
      ),
    );
  }

  Widget _typography() {
    return _section(
      title: 'Typography',
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            constraints: BoxConstraints(minHeight: 30),
            label: 'Font Family',
            labelStyle: titleTextStyle,
            selectItems: [],
          ),
          _titleSection(
            title: 'Font Size',
            child: CustomSlider(
              slider: Slider(value: 0.7, onChanged: (value) {}),
            ),
          ),
          MindMapFontWeightSelect(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _section(
              title: 'Opacity',
              child: CustomSlider(
                slider: Slider(value: 0.7, onChanged: (value) {}),
              ),
            ),
          ),
          _section(
            title: 'Color Tone',
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: Text(
                        'Cooler',
                        style: titleTextStyle.copyWith(fontSize: 12.0),
                      ),
                    ),
                    Text(
                      'Warmer',
                      style: titleTextStyle.copyWith(fontSize: 12.0),
                    ),
                  ],
                ),
                CustomSlider(
                  trackShape: GradientSliderTrackShape(
                    activeColor: AppTheme.dodgerBlue,
                    gradient: LinearGradient(
                      colors: [AppTheme.softSkyBlue, AppTheme.lightOrange],
                    ),
                  ),
                  slider: Slider(value: 0.7, onChanged: (value) {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.wetAsphalt,
            fontWeight: getFontWeight(500),
            height: 1.43,
          ),
        ),
        child,
      ],
    );
  }
}

Widget _selectItem({
  String? text,
  String? icon,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: ShapeDecoration(
        color: isSelected ? AppTheme.steelBlue.withValues(alpha: 0.1) : null,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isSelected ? AppTheme.steelBlue : AppTheme.aliceBlue,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          if (isNotNull(text))
            Text(
              text!,
              textAlign: TextAlign.center,
              style: AppTheme.text.copyWith(
                color: AppTheme.wetAsphalt,
                fontSize: 12.0,
              ),
            ),
          if (isNotNull(icon))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SVGImagePlaceHolder(imagePath: icon!),
            ),
        ],
      ),
    ),
  );
}

Widget _titleSection({required String title, required Widget child}) {
  return Column(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Text(title, style: titleTextStyle), child],
  );
}

class MindMapFontWeightSelect extends StatefulWidget {
  const MindMapFontWeightSelect({super.key});

  @override
  State<MindMapFontWeightSelect> createState() =>
      _MindMapFontWeightSelectState();
}

class _MindMapFontWeightSelectState extends State<MindMapFontWeightSelect> {
  FontWeight selectedFontWeight = FontWeight.w500;

  void updateFontWeight(FontWeight fontWeight) {
    setState(() {
      selectedFontWeight = fontWeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _titleSection(
      title: 'Font Weight',
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 10,
          children: [
            _weightItem(FontWeight.w300),
            _weightItem(FontWeight.w400),
            _weightItem(FontWeight.w500),
            _weightItem(FontWeight.w600),
          ],
        ),
      ),
    );
  }

  Widget _weightItem(FontWeight fontWeight) {
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
    bool isSelected = fontWeight == selectedFontWeight;
    return _selectItem(
      text: text,
      isSelected: isSelected,
      onTap: () => updateFontWeight(fontWeight),
    );
  }
}

class MindMapBorderStyleSelect extends StatefulWidget {
  const MindMapBorderStyleSelect({super.key});

  @override
  State<MindMapBorderStyleSelect> createState() =>
      _MindMapBorderStyleSelectState();
}

class _MindMapBorderStyleSelectState extends State<MindMapBorderStyleSelect> {
  MindMapBorderStyleItem borderStyleItem = MindMapBorderStyleItem.shadow;
  void updateBorderItem(MindMapBorderStyleItem item) {
    setState(() {
      borderStyleItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _titleSection(
      title: 'Border Style',
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 10,
          children:
              MindMapBorderStyleItem.values
                  .map((item) => _borderStyleItem(item))
                  .toList(),
        ),
      ),
    );
  }

  Widget _borderStyleItem(MindMapBorderStyleItem item) {
    String text = item.toString();
    bool isSelected = borderStyleItem == item;
    return _selectItem(
      text: text,
      isSelected: isSelected,
      onTap: () => updateBorderItem(item),
    );
  }
}

class MindMapShapeSelect extends StatefulWidget {
  const MindMapShapeSelect({super.key});

  @override
  State<MindMapShapeSelect> createState() => _MindMapShapeSelectState();
}

class _MindMapShapeSelectState extends State<MindMapShapeSelect> {
  int shape = 0;

  void updateShape(int shape) {
    setState(() {
      this.shape = shape;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _titleSection(
      title: 'Node Shape',
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 10,
          children: List.generate(4, (index) => _shapeItem(index)),
        ),
      ),
    );
  }

  Widget _shapeItem(int index) {
    bool isSelected = shape == index;
    bool radiusIs2 = index == 1 || index == 3;
    return InkWell(
      onTap: () => updateShape(index),
      child: Container(
        decoration: ShapeDecoration(
          color: isSelected ? AppTheme.iceBlue : AppTheme.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected ? AppTheme.vividBlue : AppTheme.lightGray,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Container(
          width: 32,
          height: 24,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(radiusIs2 ? 2 : 8),
          ),
        ),
      ),
    );
  }
}

class LineTypeSelect extends StatefulWidget {
  const LineTypeSelect({super.key});

  @override
  State<LineTypeSelect> createState() => _LineTypeSelectState();
}

class _LineTypeSelectState extends State<LineTypeSelect> {
  int selectedLine = 0;

  void updateLine(int line) {
    setState(() {
      selectedLine = line;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _titleSection(
      title: 'Line Type',
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 10,
          children: List.generate(4, (index) => _lineItem(index)),
        ),
      ),
    );
  }

  Widget _lineItem(int index) {
    bool isSelected = selectedLine == index;
    return _selectItem(
      isSelected: isSelected,
      onTap: () => updateLine(index),
      icon: Images.straightLine,
    );
  }
}
