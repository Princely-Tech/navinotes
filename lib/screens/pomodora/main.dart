import 'package:navinotes/packages.dart';
import 'vm.dart';

class PomodoroTimerMain extends StatelessWidget {
  const PomodoroTimerMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroTimerVm>(
      builder: (_, vm, _) {
        return ResponsiveHorizontalPadding(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 120,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  
                  // Timer Circle
                  Container(
                    width: 250,
                    height: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background circle
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: vm.currentStateColor.withOpacity(0.1),
                          ),
                        ),
                        // Progress circle
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CircularProgressIndicator(
                            value: vm.progress,
                            strokeWidth: 6,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              vm.currentStateColor,
                            ),
                          ),
                        ),
                        // Timer text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              vm.formattedTime,
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F2937),
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              vm.currentStateLabel,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: vm.currentStateColor,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: [
                      // Reset button
                      AppButton(
                        onTap: vm.reset,
                        text: 'Reset',
                        color: AppTheme.lightGray,
                        mainAxisSize: MainAxisSize.min,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        style: TextStyle(
                          color: const Color(0xFF374151),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      // Play/Pause button
                      AppButton(
                        onTap: vm.isRunning ? vm.pause : vm.start,
                        text: vm.isRunning ? 'Pause' : 'Start',
                        color: vm.currentStateColor,
                        mainAxisSize: MainAxisSize.min,
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      
                      // Skip button
                      AppButton(
                        onTap: vm.skip,
                        text: 'Skip',
                        color: AppTheme.lightGray,
                        mainAxisSize: MainAxisSize.min,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        style: TextStyle(
                          color: const Color(0xFF374151),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Progress indicators
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Pomodoros Completed',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF6B7280),
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(vm.totalPomodoros, (index) {
                            final isCompleted = index < vm.completedPomodoros % vm.totalPomodoros;
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted 
                                    ? AppTheme.strongBlue 
                                    : Colors.grey[300],
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '${vm.completedPomodoros} total completed',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF9CA3AF),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
