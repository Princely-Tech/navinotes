import 'package:navinotes/packages.dart';
import 'vm.dart';

class PomodoroTimerHeader extends StatelessWidget {
  const PomodoroTimerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroTimerVm>(
      builder: (_, vm, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: AppTheme.lightGray),
            ),
          ),
          child: Row(
            children: [
              VisibleController(
                mobile: true,
                desktop: false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: MenuButton(onPressed: vm.openDrawer),
                ),
              ),
              IconButton(
                onPressed: NavigationHelper.pop,
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF4B5563),
                ),
              ),
              SizedBox(width: 10),
              SVGImagePlaceHolder(
                imagePath: Images.clock,
                size: 24,
                color: vm.currentStateColor,
              ),
              SizedBox(width: 12),
              Text(
                'Pomodoro Timer',
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: vm.currentStateColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  vm.currentStateLabel,
                  style: TextStyle(
                    color: vm.currentStateColor,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 15),
              VisibleController(
                mobile: true,
                desktop: false,
                child: MenuButton(onPressed: vm.openEndDrawer),
              ),
            ],
          ),
        );
      },
    );
  }
}
