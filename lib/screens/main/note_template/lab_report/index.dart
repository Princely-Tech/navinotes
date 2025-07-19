import 'package:navinotes/packages.dart';
import 'vm.dart';

class NoteLabReportScreen extends StatelessWidget {
  NoteLabReportScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteLabReportVm(),
      child: Consumer<NoteLabReportVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            backgroundColor: const Color(0xFFF9FAFB),
            body: vm.currentTab,
          );
        },
      ),
    );
  }
}
