import 'vm.dart';
import 'main.dart';
import 'package:navinotes/packages.dart';
import 'aside.dart';

class NatureNotePageScreen extends StatelessWidget {
  NatureNotePageScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NatureNotePageVm(scaffoldKey: _scaffoldKey),
      child: Consumer<NatureNotePageVm>(
        builder: (_, vm, _) {
          return Consumer<LayoutProviderVm>(
            builder: (_, layoutVm, _) {
              return ScaffoldFrame(
                scaffoldKey: _scaffoldKey,
                backgroundColor: Apptheme.linen,
                endDrawer: CustomDrawer(
                  bgColor: Apptheme.deepRoast,
                  child: NatureNotePageAside(isFull: true),
                ),
                body: Column(
                  spacing: getDeviceResponsiveValue(
                    deviceType: layoutVm.deviceType,
                    mobile: 10,
                    desktop: 30,
                  ),
                  children: [
                    BoardNoteAppBar(
                      scaffoldKey: _scaffoldKey,
                      theme: BoardTheme.nature,
                    ),
                    Expanded(
                      child: ResponsiveHorizontalPadding(
                        child: ResponsiveSection(
                          mobile: NatureNotePageMain(),
                          desktop: Row(
                            spacing: getDeviceResponsiveValue(
                              deviceType: layoutVm.deviceType,
                              mobile: 10,
                              desktop: 30,
                            ),
                            children: [
                              Expanded(child: NatureNotePageMain()),
                              WidthLimiter(
                                mobile: 288,
                                largeDesktop: 312,
                                child: NatureNotePageAside(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
