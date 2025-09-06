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
      onTap: () {
        if (vm.connectingFromNodeId != null) {
          // if connecting mode active and tapped this as target
          if (vm.connectingFromNodeId != node.id) {
            vm.finishConnecting(node.id);
          }
        } else {
          vm.selectNode(node.id);
        }
      },
      onLongPress: () {
        // start connect mode from this node
        vm.startConnectingFrom(node.id);
      },
      onDoubleTap: () async {
        // edit label dialog
        final textController = TextEditingController(text: node.text);
        final newText = await showDialog<String>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Edit node text'),
            content: TextField(
              controller: textController,
              autofocus: true,
              minLines: 1,
              maxLines: 4,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(textController.text), child: const Text('Save')),
            ],
          ),
        );
        if (newText != null && newText.trim().isNotEmpty) {
          vm.updateNodeText(node.id, newText.trim());
        }
      },

      // Dragging the node
      onPanStart: (_) {
        vm.startDraggingNode(node.id);
      },
      onPanUpdate: (details) {
        // details.delta is in screen pixels — convert by scale in VM
        vm.dragNodeBy(node.id, details.delta);
      },
      onPanEnd: (_) {
        vm.stopDraggingNode();
      },

      child: Material(
        elevation: isSelected ? 8 : 4,
        color: node.color,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: node.width,
          height: node.height,
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
              if (isConnectingFrom)
                const Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Icon(Icons.link, size: 18, color: Colors.white70),
                ),
            ],
          ),
        ),
      ),
    );
  }
}