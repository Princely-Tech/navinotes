// mind_map_node_widget.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navinotes/models/mind_map_node.dart';
import 'package:provider/provider.dart';
import 'vm.dart';

class MindMapNodeWidget extends StatelessWidget {
  final MindMapNode node;
  const MindMapNodeWidget({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MindMapVm>(context);
    final isSelected = vm.selectedNodeId == node.id;
    final isConnectingFrom = vm.connectingFromNodeId == node.id;
    final hasAttachment = node.contentID != null && node.contentID!.isNotEmpty;

    final toneColor = _applyTone(
      node.color,
      node.colorTone,
    ).withOpacity(node.opacity);
    final borderRadius = BorderRadius.circular(node.borderRadius);

    // Border/Glow setup
    final bool showBorder = node.borderStyle == MindMapBorderStyle.border;
    final bool showGlow = node.borderStyle == MindMapBorderStyle.glow;
    final double elevation =
        node.borderStyle == MindMapBorderStyle.shadow
            ? (isSelected ? 8 : 4)
            : 0;
    final List<BoxShadow>? glowShadow =
        showGlow && _isRectLike(node.shape)
            ? [
              BoxShadow(
                color: toneColor.withOpacity(0.6),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ]
            : null;

    return Stack(
      clipBehavior: Clip.none, // Allow children to overflow
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: () async {
            // edit label dialog
            final textController = TextEditingController(text: node.text);
            final newText = await showDialog<String>(
              context: context,
              builder:
                  (dialogContext) => AlertDialog(
                    title: const Text('Edit node text'),
                    content: TextField(
                      controller: textController,
                      autofocus: true,
                      minLines: 1,
                      maxLines: 4,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed:
                            () => Navigator.of(
                              dialogContext,
                            ).pop(textController.text),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
            );
            // debugPrint('newText: $newText');
            // if (!context.mounted) return; // avoid using a deactivated context
            // debugPrint('context mounted');
            if (newText != null && newText.trim().isNotEmpty) {
              vm.updateNodeText(node.id, newText.trim());
            }
          },
          onTap: () {
            if (vm.connectingFromNodeId != null) {
              // If we're in connection mode, finish the connection
              vm.finishConnecting(node.id);
            } else {
              // Otherwise, just select the node
              vm.selectNode(node.id);
            }
          },
          onLongPressStart: (details) {
            // Start connection on long press
            vm.startConnectingFrom(node.id);
          },
          onPanStart: (_) {
            // Only start dragging if not in connection mode
            if (vm.connectingFromNodeId == null) {
              vm.startDraggingNode(node.id);
            }
          },
          onPanUpdate: (details) {
            // If in connection mode, update pointer position
            if (vm.connectingFromNodeId != null) {
              // Convert the local position to canvas coordinates
              final box = context.findRenderObject() as RenderBox;
              final localPosition = box.globalToLocal(details.globalPosition);
              vm.updatePointerFromVisual(localPosition);
            } else if (vm.draggingNodeId == node.id) {
              // Only handle node dragging if we're the dragging node
              vm.dragNodeBy(node.id, details.delta);
            }
          },

          onPanEnd: (_) {
            if (vm.connectingFromNodeId == node.id) {
              // If we were connecting and didn't connect to another node, cancel
              vm.cancelConnecting();
            } else if (vm.draggingNodeId == node.id) {
              vm.stopDraggingNode();
            }
          },
          child: _buildShapedNode(
            node: node,
            isConnectingFrom: isConnectingFrom,
            elevation: elevation,
            toneColor: toneColor,
            borderRadius: borderRadius,
            showBorder: showBorder,
            glowShadow: glowShadow,
          ),
        ),

        // Attachment indicator/button
        if (hasAttachment)
          Positioned(
            left: -16,
            top: node.height / 2 - 12,
            child: Tooltip(
              message: 'Open attached document',
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await vm.openAttachedContent(node.id);
                },
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.attach_file,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        if (isConnectingFrom)
          Positioned(
            left: 0,
            right: 0,
            top: node.height + 4, // Position below the node
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Connecting...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

        if (isSelected)
          Positioned(
            right: -16,
            top: node.height / 2 - 12,
            child: GestureDetector(
              behavior:
                  HitTestBehavior.translucent, // ensures taps hit here first
              onTap: () {
                if (isConnectingFrom) {
                  vm.cancelConnecting();
                } else {
                  vm.startConnectingFrom(node.id);
                }
              },
              child: SizedBox(
                width: 36,
                height: 36,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color:
                          isConnectingFrom
                              ? Colors.blueAccent
                              : Colors.grey[800],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Icon(
                      Icons.link,
                      size: 16,
                      color:
                          isConnectingFrom ? Colors.white : Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShapedNode({
    required MindMapNode node,
    required bool isConnectingFrom,
    required double elevation,
    required Color toneColor,
    required BorderRadius borderRadius,
    required bool showBorder,
    required List<BoxShadow>? glowShadow,
  }) {
    final text = Text(
      node.text,
      style: TextStyle(
        color: node.textColor.withOpacity(node.opacity),
        fontSize: node.fontSize,
        fontWeight: _toFontWeight(node.fontWeight),
        fontFamily: node.fontFamily,
      ),
      softWrap: true,
      maxLines: null, // allow wrapping to multiple lines
      overflow: TextOverflow.clip, // keep within node height
      textAlign: TextAlign.center,
    );

    final content = Padding(padding: const EdgeInsets.all(8.0), child: text);

    // Rect-like shapes handled with standard Material/Container
    if (_isRectLike(node.shape)) {
      return Material(
        elevation: elevation,
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: Container(
          padding: EdgeInsets.zero,
          width: node.width,
          height: node.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: toneColor,
            borderRadius: borderRadius,
            border:
                isConnectingFrom || showBorder
                    ? Border.all(color: Colors.blueAccent, width: 2.0)
                    : null,
            boxShadow: glowShadow,
          ),
          child: content,
        ),
      );
    }

    // Non-rect shapes: use PhysicalShape to support elevation and colored shadow
    final clipper = _shapeClipper(node.shape);
    final borderPainter =
        showBorder || isConnectingFrom
            ? _ShapeBorderPainter(
              clipper: clipper,
              borderColor: Colors.blueAccent,
              strokeWidth: 2,
            )
            : null;

    return Stack(
      children: [
        PhysicalShape(
          elevation: elevation,
          color: toneColor,
          shadowColor:
              node.borderStyle == MindMapBorderStyle.glow
                  ? toneColor.withOpacity(0.8)
                  : Colors.black,
          clipper: clipper,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: node.width,
            height: node.height,
            child: _centeredInnerBox(node.shape, content),
          ),
        ),
        if (borderPainter != null)
          IgnorePointer(
            child: CustomPaint(
              size: Size(node.width, node.height),
              painter: borderPainter,
            ),
          ),
      ],
    );
  }

  bool _isRectLike(MindMapShape shape) {
    return shape == MindMapShape.rounded ||
        shape == MindMapShape.sharp ||
        shape == MindMapShape.pill;
  }

  // Shift hue toward warmer/cooler based on tone in -1..1
  Color _applyTone(Color color, double tone) {
    if (tone == 0) return color;
    final hsl = HSLColor.fromColor(color);
    // Map -1..1 tone to -20..20 degrees shift
    final shift = tone * 20.0;
    final newHue = (hsl.hue + shift) % 360;
    return hsl.withHue(newHue).toColor();
  }

  FontWeight _toFontWeight(int weight) {
    switch (weight) {
      case 300:
        return FontWeight.w300;
      case 400:
        return FontWeight.w400;
      case 500:
        return FontWeight.w500;
      case 600:
        return FontWeight.w600;
      case 700:
        return FontWeight.w700;
      default:
        return FontWeight.w500;
    }
  }

  CustomClipper<Path> _shapeClipper(MindMapShape shape) {
    switch (shape) {
      case MindMapShape.circle:
        return _CircleClipper();
      case MindMapShape.diamond:
        return _DiamondClipper();
      case MindMapShape.hexagon:
        return _HexagonClipper();
      case MindMapShape.parallelogram:
        return _ParallelogramClipper();
      case MindMapShape.octagon:
        return _OctagonClipper();
      case MindMapShape.trapezoid:
        return _TrapezoidClipper();
      case MindMapShape.pill:
      case MindMapShape.rounded:
      case MindMapShape.sharp:
        // Rect-like handled without clipper, but return a rect clipper if needed
        return _RectClipper();
    }
  }

  // Constrain text inside non-rect shapes to avoid clipping against edges
  Widget _centeredInnerBox(MindMapShape shape, Widget child) {
    final Size f = _innerFactors(shape);
    return Center(
      child: FractionallySizedBox(
        widthFactor: f.width,
        heightFactor: f.height,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Size _innerFactors(MindMapShape shape) {
    switch (shape) {
      case MindMapShape.circle:
        // Inscribe a rectangle safely inside a circle
        return const Size(0.75, 0.75);
      case MindMapShape.diamond:
        // Diamond has tighter corners; reduce width more
        return const Size(0.65, 0.75);
      case MindMapShape.hexagon:
        return const Size(0.8, 0.8);
      case MindMapShape.parallelogram:
        // Skewed sides; keep a comfortable inset
        return const Size(0.85, 0.8);
      case MindMapShape.octagon:
        return const Size(0.85, 0.85);
      case MindMapShape.trapezoid:
        return const Size(0.8, 0.8);
      case MindMapShape.pill:
      case MindMapShape.rounded:
      case MindMapShape.sharp:
        // Rect-like are handled elsewhere; use full area here (not used)
        return const Size(1.0, 1.0);
    }
  }
}

class _ShapeBorderPainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  final Color borderColor;
  final double strokeWidth;
  _ShapeBorderPainter({
    required this.clipper,
    required this.borderColor,
    this.strokeWidth = 2,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final path = clipper.getClip(size);
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = borderColor;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ShapeBorderPainter oldDelegate) => true;
}

class _RectClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) =>
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final r = Rect.fromLTWH(0, 0, size.width, size.height);
    return Path()..addOval(r);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    final path =
        Path()
          ..moveTo(w / 2, 0)
          ..lineTo(w, h / 2)
          ..lineTo(w / 2, h)
          ..lineTo(0, h / 2)
          ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    final dx = w * 0.2; // side inset
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

class _ParallelogramClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    final skew = w * 0.15;
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

class _OctagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width, h = size.height;
    final cut = math.min(w, h) * 0.2;
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

class _TrapezoidClipper extends CustomClipper<Path> {
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
