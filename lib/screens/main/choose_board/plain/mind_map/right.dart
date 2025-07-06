import 'package:navinotes/packages.dart';
import 'vm.dart';

final titleTextStyle = AppTheme.text.copyWith(
  color: AppTheme.asbestos,
  fontSize: 12.0,
);

class BoardPlainMindMapRight extends StatelessWidget {
  const BoardPlainMindMapRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Consumer<BoardPlainMindMapVm>(
        builder: (_, vm, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ScrollableController(
                  mobilePadding: EdgeInsets.all(15),
                  child: EditHeaderSection(
                    theme: BoardTheme.minimalist,
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
                          color: AppTheme.steelBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _shapeItem(BoardPlainMindMapVm vm, int index) {
    bool isSelected = vm.shape == index;
    bool radiusIs2 = index == 1 || index == 3;
    return InkWell(
      onTap: () => vm.updateShape(index),
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

  Widget _lineItem(BoardPlainMindMapVm vm, int index) {
    bool isSelected = vm.selectedLine == index;
    return _selectItem(
      isSelected: isSelected,
      onTap: () => vm.updateLine(index),
      icon: Images.straightLine,
    );
  }

  Widget _connectionLines(BoardPlainMindMapVm vm) {
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
              child: ScrollableController(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 10,
                  children: List.generate(4, (index) => _lineItem(vm, index)),
                ),
              ),
            ),
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

  Widget _nodeStyling(BoardPlainMindMapVm vm) {
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

  Widget _borderStyleItem(BoardPlainMindMapVm vm, BorderStyleItem item) {
    String text = item.toString();
    bool isSelected = vm.borderStyleItem == item;
    return _selectItem(
      text: text,
      isSelected: isSelected,
      onTap: () => vm.updateBorderItem(item),
    );
  }

  Widget _typography(BoardPlainMindMapVm vm) {
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

  Widget _weightItem(BoardPlainMindMapVm vm, FontWeight fontWeight) {
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
    return _selectItem(
      text: text,
      isSelected: isSelected,
      onTap: () => vm.updateFontWeight(fontWeight),
    );
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
