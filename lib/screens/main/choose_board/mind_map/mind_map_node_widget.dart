// mind_map_node_widget.dart
import 'package:flutter/material.dart';
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

    return GestureDetector(
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
                        () => Navigator.of(context).pop(textController.text),
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
        elevation: isSelected ? 8 : 4,
        color: node.color,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: node.width,
          height: node.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border:
                isConnectingFrom
                    ? Border.all(color: Colors.blueAccent, width: 2.0)
                    : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  node.text,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Connection icon overlay
              if (isSelected)
                Positioned(
                  right: -6,
                  top: -6,
                  child: GestureDetector(
                    onTap: () {
                      if (isConnectingFrom) {
                        vm.cancelConnecting();
                      } else {
                        vm.startConnectingFrom(node.id);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
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
            ],
          ),
        ),
      ),
    );
  }
}
