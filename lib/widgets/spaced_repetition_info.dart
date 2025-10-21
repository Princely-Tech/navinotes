import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/study/vm.dart';

/// Widget that displays spaced repetition information and statistics
class SpacedRepetitionInfo extends StatelessWidget {
  final FlashCardStudyVm vm;
  final bool showDetailedStats;
  
  const SpacedRepetitionInfo({
    super.key,
    required this.vm,
    this.showDetailedStats = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!vm.hasCardsToStudy && vm.studyQueue.isEmpty) {
      return _buildNoCardsMessage();
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSessionSummary(),
        if (showDetailedStats) ...[
          const SizedBox(height: 16),
          _buildDetailedStats(),
        ],
      ],
    );
  }

  Widget _buildNoCardsMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.celebration,
            color: Color(0xFF0EA5E9),
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vm.sessionSummary,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule,
            color: Color(0xFF6366F1),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              vm.sessionSummary,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          if (vm.newCardsStudied > 0 || vm.reviewCardsStudied > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${vm.newCardsStudied + vm.reviewCardsStudied} studied',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deck Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          _buildStatRow('Total Cards', vm.totalCardsInDeck, Colors.blue),
          _buildStatRow('Due for Review', vm.dueCardsCount, Colors.orange),
          _buildStatRow('New Cards', vm.newCardsCount, Colors.green),
          _buildStatRow('Learning', vm.learningCardsCount, Colors.purple),
          _buildStatRow('Mature', vm.reviewCardsCount, Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
