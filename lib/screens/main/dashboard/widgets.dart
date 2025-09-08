import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';

class DashFilterSection extends StatelessWidget {
  const DashFilterSection({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
      side: BorderSide(color: AppTheme.coolGray),
    );
    return Row(
      spacing: 30,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTheme.text.copyWith(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardCreateCard extends StatelessWidget {
  const DashboardCreateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (_, vm, _) {
        bool hasData = vm.sessionVm.userBoards.isNotEmpty;
        return CreateCard(
          onTap: vm.goToCreateBoard,
          text: 'Create New Board',
          width: hasData ? double.infinity : 356,
          height: hasData ? null : 237,
        );
      },
    );
  }
}
