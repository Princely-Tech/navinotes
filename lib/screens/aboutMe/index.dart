import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/screen_dimensions.dart';
import 'package:navinotes/settings/ui_helpers.dart';
import 'package:navinotes/widgets/frames.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      body: Column(
        children: [
          _appBar(context),
          //
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    double deviceWidth = screenWidth(context);
    double maxWidth = deviceWidth < desktopsSize ? deviceWidth : desktopsSize;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth - defaultHorizontalPadding,
          ),
          child: Row(
            children: [
              //
            ],
          ),
        ),
      ],
    );
  }
}
