// mind_map_main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vm.dart';
import 'mind_map_canvas.dart';

class MindMapMain extends StatelessWidget {
  const MindMapMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MindMapVm>(
      builder: (_, vm, __) {
        return Column(
          children: [
            // small toolbar inside the main area (keeps global layout intact)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // add in-center node
                      final size = MediaQuery.of(context).size;
                      // Visual center:
                      final visualCenter = Offset(
                        size.width / 3,
                        (size.height - 120) / 2,
                      );
                      final logical = vm.visualToLogical(visualCenter);
                      vm.addNodeAt(text: 'New node', logicalPosition: logical);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add node'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed:
                        vm.connectingFromNodeId == null
                            ? null
                            : () => vm.cancelConnecting(),
                    icon: const Icon(Icons.link_off),
                    label: const Text('Cancel connect'),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Zoom in',
                    onPressed: vm.zoomIn,
                    icon: const Icon(Icons.zoom_in),
                  ),
                  IconButton(
                    tooltip: 'Zoom out',
                    onPressed: vm.zoomOut,
                    icon: const Icon(Icons.zoom_out),
                  ),
                  IconButton(
                    tooltip: 'Reset zoom & pan',
                    onPressed: vm.resetZoom,
                    icon: const Icon(Icons.center_focus_strong),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      final json = vm.toJson();
                      // copy to clipboard or show in dialog
                      showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('Mind map JSON'),
                              content: SizedBox(
                                width: 600,
                                child: SingleChildScrollView(
                                  child: Text(json.toString()),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                      );
                    },
                    icon: const Icon(Icons.code),
                    label: const Text('Export JSON'),
                  ),
                ],
              ),
            ),

            // actual canvas area
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: const MindMapCanvas(),
              ),
            ),
          ],
        );
      },
    );
  }
}
