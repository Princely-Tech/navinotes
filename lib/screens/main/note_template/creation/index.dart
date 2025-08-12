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
    NoteCreationProp? creationProp =
        ModalRoute.of(context)?.settings.arguments as NoteCreationProp?;

    return ChangeNotifierProvider(
      create: (context) {
        NoteCreationVm vm = NoteCreationVm(
          scaffoldKey: _scaffoldKey,
          creationProp: creationProp,
          context: context,
        );
        vm.initialize();
        return vm;
      },
      child: Consumer<NoteCreationVm>(
        builder: (_, vm, _) {
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
