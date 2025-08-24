import 'package:navinotes/packages.dart';
import 'vm.dart';
import 'widgets.dart';

class YourBoards extends StatelessWidget {
  const YourBoards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (context, vm, child) {
        return Column(
          spacing: 20,
          children: [DashFilterSection(title: 'Your Boards'), _boards(vm)],
        );
      },
    );
  }

  // Widget _boardCard(DashboardVm vm, {required Board board}) {
  //   // Get the appropriate image based on board type

  //   return InkWell(
  //     onTap: () => vm.goToBoard(board),
  //     child: ,
  //   );
  // }

  Widget _boards(DashboardVm vm) {
    final boards = vm.sessionVm.userBoards;

    return CustomGrid(
      children: [
        ...boards.map(
          (board) => BoardCard(board: board, onTap: () => vm.goToBoard(board)),
        ),
        DashboardCreateCard(),
      ],
    );
  }
}
