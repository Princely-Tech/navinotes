// Build voice recorder
import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';

Widget buildVoiceRecorder(
  NoteCreationVm vm,
  Color color,
  BuildContext context,
) {
  return Expanded(
    child: Container(
      color: color,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visualizer or instructions
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
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
                  Icons.mic,
                  size: 64,
                  color: vm.isRecording ? Colors.red : Colors.grey[600],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Recording status
          Text(
            vm.isRecording
                ? 'Recording...'
                : vm.hasRecording
                ? 'Tap to play/pause'
                : 'Tap to record',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Clear button (only shown when there's a recording)
              if (vm.hasRecording)
                FloatingActionButton(
                  heroTag: 'clear_recording',
                  onPressed: vm.clearRecording,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.delete, color: Colors.grey[800]),
                ),
              const SizedBox(width: 24),
              // Record/Stop button
              FloatingActionButton.large(
                heroTag: 'record_button',
                onPressed: vm.toggleRecording,
                backgroundColor:
                    vm.isRecording
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                child: Icon(vm.isRecording ? Icons.stop : Icons.mic, size: 32),
              ),
              const SizedBox(width: 24),
              // Play/Pause button (only shown when there's a recording)
              if (vm.hasRecording)
                FloatingActionButton(
                  heroTag: 'play_button',
                  onPressed: vm.togglePlayback,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    vm.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
