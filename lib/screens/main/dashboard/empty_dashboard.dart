import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';
import 'package:navinotes/screens/main/dashboard/widgets.dart';

class EmptyDashboardMain extends StatelessWidget {
  const EmptyDashboardMain({super.key});
  //TODO look at this again
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (_, vm, _) {
        return Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcome(),
            Column(children: [DashFilterSection(title: 'Start Here!')]),
            CreateCard(
              onTap: vm.goToCreateBoard,
              text: 'Create New Board',
              width: 356,
              height: 237,
            ),
            _quickActions(),
            _recentActivity(),
          ],
        );
      },
    );
  }

  Widget _recentActivity() {
    return Column(
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: 18.58,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.40,
          ),
        ),
        //
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
            spacing: 15,
            children: [
              icon,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 14.86,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                  Text(
                    body,
                    style: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: 11.15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                    ),
                  ),
                ],
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
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: 18.58,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
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
      children: [
        Text(
          'Welcome to NaviNotes, Alex!',
          style: TextStyle(
            color: const Color(0xFF333333),
            fontSize: 22.29,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.33,
          ),
        ),
        Text(
          'Ready to organize your Computer Science studies? Let\'s get started.',
          style: TextStyle(
            color: const Color(0xFF4B5563),
            fontSize: 14.86,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
      ],
    );
  }
}
