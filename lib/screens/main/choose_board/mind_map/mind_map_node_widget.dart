// mind_map_node_widget.dart
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
        showGlow
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
                  (_) => AlertDialog(
                    title: const Text('Edit node text'),
                    content: TextField(
                      controller: textController,
                      autofocus: true,
                      minLines: 1,
                      maxLines: 4,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed:
                            () =>
                                Navigator.of(context).pop(textController.text),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
            );
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
          child: Material(
            elevation: elevation,
            color: Colors.transparent,
            borderRadius: borderRadius,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: node.width,
              height: node.height,
              decoration: BoxDecoration(
                color: toneColor,
                borderRadius: borderRadius,
                border:
                    isConnectingFrom || showBorder
                        ? Border.all(color: Colors.blueAccent, width: 2.0)
                        : null,
                boxShadow: glowShadow,
              ),
              child: Text(
                node.text,
                style: TextStyle(
                  color: node.textColor.withOpacity(node.opacity),
                  fontSize: node.fontSize,
                  fontWeight: _toFontWeight(node.fontWeight),
                  fontFamily: node.fontFamily,
                ),
                overflow: TextOverflow.ellipsis,
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
}
