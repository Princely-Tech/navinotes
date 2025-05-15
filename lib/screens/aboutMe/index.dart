import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/aboutMe/form.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/settings/screen_dimensions.dart';
import 'package:navinotes/settings/ui_helpers.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/frames.dart';
import 'package:provider/provider.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (context, layoutProviderVm, child) {
        return ScaffoldFrame(
          body: Column(
            spacing: 10,
            children: [_appBar(context), _main(context, layoutProviderVm)],
          ),
        );
      },
    );
  }

  Widget _main(BuildContext context, LayoutProviderVm vm) {
    return WidthLimiter(
      maxWidth: desktopsSize,
      child: ResponsiveSection(
        mobile: Column(
          children: [
            AboutMeForm(),
            //
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Apptheme.white,
        border: Border(bottom: BorderSide(color: Apptheme.lightGray, width: 1)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: defaultHorizontalPadding,
        vertical: 10,
      ),
      child: Center(
        child: WidthLimiter(
          maxWidth: desktopsSize,
          child: Row(
            spacing: 15,
            children: [
              Expanded(
                child: Row(
                  spacing: 10,
                  children: [
                    SVGImagePlaceHolder(imagePath: Images.logo, size: 30),
                    Expanded(
                      child: Text(
                        'MindMapper',
                        style: TextStyle(
                          color: const Color(0xFF1F2937),
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              _appBarAction(imagePath: Images.ques),
              _appBarAction(imagePath: Images.settings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarAction({required String imagePath}) {
    return SvgPicture.asset(imagePath, width: 20, height: 20);
  }
}
