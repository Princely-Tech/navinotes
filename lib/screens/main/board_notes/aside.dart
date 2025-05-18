import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/board_notes/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:provider/provider.dart';

class BoardNotesAside extends StatelessWidget {
  const BoardNotesAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotesVm>(
      builder: (context, vm, child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Apptheme.white,
            border: Border(
              right: BorderSide(width: 2, color: Apptheme.lightGray),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ScrollableController(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    spacing: 30,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
