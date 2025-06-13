import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/dashboard/boards.dart';
import 'package:navinotes/screens/main/dashboard/empty_dashboard.dart';
import 'package:navinotes/screens/main/dashboard/header.dart';
import 'package:navinotes/screens/main/dashboard/recent_activity.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (_, vm, _) {
        return ResponsivePadding(
          mobile: EdgeInsets.all(10),
          tablet: EdgeInsets.symmetric(
            horizontal: defaultHorizontalPadding,
            vertical: 10,
          ),
          child: Column(
            spacing: 10,
            children: [
              DashboardHeader(),
              Expanded(
                child: ScrollableController(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child:
                      vm.hasData
                          ? Column(
                            spacing: 30,
                            children: [YourBoards(), RecentActivity()],
                          )
                          : EmptyDashboardMain(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
