import 'vm.dart';
import 'main.dart';
import 'package:navinotes/packages.dart';
import 'aside.dart';

class DarkAcademiaCreateNoteScreen extends StatelessWidget {
  DarkAcademiaCreateNoteScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DarkAcademiaCreateNoteVm(scaffoldKey: _scaffoldKey),
      child: Consumer<DarkAcademiaCreateNoteVm>(
        builder: (_, vm, _) {
          return Consumer<LayoutProviderVm>(
            builder: (_, layoutVm, _) {
              return ScaffoldFrame(
                scaffoldKey: _scaffoldKey,
                backgroundColor: AppTheme.deepRoast,
                endDrawer: CustomDrawer(
                  bgColor: AppTheme.deepRoast,
                  child: DarkAcademiaCreateNoteAside(isFull: true),
                ),
                body: Column(
                  spacing: 30,
                  children: [
                    BoardNoteAppBar(scaffoldKey: _scaffoldKey),
                    Expanded(
                      child: ResponsiveHorizontalPadding(
                        child: ResponsiveSection(
                          mobile: DarkAcademiaCreateNoteMain(),
                          desktop: Row(
                            spacing: getDeviceResponsiveValue(
                              deviceType: layoutVm.deviceType,
                              mobile: 10,
                              desktop: 30,
                            ),
                            children: [
                              Expanded(child: DarkAcademiaCreateNoteMain()),
                              WidthLimiter(
                                mobile: 288,
                                largeDesktop: 312,
                                child: DarkAcademiaCreateNoteAside(),
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
