import 'dart:async';
import 'package:navinotes/packages.dart';

enum PomodoroState { work, shortBreak, longBreak }

class PomodoroTimerVm extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final BuildContext context;

  PomodoroTimerVm({
    required this.scaffoldKey,
    required this.context,
  });

  // Timer settings (in minutes)
  int _workDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 15;

  // Current state
  PomodoroState _currentState = PomodoroState.work;
  int _currentSeconds = 25 * 60; // Start with work duration
  bool _isRunning = false;
  int _completedPomodoros = 0;
  int _totalPomodoros = 4; // Complete cycle

  Timer? _timer;

  // Getters
  int get workDuration => _workDuration;
  int get shortBreakDuration => _shortBreakDuration;
  int get longBreakDuration => _longBreakDuration;
  PomodoroState get currentState => _currentState;
  int get currentSeconds => _currentSeconds;
  bool get isRunning => _isRunning;
  int get completedPomodoros => _completedPomodoros;
  int get totalPomodoros => _totalPomodoros;

  String get currentStateLabel {
    switch (_currentState) {
      case PomodoroState.work:
        return 'Focus Time';
      case PomodoroState.shortBreak:
        return 'Short Break';
      case PomodoroState.longBreak:
        return 'Long Break';
    }
  }

  Color get currentStateColor {
    switch (_currentState) {
      case PomodoroState.work:
        return AppTheme.strongBlue;
      case PomodoroState.shortBreak:
        return AppTheme.vitalGreen;
      case PomodoroState.longBreak:
        return AppTheme.orange;
    }
  }

  String get formattedTime {
    final minutes = _currentSeconds ~/ 60;
    final seconds = _currentSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    final totalDuration = _getCurrentStateDuration() * 60;
    return (totalDuration - _currentSeconds) / totalDuration;
  }

  void initialize() {
    _resetTimer();
    notifyListeners();
  }

  void start() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentSeconds > 0) {
          _currentSeconds--;
          notifyListeners();
        } else {
          _completeCurrentState();
        }
      });
      notifyListeners();
    }
  }

  void pause() {
    if (_isRunning) {
      _isRunning = false;
      _timer?.cancel();
      notifyListeners();
    }
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _resetTimer();
    notifyListeners();
  }

  void skip() {
    _timer?.cancel();
    _isRunning = false;
    _completeCurrentState();
  }

  void _completeCurrentState() {
    _timer?.cancel();
    _isRunning = false;

    if (_currentState == PomodoroState.work) {
      _completedPomodoros++;
      
      // Show completion notification
      _showNotification('Pomodoro Complete!', 'Great work! Time for a break.');
      
      // Determine next state
      if (_completedPomodoros % _totalPomodoros == 0) {
        _currentState = PomodoroState.longBreak;
      } else {
        _currentState = PomodoroState.shortBreak;
      }
    } else {
      // Break is over, back to work
      _currentState = PomodoroState.work;
      _showNotification('Break Over!', 'Time to get back to work.');
    }

    _resetTimer();
    notifyListeners();
  }

  void _resetTimer() {
    _currentSeconds = _getCurrentStateDuration() * 60;
  }

  int _getCurrentStateDuration() {
    switch (_currentState) {
      case PomodoroState.work:
        return _workDuration;
      case PomodoroState.shortBreak:
        return _shortBreakDuration;
      case PomodoroState.longBreak:
        return _longBreakDuration;
    }
  }

  void updateWorkDuration(int minutes) {
    _workDuration = minutes;
    if (_currentState == PomodoroState.work && !_isRunning) {
      _resetTimer();
    }
    notifyListeners();
  }

  void updateShortBreakDuration(int minutes) {
    _shortBreakDuration = minutes;
    if (_currentState == PomodoroState.shortBreak && !_isRunning) {
      _resetTimer();
    }
    notifyListeners();
  }

  void updateLongBreakDuration(int minutes) {
    _longBreakDuration = minutes;
    if (_currentState == PomodoroState.longBreak && !_isRunning) {
      _resetTimer();
    }
    notifyListeners();
  }

  void resetPomodoros() {
    _completedPomodoros = 0;
    _currentState = PomodoroState.work;
    reset();
  }

  void _showNotification(String title, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(message),
            ],
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: currentStateColor,
        ),
      );
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
