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
        return Container(
          color: Colors.transparent,
          child: const MindMapCanvas(),
        );
      },
    );
  }
}
