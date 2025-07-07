import 'main.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class BoardPlainMindMapScreen extends StatelessWidget {
  BoardPlainMindMapScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardPlainMindMapVm(scaffoldKey: _scaffoldKey),
      child: Consumer<BoardPlainMindMapVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            backgroundColor: AppTheme.white,
            endDrawer: CustomDrawer(
              child: MindMapRight(boardTheme: BoardTheme.minimalist),
            ),
            drawer: CustomDrawer(
              child: MindMapLeft(boardTheme: BoardTheme.minimalist),
            ),
            body: Column(
              children: [
                CustomMindMapHeader(
                  openDrawer: vm.openDrawer,
                  boardTheme: BoardTheme.plain,
                  openEndDrawer: vm.openEndDrawer,
                ),
                Expanded(
                  child: Row(
                    children: [
                      VisibleController(
                        mobile: false,
                        desktop: true,
                        child: WidthLimiter(
                          mobile: 256,
                          child: MindMapLeft(boardTheme: BoardTheme.plain),
                        ),
                      ),
                      Expanded(child: BoardPlainMindMapMain()),
                      VisibleController(
                        mobile: false,
                        laptop: true,
                        child: WidthLimiter(
                          mobile: 256,
                          child: MindMapRight(boardTheme: BoardTheme.plain),
                        ),
                      ),
                    ],
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
