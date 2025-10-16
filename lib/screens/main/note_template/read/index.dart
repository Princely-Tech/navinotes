import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/read/main.dart';
import 'vm.dart';

class NoteReadScreen extends StatelessWidget {
  final Content? content;
  NoteReadScreen({super.key, this.content});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        NoteReadVm vm = NoteReadVm(content: content, context: context);
        vm.initialize();
        return vm;
      },
      child: Consumer<NoteReadVm>(
        builder: (_, vm, _) {
          return NoteReadMain();
        },
      ),
    );
  }
}
