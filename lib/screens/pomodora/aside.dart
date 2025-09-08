import 'package:navinotes/packages.dart';
import 'vm.dart';

class PomodoroTimerAside extends StatelessWidget {
  const PomodoroTimerAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroTimerVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: AppTheme.lightGray)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              Expanded(
                child: ScrollableController(
                  mobilePadding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 25,
                    children: [
                      _timerSettings(vm),
                      _statistics(vm),
                      _tips(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Text(
        'Settings & Stats',
        style: TextStyle(
          color: const Color(0xFF1F2937),
          fontSize: 16.0,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _timerSettings(PomodoroTimerVm vm) {
    return _section(
      title: 'Timer Settings',
      children: [
        _settingItem(
          'Work Duration',
          '${vm.workDuration} min',
          Icons.work_outline,
          AppTheme.strongBlue,
          () => _showDurationDialog(vm, 'Work Duration', vm.workDuration, vm.updateWorkDuration),
        ),
        _settingItem(
          'Short Break',
          '${vm.shortBreakDuration} min',
          Icons.coffee_outlined,
          AppTheme.vitalGreen,
          () => _showDurationDialog(vm, 'Short Break', vm.shortBreakDuration, vm.updateShortBreakDuration),
        ),
        _settingItem(
          'Long Break',
          '${vm.longBreakDuration} min',
          Icons.hotel_outlined,
          AppTheme.orange,
          () => _showDurationDialog(vm, 'Long Break', vm.longBreakDuration, vm.updateLongBreakDuration),
        ),
      ],
    );
  }

  Widget _statistics(PomodoroTimerVm vm) {
    return _section(
      title: 'Statistics',
      children: [
        _statItem(
          'Total Pomodoros',
          vm.completedPomodoros.toString(),
          Icons.timer_outlined,
          AppTheme.strongBlue,
        ),
        _statItem(
          'Current Cycle',
          '${vm.completedPomodoros % vm.totalPomodoros + 1}/${vm.totalPomodoros}',
          Icons.refresh,
          AppTheme.vitalGreen,
        ),
        SizedBox(height: 10),
        AppButton(
          onTap: vm.resetPomodoros,
          text: 'Reset Statistics',
          color: AppTheme.lightGray,
          mainAxisSize: MainAxisSize.max,
          style: TextStyle(
            color: const Color(0xFF374151),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _tips() {
    return _section(
      title: 'Pomodoro Tips',
      children: [
        _tipItem('🎯', 'Focus on one task at a time'),
        _tipItem('📵', 'Turn off notifications'),
        _tipItem('💧', 'Stay hydrated during breaks'),
        _tipItem('🚶', 'Take a short walk during long breaks'),
        _tipItem('📝', 'Review your progress regularly'),
      ],
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 12.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.60,
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _settingItem(String title, String value, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.lightGray),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF374151),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 16, color: const Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: const Color(0xFF374151),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tipItem(String emoji, String tip) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDurationDialog(PomodoroTimerVm vm, String title, int currentValue, Function(int) onUpdate) {
    final BuildContext? context = NavigationHelper.navigatorKey.currentContext;
    if (context == null) return;

    final TextEditingController controller = TextEditingController(
      text: currentValue.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Set $title',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInputField(
                controller: controller,
                hintText: 'Enter minutes',
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF374151),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Enter duration in minutes (1-60)',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: const Color(0xFF6B7280)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text.trim());
                if (value != null && value > 0 && value <= 60) {
                  onUpdate(value);
                  Navigator.of(dialogContext).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.strongBlue,
                foregroundColor: Colors.white,
              ),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
