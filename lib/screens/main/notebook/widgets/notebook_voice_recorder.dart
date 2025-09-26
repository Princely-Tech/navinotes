import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/notebook/notebook_page_vm.dart';

class NotebookVoiceRecorder extends StatelessWidget {
  final NotebookPageVm vm;

  const NotebookVoiceRecorder({
    super.key,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Recording controls
          GestureDetector(
            onTap: vm.isRecording ? vm.stopRecording : vm.startRecording,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: vm.isRecording ? Colors.red.withOpacity(0.1) : Colors.grey[200],
                border: Border.all(
                  color: vm.isRecording ? Colors.red : Colors.grey,
                  width: 4,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (vm.isRecording)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 4,
                    ),
                  Icon(
                    vm.isRecording ? Icons.stop : Icons.mic,
                    size: 64,
                    color: vm.isRecording ? Colors.red : Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Recording status
          Text(
            vm.isRecording
                ? 'Recording... Tap to stop'
                : vm.hasRecording
                ? 'Tap to record a new voice note'
                : 'Tap to record your first voice note',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Playback controls (if recording exists)
          if (vm.hasRecording && !vm.isRecording) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: vm.isPlaying ? vm.stopPlaying : vm.playRecording,
                  icon: Icon(
                    vm.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                  tooltip: vm.isPlaying ? 'Pause' : 'Play',
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: vm.deleteRecording,
                  icon: const Icon(
                    Icons.delete,
                    size: 32,
                    color: Colors.red,
                  ),
                  tooltip: 'Delete Recording',
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              vm.isPlaying ? 'Playing...' : 'Recording saved',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
          
          const SizedBox(height: 48),
          
          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue[700],
                  size: 20,
                ),
                const SizedBox(height: 8),
                Text(
                  'Voice notes are perfect for capturing ideas, lectures, or quick thoughts. Your recordings are saved automatically.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
