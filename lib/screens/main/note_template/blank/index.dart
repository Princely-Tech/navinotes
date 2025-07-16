import 'package:navinotes/packages.dart';
import 'ai_section.dart';
import 'left.dart';
import 'right.dart';
import 'main.dart';
import 'vm.dart';

class BlankNoteScreen extends StatelessWidget {
  BlankNoteScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        BlankNoteVm vm = BlankNoteVm(scaffoldKey: _scaffoldKey);
        vm.initialize();
        return vm;
      },
      child: Consumer<BlankNoteVm>(
        builder: (context, vm, child) {
          return ScaffoldFrame(
            backgroundColor: AppTheme.white,
            scaffoldKey: _scaffoldKey,
            endDrawer: CustomDrawer(child: BlankNoteRight()),
            drawer: CustomDrawer(child: BlankNoteLeft()),
            body: Stack(
              children: [
                ResponsiveSection(
                  mobile: BlankNoteMain(),
                  desktop: Row(
                    children: [
                      VisibleController(
                        mobile: false,
                        largeDesktop: true,
                        child: WidthLimiter(mobile: 255, child: BlankNoteLeft()),
                      ),
                      Expanded(child: BlankNoteMain()),
                      WidthLimiter(mobile: 255, child: BlankNoteRight()),
                    ],
                  ),
                ),
                NoteAiSection(),
              ],
            ),
          );
        },
      ),
    );
  }
}
