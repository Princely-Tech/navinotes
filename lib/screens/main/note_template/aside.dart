import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/widgets/components.dart';

class NoteTemplateAside extends StatelessWidget {
  const NoteTemplateAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Apptheme.white,
        border: Border(right: BorderSide(width: 2, color: Apptheme.lightGray)),
      ),
      child: Column(
        spacing: 15,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: ScrollableController(
                child: Column(
                  children: [
                    //
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
