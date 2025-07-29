import 'package:navinotes/packages.dart';

class BoardEditAssignment extends StatelessWidget {
  const BoardEditAssignment(this.vm, {super.key});
  final BoardEditVm vm;
  @override
  Widget build(BuildContext context) {
    if (vm.uploadingSyllabus) {
      return const Center(child: CircularProgressIndicator());
    }
    return Consumer<ApiServiceProvider>(
      builder: (_, apiServiceProvider, _) {
        return EmptyState(
          icon: Icons.folder_open,
          title: 'No syllabus upload',
          subtitle: 'Upload syllabus to get started',
          footer: AppButton(
            loading: vm.uploadingSyllabus,
            onTap: () => vm.uploadSyllabus(
                          context: context,
                          apiServiceProvider: apiServiceProvider,
                        ),
            text: 'Upload syllabus',
            mainAxisSize: MainAxisSize.min,
          ),
        );
      }
    );
  }
}
