import 'package:navinotes/models/mind_map_edge.dart';
import 'package:navinotes/packages.dart';
import 'package:provider/provider.dart';
import 'vm.dart';
import 'package:navinotes/models/mind_map_node.dart';

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

TextStyle getTitleTextStyle(BoardTheme boardTheme) {
  final themeValues = boardTheme.values;
  return AppTheme.text.copyWith(
    color: themeValues.color1,
    fontSize: 12.0,
    fontFamily: themeValues.fontFamily,
  );
}

class MindMapStyling extends StatelessWidget {
  const MindMapStyling({super.key, required this.boardTheme, required this.vm});
  final BoardTheme boardTheme;
  final MindMapVm vm;
  @override
  Widget build(BuildContext context) {
    final themeValues = boardTheme.values;
    Color bgColor =
        themeValues.backgroundColor == AppTheme.transparent
            ? AppTheme.ghostWhite
            : themeValues.backgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(left: BorderSide(color: themeValues.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ScrollableController(
              mobilePadding: EdgeInsets.all(15),
              child: Consumer<MindMapVm>(
                builder: (_, vm, __) {
                  final bool showEdgeStyling = vm.selectedEdgeId != null;
                  return Column(
                    spacing: 30,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!showEdgeStyling) ...[
                        _typography(),
                        _nodeStyling(vm),
                      ] else ...[
                        _connectionLines(context),
                      ],
                      // AppButton(
                      //   onTap: () {},
                      //   text: 'Apply Changes',
                      //   color: AppTheme.steelBlue,
                      // ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectionLines(BuildContext context) {
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
              boardTheme: boardTheme,
              child: ScrollableController(
                scrollDirection: Axis.horizontal,
                child: Consumer<MindMapVm>(
                  builder: (_, vm, __) {
                    return Row(
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
                                (color) => _colorDot(
                                  color: color,
                                  onTap: vm.updateSelectedEdgeColor,
                                  vm: vm,
                                ),
                              )
                              .toList(),
                    );
                  },
                ),
              ),
            ),
            _titleSection(
              title: 'Line Thickness',
              boardTheme: boardTheme,
              child: Consumer<MindMapVm>(
                builder: (_, vm, __) {
                  final edge =
                      vm.selectedEdgeId == null
                          ? null
                          : vm.mindMap.findEdge(vm.selectedEdgeId!);
                  final value = edge?.thickness ?? 2.0;
                  return CustomSlider(
                    slider: Slider(
                      min: 0.5,
                      max: 12.0,
                      value: value.clamp(0.5, 12.0),
                      onChanged: vm.updateSelectedEdgeThickness,
                    ),
                  );
                },
              ),
            ),
            _titleSection(
              title: 'Line Opacity',
              boardTheme: boardTheme,
              child: Consumer<MindMapVm>(
                builder: (_, vm, __) {
                  final edge =
                      vm.selectedEdgeId == null
                          ? null
                          : vm.mindMap.findEdge(vm.selectedEdgeId!);
                  final value = edge?.opacity ?? 1.0;
                  return CustomSlider(
                    slider: Slider(
                      min: 0.0,
                      max: 1.0,
                      value: value.clamp(0.0, 1.0),
                      onChanged: vm.updateSelectedEdgeOpacity,
                    ),
                  );
                },
              ),
            ),
            // Delete edge button
            _titleSection(
              title: 'Actions',
              boardTheme: boardTheme,
              child: Consumer<MindMapVm>(
                builder: (_, vm, __) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          vm.selectedEdgeId != null
                              ? () => vm.deleteEdgeWithConfirmation(
                                context,
                                vm.selectedEdgeId!,
                              )
                              : null,
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        'Delete Connection',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _nodeStyling(MindMapVm vm) {
    return _section(
      title: 'Node Styling',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          MindMapShapeSelect(),
          MindMapBorderStyleSelect(),
          _titleSection(
            title: 'Node Background Color',
            child: ScrollableController(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children:
                    [
                          Colors.white,
                          AppTheme.lightSage,
                          AppTheme.steelBlue,
                          AppTheme.emerald,
                          AppTheme.mediumOrchid,
                          AppTheme.orange,
                          AppTheme.coralRed,
                          AppTheme.wetAsphalt,
                        ]
                        .map(
                          (color) => _colorDot(
                            color: color,
                            onTap: vm.updateSelectedNodeBackgroundColor,
                            vm: vm,
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          _titleSection(
            title: 'Node Text Color',
            child: ScrollableController(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children:
                    [
                          AppTheme.white,
                          AppTheme.black,
                          AppTheme.lightGray,
                          AppTheme.asbestos,
                          AppTheme.wetAsphalt,
                        ]
                        .map(
                          (color) => _colorDot(
                            color: color,
                            onTap: vm.updateSelectedNodeTextColor,
                            vm: vm,
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          _titleSection(
            title: 'Size (px)',
            child: Consumer<MindMapVm>(
              builder: (_, vm, __) {
                final node =
                    vm.selectedNodeId == null
                        ? null
                        : vm.mindMap.findNode(vm.selectedNodeId!);
                final double width = (node?.width ?? 160).clamp(150.0, 600.0);
                final double height = (node?.height ?? 80).clamp(80.0, 400.0);
                void setWidth(double w) {
                  if (node == null) return;
                  final newW = w.clamp(150.0, 600.0);
                  vm.updateNodeSize(node.id, newW, node.height);
                }

                void setHeight(double h) {
                  if (node == null) return;
                  final newH = h.clamp(80.0, 400.0);
                  vm.updateNodeSize(
                    node.id,
                    node.width,
                    newH,
                  );
                }

                return Column(
                  spacing: 8,
                  children: [
                    _sizeRow(
                      label: 'Width',
                      value: width,
                      step: 10,
                      min: 60,
                      max: 600,
                      onChanged: setWidth,
                    ),
                    _sizeRow(
                      label: 'Height',
                      value: height,
                      step: 10,
                      min: 40,
                      max: 400,
                      onChanged: setHeight,
                    ),
                  ],
                );
              },
            ),
          ),
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
          // CustomInputField(
          //   constraints: BoxConstraints(minHeight: 30),
          //   label: 'Font Family',
          //   labelStyle: titleTextStyle,
          //   selectItems: [],
          // ),
          _titleSection(
            title: 'Font Size',
            child: Consumer<MindMapVm>(
              builder: (_, vm, __) {
                final node =
                    vm.selectedNodeId == null
                        ? null
                        : vm.mindMap.findNode(vm.selectedNodeId!);
                final value = node?.fontSize ?? 14.0;
                return CustomSlider(
                  slider: Slider(
                    min: 8.0,
                    max: 48.0,
                    value: value.clamp(8.0, 48.0),
                    onChanged: (v) => vm.updateSelectedNodeFontSize(v),
                  ),
                );
              },
            ),
          ),
          MindMapFontWeightSelect(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _section(
              title: 'Opacity',
              child: Consumer<MindMapVm>(
                builder: (_, vm, __) {
                  final node =
                      vm.selectedNodeId == null
                          ? null
                          : vm.mindMap.findNode(vm.selectedNodeId!);
                  final value = node?.opacity ?? 1.0;
                  return CustomSlider(
                    slider: Slider(
                      min: 0.0,
                      max: 1.0,
                      value: value.clamp(0.0, 1.0),
                      onChanged: (v) => vm.updateSelectedNodeOpacity(v),
                    ),
                  );
                },
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
                        style: getTitleTextStyle(
                          boardTheme,
                        ).copyWith(fontSize: 12.0),
                      ),
                    ),
                    Text(
                      'Warmer',
                      style: getTitleTextStyle(
                        boardTheme,
                      ).copyWith(fontSize: 12.0),
                    ),
                  ],
                ),
                Consumer<MindMapVm>(
                  builder: (_, vm, __) {
                    final node =
                        vm.selectedNodeId == null
                            ? null
                            : vm.mindMap.findNode(vm.selectedNodeId!);
                    final value = node?.colorTone ?? 0.0;
                    return CustomSlider(
                      trackShape: GradientSliderTrackShape(
                        activeColor: AppTheme.dodgerBlue,
                        gradient: LinearGradient(
                          colors: [AppTheme.softSkyBlue, AppTheme.lightOrange],
                        ),
                      ),
                      slider: Slider(
                        min: -1.0,
                        max: 1.0,
                        value: value.clamp(-1.0, 1.0),
                        onChanged: (v) => vm.updateSelectedNodeColorTone(v),
                      ),
                    );
                  },
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

Widget _colorDot({
  required Color color,
  required Function(Color) onTap,
  required MindMapVm vm,
}) {
  return InkWell(
    onTap: () => onTap(color),
    child: Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: vm.boardTheme.values.toolBorderColor,
          width: 1.5,
        ),
      ),
    ),
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

Widget _titleSection({
  required String title,
  required Widget child,
  BoardTheme? boardTheme,
}) {
  return Column(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: getTitleTextStyle(boardTheme ?? BoardTheme.plain)),
      child,
    ],
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
    final vm = context.read<MindMapVm>();
    final int weight = _weightToInt(fontWeight);
    vm.updateSelectedNodeFontWeight(weight);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MindMapVm>();
    final node =
        vm.selectedNodeId == null
            ? null
            : vm.mindMap.findNode(vm.selectedNodeId!);
    if (node != null) {
      selectedFontWeight = _intToFontWeight(node.fontWeight);
    }
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

  int _weightToInt(FontWeight w) {
    if (w == FontWeight.w300) return 300;
    if (w == FontWeight.w400) return 400;
    if (w == FontWeight.w500) return 500;
    if (w == FontWeight.w600) return 600;
    return 500;
  }

  FontWeight _intToFontWeight(int w) {
    switch (w) {
      case 300:
        return FontWeight.w300;
      case 400:
        return FontWeight.w400;
      case 500:
        return FontWeight.w500;
      case 600:
        return FontWeight.w600;
      default:
        return FontWeight.w500;
    }
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
    final vm = context.read<MindMapVm>();
    vm.updateSelectedNodeBorderStyle(_toModelBorder(item));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MindMapVm>();
    final node =
        vm.selectedNodeId == null
            ? null
            : vm.mindMap.findNode(vm.selectedNodeId!);
    if (node != null) {
      borderStyleItem = _toUiBorder(node.borderStyle);
    }
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

  MindMapBorderStyle _toModelBorder(MindMapBorderStyleItem item) {
    switch (item) {
      case MindMapBorderStyleItem.shadow:
        return MindMapBorderStyle.shadow;
      case MindMapBorderStyleItem.border:
        return MindMapBorderStyle.border;
      case MindMapBorderStyleItem.glow:
        return MindMapBorderStyle.glow;
      case MindMapBorderStyleItem.noBorder:
        return MindMapBorderStyle.none;
    }
  }

  MindMapBorderStyleItem _toUiBorder(MindMapBorderStyle style) {
    switch (style) {
      case MindMapBorderStyle.shadow:
        return MindMapBorderStyleItem.shadow;
      case MindMapBorderStyle.border:
        return MindMapBorderStyleItem.border;
      case MindMapBorderStyle.glow:
        return MindMapBorderStyleItem.glow;
      case MindMapBorderStyle.none:
        return MindMapBorderStyleItem.noBorder;
    }
  }
}

class MindMapShapeSelect extends StatefulWidget {
  const MindMapShapeSelect({super.key});

  @override
  State<MindMapShapeSelect> createState() => _MindMapShapeSelectState();
}

class _MindMapShapeSelectState extends State<MindMapShapeSelect> {
  MindMapShape selectedShape = MindMapShape.rounded;

  void updateShape(MindMapShape shape) {
    setState(() => selectedShape = shape);
    final vm = context.read<MindMapVm>();
    vm.updateSelectedNodeShape(shape);
    // For legacy rounded/sharp choices, also sync a sensible borderRadius
    if (shape == MindMapShape.rounded) vm.updateSelectedNodeBorderRadius(8.0);
    if (shape == MindMapShape.sharp) vm.updateSelectedNodeBorderRadius(0.0);
    if (shape == MindMapShape.pill) vm.updateSelectedNodeBorderRadius(999.0);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MindMapVm>();
    final node =
        vm.selectedNodeId == null
            ? null
            : vm.mindMap.findNode(vm.selectedNodeId!);
    if (node != null) {
      selectedShape = node.shape;
    }
    return _titleSection(
      title: 'Node Shape',
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 10,
          children: [
            _shapeItem(MindMapShape.rounded),
            _shapeItem(MindMapShape.sharp),
            _shapeItem(MindMapShape.pill),
            _shapeItem(MindMapShape.circle),
            _shapeItem(MindMapShape.diamond),
            _shapeItem(MindMapShape.hexagon),
            _shapeItem(MindMapShape.parallelogram),
            _shapeItem(MindMapShape.octagon),
            _shapeItem(MindMapShape.trapezoid),
          ],
        ),
      ),
    );
  }

  Widget _shapeItem(MindMapShape shape) {
    final bool isSelected = selectedShape == shape;
    return InkWell(
      onTap: () => updateShape(shape),
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
        child: _shapePreview(shape),
      ),
    );
  }

  Widget _shapePreview(MindMapShape shape) {
    const double w = 32;
    const double h = 24;
    final base = Container(width: w, height: h, color: AppTheme.white);
    switch (shape) {
      case MindMapShape.rounded:
        return Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      case MindMapShape.sharp:
        return Container(width: w, height: h, color: AppTheme.white);
      case MindMapShape.pill:
        return Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      case MindMapShape.circle:
        return ClipOval(child: base);
      case MindMapShape.diamond:
        return ClipPath(clipper: _DiamondPreviewClipper(), child: base);
      case MindMapShape.hexagon:
        return ClipPath(clipper: _HexagonPreviewClipper(), child: base);
      case MindMapShape.parallelogram:
        return ClipPath(clipper: _ParallelogramPreviewClipper(), child: base);
      case MindMapShape.octagon:
        return ClipPath(clipper: _OctagonPreviewClipper(), child: base);
      case MindMapShape.trapezoid:
        return ClipPath(clipper: _TrapezoidPreviewClipper(), child: base);
    }
  }
}

class _DiamondPreviewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    return Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w, h / 2)
      ..lineTo(w / 2, h)
      ..lineTo(0, h / 2)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _HexagonPreviewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    final dx = w * 0.2;
    return Path()
      ..moveTo(dx, 0)
      ..lineTo(w - dx, 0)
      ..lineTo(w, h / 2)
      ..lineTo(w - dx, h)
      ..lineTo(dx, h)
      ..lineTo(0, h / 2)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ParallelogramPreviewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    final skew = w * 0.2;
    return Path()
      ..moveTo(skew, 0)
      ..lineTo(w, 0)
      ..lineTo(w - skew, h)
      ..lineTo(0, h)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _OctagonPreviewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    final cut = (w < h ? w : h) * 0.2;
    return Path()
      ..moveTo(cut, 0)
      ..lineTo(w - cut, 0)
      ..lineTo(w, cut)
      ..lineTo(w, h - cut)
      ..lineTo(w - cut, h)
      ..lineTo(cut, h)
      ..lineTo(0, h - cut)
      ..lineTo(0, cut)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _TrapezoidPreviewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    final inset = w * 0.15;
    return Path()
      ..moveTo(inset, 0)
      ..lineTo(w - inset, 0)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class LineTypeSelect extends StatefulWidget {
  const LineTypeSelect({super.key});

  @override
  State<LineTypeSelect> createState() => _LineTypeSelectState();
}

class _LineTypeSelectState extends State<LineTypeSelect> {
  EdgeLineType selectedLine = EdgeLineType.straight;

  void updateLine(EdgeLineType line) {
    setState(() => selectedLine = line);
    final vm = context.read<MindMapVm>();
    vm.updateSelectedEdgeType(line);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MindMapVm>();
    final edge =
        vm.selectedEdgeId == null
            ? null
            : vm.mindMap.findEdge(vm.selectedEdgeId!);
    if (edge != null) {
      selectedLine = edge.lineType;
    }
    return _titleSection(
      title: 'Line Type',
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 10,
          children: EdgeLineType.values.map((t) => _lineItem(t)).toList(),
        ),
      ),
    );
  }

  Widget _lineItem(EdgeLineType type) {
    bool isSelected = selectedLine == type;
    return InkWell(
      onTap: () => updateLine(type),
      child: Container(
        decoration: ShapeDecoration(
          color: isSelected ? AppTheme.iceBlue : AppTheme.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected ? AppTheme.vividBlue : AppTheme.lightGray,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: SizedBox(
          width: 48,
          height: 24,
          child: _LineTypePreview(type: type),
        ),
      ),
    );
  }
}

class _LineTypePreview extends StatelessWidget {
  final EdgeLineType type;
  const _LineTypePreview({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _LineTypePreviewPainter(type));
  }
}

class _LineTypePreviewPainter extends CustomPainter {
  final EdgeLineType type;
  _LineTypePreviewPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    final a = Offset(4, size.height / 2);
    final b = Offset(size.width - 4, size.height / 2);
    final paint =
        Paint()
          ..color = AppTheme.wetAsphalt
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    switch (type) {
      case EdgeLineType.straight:
        canvas.drawLine(a, b, paint);
        break;
      case EdgeLineType.dashed:
        _drawDashed(canvas, paint, a, b, 8, 4);
        break;
      case EdgeLineType.dotted:
        _drawDashed(canvas, paint, a, b, 2, 6);
        break;
      case EdgeLineType.curved:
        final mid = (a + b) / 2;
        final control = mid + const Offset(0, -8);
        final path =
            Path()
              ..moveTo(a.dx, a.dy)
              ..quadraticBezierTo(control.dx, control.dy, b.dx, b.dy);
        canvas.drawPath(path, paint);
        break;
      case EdgeLineType.elbow:
        // For preview, offset the target Y so the elbow is visible
        final b2 = Offset(b.dx, size.height / 2 + 6);
        final corner = Offset(a.dx, b2.dy);
        canvas.drawLine(a, corner, paint); // vertical
        canvas.drawLine(corner, b2, paint); // horizontal
        break;
    }
  }

  void _drawDashed(
    Canvas canvas,
    Paint paint,
    Offset a,
    Offset b,
    double dash,
    double gap,
  ) {
    final total = (b - a).distance;
    if (total == 0) return;
    final dir = (b - a) / total;
    double traveled = 0;
    while (traveled <= total) {
      final start = a + dir * traveled;
      final end = a + dir * (traveled + dash).clamp(0, total);
      canvas.drawLine(start, end, paint);
      traveled += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _LineTypePreviewPainter oldDelegate) =>
      oldDelegate.type != type;
}

Widget _sizeRow({
  required String label,
  required double value,
  required double step,
  required double min,
  required double max,
  required ValueChanged<double> onChanged,
}) {
  void dec() => onChanged((value - step).clamp(min, max));
  void inc() => onChanged((value + step).clamp(min, max));
  return Row(
    children: [
      Expanded(child: Text('$label', style: titleTextStyle)),
      IconButton(
        tooltip: 'Decrease $label',
        onPressed: dec,
        icon: const Icon(Icons.remove, size: 18),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.aliceBlue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(value.toStringAsFixed(0), style: AppTheme.text),
      ),
      IconButton(
        tooltip: 'Increase $label',
        onPressed: inc,
        icon: const Icon(Icons.add, size: 18),
      ),
    ],
  );
}
