import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/ai/edit.dart';
import 'package:navinotes/screens/main/flashcards/create_vm.dart';

/* ----------------------------------------------------------
   1. Root widget (the original 832×1391 container)
---------------------------------------------------------- */
class FlashCardAiCreationMain extends StatelessWidget {
  const FlashCardAiCreationMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollableController(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_statusPanel(), AiGenerationInputView()],
      ),
    );
  }

  Widget _statusPanel() {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        bool hasContent = vm.generatedFlashCards.isNotEmpty;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
          ),

          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                // Title row
                Row(
                  spacing: 15,
                  children: [
                    Expanded(
                      child: const Text(
                        'AI Generation Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    Row(
                      spacing: 6,
                      children: [
                        Text(
                          vm.loading
                              ? 'Generating...'
                              : hasContent
                              ? 'Generation complete'
                              : 'Not Started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        if (!vm.loading && hasContent)
                          Icon(
                            Icons.check_circle,
                            color: Color(0xFF22C55E),
                            size: 16,
                          ),
                      ],
                    ),
                  ],
                ),
                if (vm.generationInfo != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFE5E7EB),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate content to see analytics',
                          style: AppTheme.text,
                        ),
                        if (hasContent)
                          Column(
                            children: [
                              _StatRow(
                                text:
                                    'Generated ${vm.generatedFlashCards.length} flashcards',
                              ),
                              _StatRow(
                                text:
                                    'Difficulty: ${vm.generationInfo!['distribution']}',
                              ),
                              _StatRow(
                                text:
                                    'Coverage: ${vm.generationInfo!['coverage']}',
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/* ----------------------------------------------------------
   3. Card section (title + card + actions + bulk + tip)
---------------------------------------------------------- */

/* ----------------------------------------------------------
   4. Re-usable widgets
---------------------------------------------------------- */
class _StatRow extends StatelessWidget {
  const _StatRow({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const SizedBox(
            width: 12,
            height: 14,
            child: Icon(Icons.circle, size: 6, color: Color(0xFFE5E7EB)),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
          ),
        ],
      ),
    );
  }
}
