import 'left.dart';
import 'right.dart';
import 'main.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class DarkAcademiaMindMapScreen extends StatelessWidget {
  DarkAcademiaMindMapScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DarkAcademiaMindMapVm(scaffoldKey: _scaffoldKey),
      child: Consumer<DarkAcademiaMindMapVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            backgroundColor: AppTheme.moltenBrown,
            endDrawer: CustomDrawer(child: DarkAcademiaMindMapRight()),
            drawer: CustomDrawer(child: DarkAcademiaMindMapLeft()),
            body: Row(
              children: [
                VisibleController(
                  mobile: false,
                  desktop: true,
                  child: WidthLimiter(
                    mobile: 256,
                    child: DarkAcademiaMindMapLeft(),
                  ),
                ),
                Expanded(child: DarkAcademiaMindMapMain()),
                VisibleController(
                  mobile: false,
                  laptop: true,
                  child: WidthLimiter(
                    mobile: 256,
                    child: DarkAcademiaMindMapRight(),
                  ),
                ),
              ],
            ),
            // body: ResponsiveSection(
            //   mobile: WidthLimiter(
            //     mobile: 256,
            //     child: DarkAcademiaMindMapRight(),
            //   ),
            //   // desktop: Row(
            //   //   children: [
            //   //     WidthLimiter(mobile: 256, child: DarkAcademiaMindMapLeft()),
            //   //   ],
            //   // ),
            // ),
          );
        },
      ),
    );
  }
}
