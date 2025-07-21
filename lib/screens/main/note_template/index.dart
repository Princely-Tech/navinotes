import 'package:navinotes/packages.dart';
import 'aside.dart';
import 'main.dart';
import 'vm.dart';

class NoteTemplateScreen extends StatelessWidget {
  NoteTemplateScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Board? board = ModalRoute.of(context)!.settings.arguments as Board?;
    return ChangeNotifierProvider(
      create:
          (context) => NoteTemplateVm(
            scaffoldKey: _scaffoldKey,
            context: context,
            board: board,
          ),
      child: Consumer<NoteTemplateVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            endDrawer: CustomDrawer(child: NoteTemplateAside()),
            body: ResponsiveSection(
              mobile: NoteTemplateMain(),
              desktop: Row(
                children: [
                  Expanded(child: NoteTemplateMain()),
                  WidthLimiter(
                    mobile: 280,
                    largeDesktop: 320,
                    child: NoteTemplateAside(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
