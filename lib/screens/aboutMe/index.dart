import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/aboutMe/aside.dart';
import 'package:navinotes/screens/aboutMe/form.dart';
import 'package:navinotes/screens/aboutMe/vm.dart';
import 'package:navinotes/settings/app_strings.dart';
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
        bool mainScrollable =
            layoutProviderVm.deviceType == DeviceType.mobile ||
            layoutProviderVm.deviceType == DeviceType.tablets ||
            layoutProviderVm.deviceType == DeviceType.laptops;
        return ScaffoldFrame(
          body: ChangeNotifierProvider(
            create: (context) => AboutMeVm(),
            child: Column(
              spacing: 10,
              children: [
                _appBar(context),
                Expanded(
                  child: ScrollableController(
                    scrollable: mainScrollable,
                    child: _main(context, layoutProviderVm, mainScrollable),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _main(BuildContext context, LayoutProviderVm vm, bool mainScrollable) {
    bool canScroll = !mainScrollable;
    Widget aboutMeForm = ExpandableController(
      expandable: canScroll,
      child: ScrollableController(scrollable: canScroll, child: AboutMeForm()),
    );
    Widget aboutMeAside = ScrollableController(
      scrollable: canScroll,
      child: AboutMeAside(),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
      child: WidthLimiter(
        maxWidth: desktopsSize,
        child: ResponsiveSection(
          mobile: Column(children: [aboutMeForm, aboutMeAside]),
          desktops: Row(
            spacing: 30,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              aboutMeForm,
              WidthLimiter(maxWidth: 400, child: aboutMeAside),
            ],
          ),
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
                        AppStrings.appName,
                        style: Apptheme.text.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
