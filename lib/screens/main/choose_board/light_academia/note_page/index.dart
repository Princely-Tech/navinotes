import 'main.dart';
import 'package:navinotes/packages.dart';
import 'aside.dart';

class BoardLightAcadNotePageScreen extends StatelessWidget {
  BoardLightAcadNotePageScreen({super.key});
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
                backgroundColor: AppTheme.ivoryCream,
                endDrawer: CustomDrawer(child: BoardLightAcadNotePageAside()),
                body: Column(
                  children: [
                    BoardNoteAppBar(
                      scaffoldKey: _scaffoldKey,
                      theme: BoardTheme.lightAcademia,
                    ),
                    Expanded(
                      child: ResponsiveSection(
                        mobile: BoardLightAcadNotePageMain(),
                        desktop: Row(
                          children: [
                            Expanded(child: BoardLightAcadNotePageMain()),
                            WidthLimiter(
                              mobile: 256,
                              largeDesktop: 320,
                              child: BoardLightAcadNotePageAside(),
                            ),
                          ],
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
