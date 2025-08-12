// Build voice recorder
import 'package:navinotes/packages.dart';
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
        mainAxisAlignment: MainAxisAlignment.start,
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
            const Text(
              'Your Voice Notes:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: vm.content!.voiceNotes.length,
                itemBuilder: (context, index) {
                  final voiceNote = vm.content!.voiceNotes[index];
                  final isPlaying =
                      vm.currentlyPlayingIndex == index && vm.isPlaying;
                  final file = File(voiceNote.file);
                  final fileSize =
                      file.existsSync()
                          ? '${(file.lengthSync() / 1024).toStringAsFixed(1)} KB'
                          : 'N/A';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 36,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () => vm.toggleVoiceNotePlayback(index),
                      ),
                      title: Text(
                        voiceNote.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateTime.fromMillisecondsSinceEpoch(voiceNote.createdAt * 1000).toString().substring(0, 19)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Row(
                            children: [
                              Text(
                                '${voiceNote.formattedDuration} • ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                'Size: ${voiceNote.formattedFileSize}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: Colors.grey[600],
                        onPressed: () async {
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
                                          () =>
                                              Navigator.of(context).pop(false),
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
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else if (!vm.isRecording) ...[
            const Text(
              'No voice notes recorded yet',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ],
      ),
    ),
  );
}
