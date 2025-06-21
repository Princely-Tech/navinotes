import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';
import 'package:navinotes/screens/main/dashboard/widgets.dart';

class EmptyDashboardMain extends StatelessWidget {
  const EmptyDashboardMain({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (_, vm, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            spacing: 30,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _welcome(),
              Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashFilterSection(title: 'Start Here!'),
                  DashboardCreateCard(),
                ],
              ),
              _quickActions(),
              _recentActivity(vm),
            ],
          ),
        );
      },
    );
  }

  Widget _recentActivity(DashboardVm vm) {
    return Column(
      spacing: 15,
      children: [
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: Text(
                'Recent Activity',
                style: Apptheme.text.copyWith(
                  color: Apptheme.graphite,
                  fontSize: 18.58,
                  fontWeight: getFontWeight(600),
                  height: 1.40,
                ),
              ),
            ),
            AppButton.text(
              mainAxisSize: MainAxisSize.min,
              onTap: () {
                NavigationHelper.push(Routes.recentNotes);
              },
              text: 'View all',
              style: Apptheme.text.copyWith(
                color: Apptheme.tropicalTeal,
                fontSize: 13.0,
                fontWeight: getFontWeight(500),
              ),
            ),
          ],
        ),

        CustomCard(
          child: WidthLimiter(
            mobile: 400,
            child: Column(
              spacing: 20,
              children: [
                Column(
                  spacing: 10,
                  children: [
                    OutlinedChild(
                      size: 59,
                      decoration: BoxDecoration(
                        color: Apptheme.lightAsh,
                        shape: BoxShape.circle,
                      ),
                      child: SVGImagePlaceHolder(
                        imagePath: Images.recent,
                        size: 27,
                        color: Apptheme.lightGray,
                      ),
                    ),
                    Text(
                      'No Recent Activity Yet',
                      textAlign: TextAlign.center,
                      style: Apptheme.text.copyWith(
                        color: Apptheme.graphite,
                        fontSize: 16.72,
                        fontWeight: getFontWeight(500),
                      ),
                    ),
                    Text(
                      'Your activity will appear here once you start creating and editing boards, notes, and flashcards.',
                      textAlign: TextAlign.center,
                      style: Apptheme.text.copyWith(color: Apptheme.steelMist),
                    ),
                  ],
                ),
                AppButton(
                  mainAxisSize: MainAxisSize.min,
                  onTap: vm.goToCreateBoard,
                  text: 'Create Your First Board',
                  color: Apptheme.tropicalTeal,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionItem({
    required String title,
    required String body,
    required Widget icon,
  }) {
    return ExpandableController(
      mobile: false,
      desktop: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 300),
        child: CustomCard(
          width: null,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 15,
            children: [
              icon,
              ExpandableController(
                mobile: false,
                desktop: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Apptheme.text.copyWith(
                        color: Apptheme.graphite,
                        fontSize: 14.86,
                        fontWeight: getFontWeight(500),
                        height: 1.50,
                      ),
                    ),
                    Text(
                      body,
                      style: Apptheme.text.copyWith(
                        color: Apptheme.steelMist,
                        fontSize: 11.15,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickActions() {
    Widget importPdf = _actionItem(
      icon: OutlinedChild(
        decoration: BoxDecoration(
          color: Apptheme.paleBlue,
          shape: BoxShape.circle,
        ),
        child: SVGImagePlaceHolder(
          imagePath: Images.pdf,
          size: 14,
          color: Apptheme.vividBlue,
        ),
      ),
      body: 'Convert documents to notes',
      title: 'Import PDF',
    );
    Widget takeTour = _actionItem(
      icon: OutlinedChild(
        decoration: BoxDecoration(
          color: Apptheme.lavenderBlush,
          shape: BoxShape.circle,
        ),
        child: SVGImagePlaceHolder(imagePath: Images.map, size: 14),
      ),
      body: 'Learn NaviNotes features',
      title: 'Take a Tour',
    );
    Widget connectCalender = _actionItem(
      icon: OutlinedChild(
        decoration: BoxDecoration(
          color: Apptheme.mintWhisper,
          shape: BoxShape.circle,
        ),
        child: SVGImagePlaceHolder(imagePath: Images.calender2, size: 14),
      ),
      body: 'Sync study schedules',
      title: 'Connect Calendar',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          'Quick Actions',
          style: Apptheme.text.copyWith(
            color: Apptheme.graphite,
            fontSize: 18.58,
            fontWeight: getFontWeight(600),
            height: 1.40,
          ),
        ),
        ScrollableController(
          desktop: false,
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 10,
            children: [importPdf, takeTour, connectCalender],
          ),
        ),
      ],
    );
  }

  Widget _welcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 3,
      children: [
        Text(
          'Welcome to NaviNotes, Alex!',
          style: Apptheme.text.copyWith(
            color: Apptheme.graphite,
            fontSize: 22.29,
            fontWeight: getFontWeight(700),
            height: 1.33,
          ),
        ),
        Text(
          'Ready to organize your Computer Science studies? Let\'s get started.',
          style: Apptheme.text.copyWith(
            color: Apptheme.stormGray,
            height: 1.50,
          ),
        ),
      ],
    );
  }
}
