import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/read/widget/multi_page_viewer.dart';
import 'vm.dart';

class NoteReadMain extends StatelessWidget {
  const NoteReadMain({super.key});

  @override
  Widget build(BuildContext context) {
    final inputWidth = MediaQuery.of(context).size.width;
    final inputHeight = MediaQuery.of(context).size.height * 3;

    return Consumer<NoteReadVm>(
      builder: (_, vm, _) {
        Color color = AppTheme.transparent;
        switch (vm.template.image) {
          case Images.noteTemplateCornell:
            color = const Color(0xFFD1CDC4);
        }
        return Column(
          children: [
            Expanded(
              child: Container(
                color: AppTheme.lightAsh,
                child: MultiPageViewer(
                  vm: vm,
                  backgroundColor: color,
                  inputWidth: inputWidth,
                  inputHeight: inputHeight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
