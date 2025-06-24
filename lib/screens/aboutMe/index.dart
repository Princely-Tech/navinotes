import 'package:navinotes/packages.dart';
import 'aside.dart';
import 'form.dart';
import 'vm.dart';

class AboutMeScreen extends StatelessWidget {
  const AboutMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ApiServiceComponent(
      child: Consumer<ApiServiceProvider>(
        builder: (_, apiServiceProvider, _) {
          return Consumer<LayoutProviderVm>(
            builder: (context, layoutProviderVm, child) {
              bool mainScrollable =
                  layoutProviderVm.deviceType == DeviceType.mobile ||
                  layoutProviderVm.deviceType == DeviceType.tablet ||
                  layoutProviderVm.deviceType == DeviceType.laptop;
              return ScaffoldFrame(
                body: ChangeNotifierProvider(
                  create: (context) {
                    AboutMeVm vm = AboutMeVm(
                      context: context,
                      apiServiceProvider: apiServiceProvider,
                    );
                    vm.initialize();
                    return vm;
                  },
                  child: Consumer<AboutMeVm>(
                    builder: (_, vm, _) {
                      return AbsorbPointer(
                        absorbing: vm.isLoading,
                        child: Column(
                          children: [
                            AppHeaderOne(widthLimit: desktopSize),
                            Expanded(
                              child: ScrollableController(
                                mobile: mainScrollable,
                                child: _main(
                                  context,
                                  layoutProviderVm,
                                  mainScrollable,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _main(BuildContext context, LayoutProviderVm vm, bool mainScrollable) {
    bool canScroll = !mainScrollable;
    Widget aboutMeForm = ExpandableController(
      mobile: canScroll,
      child: ScrollableController(
        mobilePadding: EdgeInsets.only(top: 10),
        mobile: canScroll,
        child: AboutMeForm(),
      ),
    );
    Widget aboutMeAside = ScrollableController(
      mobilePadding: EdgeInsets.only(top: 10),
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
}
