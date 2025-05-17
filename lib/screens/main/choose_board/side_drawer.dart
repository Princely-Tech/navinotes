import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/widgets/components.dart';

class ChooseBoardAside extends StatelessWidget {
  const ChooseBoardAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Apptheme.white,
        border: Border(right: BorderSide(width: 2, color: Apptheme.lightGray)),
      ),
      child: Column(
        spacing: 15,
        children: [
          //
        ],
      ),
    );
  }
}
