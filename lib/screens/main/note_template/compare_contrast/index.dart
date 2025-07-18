import 'package:navinotes/packages.dart';
import 'vm.dart';
import 'left/index.dart';
import 'main.dart';
import 'header.dart';
import 'ai_analysis.dart';

//TODO work on this more to match design

class NoteCompareContrastScreen extends StatelessWidget {
  NoteCompareContrastScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        NoteCompareContrastVm vm = NoteCompareContrastVm(
          scaffoldKey: _scaffoldKey,
        );
        vm.initialize();
        return vm;
      },
      child: Consumer<NoteCompareContrastVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            drawer: CustomDrawer(child: NoteCompareContrastLeft()),
            body: Column(
              children: [
                NoteCompareContrastHeader(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      double maxHeight = 1000;
                      if (constraints.maxHeight < 1000 &&
                          constraints.maxHeight > 500) {
                        maxHeight = constraints.maxHeight;
                      }
                      return ScrollableController(
                        mobilePadding: EdgeInsets.symmetric(vertical: 20),
                        child: ResponsiveHorizontalPadding(
                          child: Column(
                            spacing: 30,
                            children: [
                              HeightLimiter( 
                                maxHeight: maxHeight,
                                child: Row(
                                  children: [
                                    VisibleController(
                                      mobile: false,
                                      largeDesktop: true,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 20,
                                        ),
                                        child: NoteCompareContrastLeft(),
                                      ),
                                    ),
                                    Expanded(child: NoteCompareContrastMain()),
                                  ],
                                ),
                              ),
                              NoteCompareContrastAiAnalysis(),
                            ],
                          ),
                        ),
                      );
                    },
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
