import 'vm.dart';
import 'main.dart';
import 'package:navinotes/packages.dart';
import 'aside.dart';

class BoardMinimalistNotePageScreen extends StatelessWidget {
  BoardMinimalistNotePageScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MinimalistNotePageVm(scaffoldKey: _scaffoldKey),
      child: Consumer<MinimalistNotePageVm>(
        builder: (_, vm, _) {
          return Consumer<LayoutProviderVm>(
            builder: (_, layoutVm, _) {
              return ScaffoldFrame(
                scaffoldKey: _scaffoldKey,
                backgroundColor: AppTheme.white,
                endDrawer: CustomDrawer(child: MinimalistNotePageAside()),
                body: Column(
                  children: [
                    BoardNoteAppBar(
                      scaffoldKey: _scaffoldKey,
                      theme: BoardTheme.minimalist,
                    ),
                    Expanded(
                      child: ResponsiveHorizontalPadding(
                        child: ResponsiveSection(
                          mobile: MinimalistNotePageMain(),
                          desktop: Row(
                            children: [
                              Expanded(child: MinimalistNotePageMain()),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: VerticalDivider(
                                  color: AppTheme.sageMist.withAlpha(0x4C),
                                  width: 1,
                                ),
                              ),
                              WidthLimiter(
                                mobile: 256,
                                child: MinimalistNotePageAside(),
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
