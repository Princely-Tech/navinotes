import 'vm.dart';
import 'main.dart';
import 'package:navinotes/packages.dart';
import 'aside.dart';

class BoardLightAcadNotePageScreen extends StatelessWidget {
  BoardLightAcadNotePageScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardLightAcadNotePageVm(scaffoldKey: _scaffoldKey),
      child: Consumer<BoardLightAcadNotePageVm>(
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
