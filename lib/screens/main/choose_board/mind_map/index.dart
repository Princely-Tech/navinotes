import 'package:navinotes/screens/main/choose_board/mind_map/mind_map_documents.dart';
import 'package:navinotes/screens/main/choose_board/mind_map/mind_map_styling.dart';

import 'main.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class MindMapScreen extends StatelessWidget {
  MindMapScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MindMapVm(scaffoldKey: _scaffoldKey),
      child: Consumer<MindMapVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            backgroundColor: AppTheme.white,
            endDrawer: CustomDrawer(
              child: MindMapStyling(boardTheme: BoardTheme.minimalist, vm: vm),
            ),
            drawer: CustomDrawer(
              child: MindMapDocuments(boardTheme: BoardTheme.minimalist),
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
                          child: MindMapDocuments(boardTheme: BoardTheme.plain),
                        ),
                      ),
                      Expanded(child: MindMapMain()),
                      VisibleController(
                        mobile: false,
                        laptop: true,
                        child: WidthLimiter(
                          mobile: 256,
                          child: MindMapStyling(
                            boardTheme: BoardTheme.plain,
                            vm: vm,
                          ),
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
