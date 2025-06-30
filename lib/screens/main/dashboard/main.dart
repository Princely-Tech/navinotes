import 'package:navinotes/packages.dart';
import 'boards.dart';
import 'empty_dashboard.dart';
import 'recent_activity.dart';
import 'vm.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (_, vm, _) {
        bool hasData = vm.sessionVm.userBoards.isNotEmpty;
        return Column(
          children: [
            SearchBarHeader(openDrawer: vm.openDrawer, borderBottom: !hasData),
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.all(10),
                tabletPadding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding,
                  vertical: 10,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child:
                      hasData
                          ? Column(
                            spacing: 30,
                            children: [YourBoards(), RecentActivity()],
                          )
                          : EmptyDashboardMain(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
