import 'aside.dart';
import 'appbar.dart';
import 'main.dart';
import 'package:navinotes/packages.dart';

class BoardPlainNotePageScreen extends StatelessWidget {
  BoardPlainNotePageScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Board board = ModalRoute.of(context)?.settings.arguments as Board;
    return ChangeNotifierProvider(
      create: (context) {
        final vm = BoardNotePageVm(
          scaffoldKey: _scaffoldKey,
          board: board,
          context: context,
        );
        vm.initialize();
        return vm;
      },
      child: Consumer<BoardNotePageVm>(
        builder: (_, vm, __) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            endDrawer: CustomDrawer(child: BoardPlainNotePageAside()),
            backgroundColor: AppTheme.whiteSmoke,
            body: Column(
              children: [
                BoardPlainNotePageAppBar(),
                Expanded(
                  child: ResponsiveSection(
                    mobile: const BoardPlainNotePageMain(),
                    desktop: Row(
                      children: [
                        const Expanded(child: BoardPlainNotePageMain()),
                        WidthLimiter(
                          mobile: 288,
                          child: BoardPlainNotePageAside(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
