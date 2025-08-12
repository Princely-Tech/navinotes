import 'package:navinotes/packages.dart';

class BoardEditAssignment extends StatelessWidget {
  const BoardEditAssignment(this.vm, {super.key});
  final BoardEditVm vm;
  @override
  Widget build(BuildContext context) {
    BoardTypeCodes? boardType = vm.board.boardType;
    final courseOutlines = vm.board.courseTimeLines ?? [];
    if (isNotNull(courseOutlines)) {
      switch (boardType) {
        case BoardTypeCodes.darkAcademia:
          return Column(
            children: [
              for (int i = 0; i < courseOutlines.length; i++)
                BoardDarkAcadTimelineItem(courseOutlines[i], isFirst: i == 0),
            ],
          );
        case BoardTypeCodes.nature:
          return Column(
            children: [
              for (int i = 0; i < courseOutlines.length; i++)
                BoardNatureOutlineItem(i),
            ],
          );
        case BoardTypeCodes.minimalist:
          return Column(
            children:
                courseOutlines
                    .map((item) => BoardMinimalistOutlineItem(item))
                    .toList(),
          );
        case BoardTypeCodes.lightAcademia:
          return Column(
            children:
                courseOutlines
                    .map((item) => BoardLightAcadTimelineItem(item))
                    .toList(),
          );
        default:
      }
    }
    return _emptyBody();
  }

  Widget _emptyBody() {
    return Consumer<ApiServiceProvider>(
      builder: (_, apiServiceProvider, _) {
        return Builder(
          builder: (context) {
            return EmptyState(
              icon: Icons.folder_open,
              title: 'No syllabus upload',
              subtitle: 'Upload syllabus to get started',
              footer: AppButton(
                loading: vm.uploadingSyllabus,
                onTap:
                    () => vm.uploadSyllabus(
                      context: context,
                      apiServiceProvider: apiServiceProvider,
                    ),
                text: 'Upload syllabus',
                mainAxisSize: MainAxisSize.min,
              ),
            );
          },
        );
      },
    );
  }
}
