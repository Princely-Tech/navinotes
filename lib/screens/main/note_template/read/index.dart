import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/read/main.dart';
import 'vm.dart';

class NoteReadScreen extends StatelessWidget {
  final NoteCreationProp? creationProp;
  NoteReadScreen({super.key, this.creationProp});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        NoteReadVm vm = NoteReadVm(
          creationProp: creationProp,
          context: context,
        );
        vm.initialize();
        return vm;
      },
      child: Consumer<NoteReadVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            // backgroundColor: AppTheme.white,
            backgroundColor: AppTheme.white,
            scaffoldKey: _scaffoldKey,
            body: Stack(
              children: [
                ResponsiveSection(
                  mobile: NoteReadMain(),
                  desktop: Row(children: [Expanded(child: NoteReadMain())]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
