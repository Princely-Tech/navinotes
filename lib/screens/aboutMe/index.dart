import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/aboutMe/aside.dart';
import 'package:navinotes/screens/aboutMe/form.dart';
import 'package:navinotes/screens/aboutMe/vm.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';
import 'package:provider/provider.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (context, layoutProviderVm, child) {
        bool mainScrollable =
            layoutProviderVm.deviceType == DeviceType.mobile ||
            layoutProviderVm.deviceType == DeviceType.tablet ||
            layoutProviderVm.deviceType == DeviceType.laptop;
        return ScaffoldFrame(
          body: ChangeNotifierProvider(
            create: (context) => AboutMeVm(),
            child: Column(
              spacing: 10,
              children: [
                _appBar(context),
                Expanded(
                  child: ScrollableController(
                    mobile: mainScrollable,
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
      mobile: canScroll,
      child: ScrollableController(mobile: canScroll, child: AboutMeForm()),
    );
    Widget aboutMeAside = ScrollableController(
      mobile: canScroll,
      child: AboutMeAside(),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
      child: WidthLimiter(
        mobile: desktopSize,
        child: ResponsiveSection(
          mobile: Column(children: [aboutMeForm, aboutMeAside]),
          desktop: Row(
            spacing: 30,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              aboutMeForm,
              WidthLimiter(mobile: 400, child: aboutMeAside),
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
          mobile: desktopSize,
          child: Row(
            spacing: 10,
            children: [
              SVGImagePlaceHolder(imagePath: Images.logo, size: 30),
              Expanded(
                child: Text(
                  AppStrings.appName,
                  style: Apptheme.text.copyWith(
                    fontSize: 20.0,
                    fontWeight: getFontWeight(600),
                    color: Apptheme.vividRose,
                  ),
                ),
              ),
              // Expanded(
              //   child: Row(
              //     spacing: 10,
              //     children: [

              //     ],
              //   ),
              // ),

              // _appBarAction(imagePath: Images.ques),
              // _appBarAction(imagePath: Images.settings),
            ],
          ),
        ),
      ),
    );
  }
}
