import 'main.dart';
import 'package:navinotes/packages.dart';
import 'aside.dart';

class DarkAcademiaCreateNoteScreen extends StatelessWidget {
  DarkAcademiaCreateNoteScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Board board = ModalRoute.of(context)?.settings.arguments as Board;
    return ChangeNotifierProvider(
      create: (_) {
        final vm = BoardNotePageVm(
          scaffoldKey: _scaffoldKey,
          board: board,
          context: context,
        );
        vm.initialize();
        return vm;
      },
      child: Consumer<BoardNotePageVm>(
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
