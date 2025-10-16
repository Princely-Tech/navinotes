// Build voice recorder
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/read/vm.dart';
import 'package:navinotes/screens/main/note_template/read/widget/modern_voice_note_item.dart';

Widget buildVoiceRecorder(NoteReadVm vm, Color color, BuildContext context) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.grey[50], // Plain background independent of note pages
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
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
                    Icon(Icons.mic, size: 64, color: Colors.grey[600]),
                  ],
                ),
              ),
              const SizedBox(height: 16),

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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                    );
                  },
                ),
              ] else
                const Text(
                  'No voice notes recorded yet',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
