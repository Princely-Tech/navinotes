import 'main.dart';
import 'package:navinotes/packages.dart';
import 'aside.dart';

class NatureNotePageScreen extends StatelessWidget {
  NatureNotePageScreen({super.key});
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
                backgroundColor: AppTheme.linen,
                endDrawer: CustomDrawer(child: NatureNotePageAside()),
                body: Column(
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
                            // spacing: getDeviceResponsiveValue(
                            //   deviceType: layoutVm.deviceType,
                            //   mobile: 10,
                            //   desktop: 30,
                            // ),
                            children: [
                              Expanded(child: NatureNotePageMain()),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: VerticalDivider(
                                  color: AppTheme.sageMist.withAlpha(0x4C),
                                  width: 1,
                                ),
                              ),
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
