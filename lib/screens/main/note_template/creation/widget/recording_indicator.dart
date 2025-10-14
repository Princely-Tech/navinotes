import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';

class RecordingIndicator extends StatefulWidget {
  final NoteCreationVm vm;
  final bool isCompact;
  final bool showInHeader;

  const RecordingIndicator({
    Key? key,
    required this.vm,
    this.isCompact = true,
    this.showInHeader = true,
  }) : super(key: key);

  @override
  State<RecordingIndicator> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<RecordingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  DateTime? _recordingStartTime;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start pulse animation if already recording
    if (widget.vm.isRecording) {
      _startRecording();
    }

    // Listen to recording state changes
    widget.vm.addListener(_onRecordingStateChanged);
  }

  @override
  void dispose() {
    widget.vm.removeListener(_onRecordingStateChanged);
    // Stop any running animations before disposing
    try {
      _pulseController.stop();
      _pulseController.reset();
      _pulseController.dispose();
    } catch (e) {
      debugPrint('Error disposing pulse animation controller: $e');
    }
    super.dispose();
  }

  void _onRecordingStateChanged() {
    if (!mounted) return; // Don't update if widget is disposed
    
    try {
      if (widget.vm.isRecording && !_pulseController.isAnimating) {
        _startRecording();
      } else if (!widget.vm.isRecording && _pulseController.isAnimating) {
        _stopRecording();
      }
    } catch (e) {
      debugPrint('Error updating recording state: $e');
    }
  }

  void _startRecording() {
    if (!mounted) return;
    
    try {
      _recordingStartTime = DateTime.now();
      _pulseController.repeat(reverse: true);
    } catch (e) {
      debugPrint('Error starting recording animation: $e');
    }
  }

  void _stopRecording() {
    try {
      _recordingStartTime = null;
      _pulseController.stop();
      _pulseController.reset();
    } catch (e) {
      debugPrint('Error stopping recording animation: $e');
    }
  }

  String _getRecordingDuration() {
    if (_recordingStartTime == null) return '00:00';
    
    final duration = DateTime.now().difference(_recordingStartTime!);
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.vm.isRecording) {
      return const SizedBox.shrink();
    }

    if (widget.showInHeader) {
      return _buildHeaderIndicator();
    } else {
      return _buildInlineIndicator();
    }
  }

  Widget _buildHeaderIndicator() {
    return Positioned(
      top: 15, // In the header area
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPulsingDot(size: 6),
            const SizedBox(width: 4),
            const Icon(
              Icons.mic,
              color: Colors.white,
              size: 12,
            ),
            const SizedBox(width: 4),
            _buildTimer(fontSize: 11),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPulsingDot(size: 4),
          const SizedBox(width: 3),
          _buildTimer(fontSize: 10),
        ],
      ),
    );
  }

  Widget _buildPulsingDot({required double size}) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimer({required double fontSize}) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        return Text(
          _getRecordingDuration(),
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        );
      },
    );
  }
}
