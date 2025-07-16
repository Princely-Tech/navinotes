import 'package:navinotes/packages.dart';
import 'ai_section.dart';
import 'left.dart';
import 'right.dart';
import 'main.dart';
import 'vm.dart';

class NoteCreationScreen extends StatelessWidget {
  NoteCreationScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Extract board from route arguments
    BoardNoteTemplate? template =
        ModalRoute.of(context)?.settings.arguments as BoardNoteTemplate?;

    return ChangeNotifierProvider(
      create: (context) {
        NoteCreationVm vm = NoteCreationVm(
          scaffoldKey: _scaffoldKey,
          template: template,
        );
        vm.initialize();
        return vm;
      },
      child: Consumer<NoteCreationVm>(
        builder: (context, vm, child) {
          return ScaffoldFrame(
            backgroundColor: AppTheme.white,
            scaffoldKey: _scaffoldKey,
            endDrawer: CustomDrawer(child: NoteCreationRight()),
            drawer: CustomDrawer(child: NoteCreationLeft()),
            body: Stack(
              children: [
                ResponsiveSection(
                  mobile: NoteCreationMain(),
                  desktop: Row(
                    children: [
                      VisibleController(
                        mobile: false,
                        largeDesktop: true,
                        child: WidthLimiter(
                          mobile: 255,
                          child: NoteCreationLeft(),
                        ),
                      ),
                      Expanded(child: NoteCreationMain()),
                      WidthLimiter(mobile: 255, child: NoteCreationRight()),
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
