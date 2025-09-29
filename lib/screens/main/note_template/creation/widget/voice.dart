// Build voice recorder
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/modern_voice_note_item.dart';

Widget buildVoiceRecorder(
  NoteCreationVm vm,
  Color color,
  BuildContext context,
) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.grey[50], // Plain background independent of note pages
    padding: const EdgeInsets.all(24),
    child: Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Recording controls
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
            const SizedBox(height: 16),
            // Recording status
            Text(
              vm.isRecording
                  ? 'Recording...'
                  : vm.hasRecording
                  ? 'Tap to record a new voice note'
                  : 'Tap to record your first voice note',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),

            // Record/Stop button
            AppButton(
              mainAxisSize: MainAxisSize.min,
              loading: vm.isCreatingNote,
              onTap: vm.toggleRecording,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: vm.isRecording ? Colors.red : AppTheme.vividRose,
              text: vm.isRecording ? 'Stop Recording' : 'Record',
              prefix: Icon(Icons.add, color: AppTheme.white, size: 25),
            ),
            const SizedBox(height: 24),
            // List of recorded voice notes
            if (vm.content?.voiceNotes.isNotEmpty ?? false) ...[
              Row(
                children: [
                  const Text(
                    'Your Voice Notes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${vm.content!.voiceNotes.length} ${vm.content!.voiceNotes.length == 1 ? 'note' : 'notes'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  itemCount: vm.content!.voiceNotes.length,
                  itemBuilder: (context, index) {
                    final voiceNote = vm.content!.voiceNotes[index];
                    final isPlaying =
                        vm.currentlyPlayingIndex == index && vm.isPlaying;

                    return ModernVoiceNoteItem(
                      voiceNote: voiceNote,
                      index: index,
                      vm: vm,
                      isPlaying: isPlaying,
                      onPlay: () => vm.toggleVoiceNotePlayback(index),
                      onDelete: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Delete Voice Note'),
                                content: const Text(
                                  'Are you sure you want to delete this voice note?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                        );

                        if (shouldDelete == true && context.mounted) {
                          await vm.deleteVoiceNote(index);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Voice note deleted'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ] else if (!vm.isRecording) ...[
              const Text(
                'No voice notes recorded yet',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ], // <- Added missing closing bracket for Column children
        ),
      ),
    ),
  );
}
