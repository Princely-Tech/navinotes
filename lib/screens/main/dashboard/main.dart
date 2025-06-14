import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/dashboard/boards.dart';
import 'package:navinotes/screens/main/dashboard/empty_dashboard.dart';
import 'package:navinotes/screens/main/dashboard/recent_activity.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            SearchBarHeader(
              openDrawer: vm.openDrawer,
              borderBottom: !vm.hasData,
            ),
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.all(10),
                tabletPadding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding,
                  vertical: 10,
                ),
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
        );
      },
    );
  }
}
