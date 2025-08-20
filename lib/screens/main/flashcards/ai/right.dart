import 'package:navinotes/packages.dart';

class FlashCardAiCreationRight extends StatelessWidget {
  const FlashCardAiCreationRight({super.key});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF0D9488);
    const gray100 = Color(0xFFF3F4F6);
    const gray300 = Color(0xFFE5E7EB);
    const gray500 = Color(0xFF6B7280);
    const gray700 = Color(0xFF1F2937);

    return Container(
      color: Colors.white,

      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Cards in Deck section ------------------------------------------
                  _sectionHeader(title: 'Cards in Deck', trailing: '12 cards'),
                  const SizedBox(height: 16),
                  _flashCard(
                    title1: 'What is the function of',
                    title2: 'neurons in the brain?',
                    progress: '95%',
                    source: 'Memory Formation notes',
                  ),
                  const SizedBox(height: 12),
                  _flashCard(
                    title1: 'Define neurotransmitters and',
                    title2: 'their role',
                    progress: '78%',
                    source: 'Neural Networks notes',
                  ),
                  const SizedBox(height: 12),
                  _flashCard(
                    title1: 'Explain the concept of',
                    title2: 'neuroplasticity',
                    progress: '92%',
                    source: 'Memory Formation notes',
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Show all 12 cards',
                      style: const TextStyle(color: teal, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Generation Analytics section -----------------------------------
                  _sectionHeader(title: 'Generation Analytics'),
                  const SizedBox(height: 16),
                  _analyticsCard(),

                  const SizedBox(height: 40),

                  // ── Action buttons -------------------------------------------------
                  _actionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({required String title, String? trailing}) {
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
        ],
      ),
    );
  }

  Widget _flashCard({
    required String title1,
    required String title2,
    required String progress,
    required String source,
  }) {
    const gray300 = Color(0xFFE5E7EB);
    const gray500 = Color(0xFF6B7280);
    const gray700 = Color(0xFF1F2937);
    const teal50 = Color(0xFFF0FDFA);
    const teal200 = Color(0xFF99F6E4);

    return Container(
      width: 287,
      height: 86,
      decoration: ShapeDecoration(
        color: title1.contains('neurons') ? teal50 : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: title1.contains('neurons') ? teal200 : gray300,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title1,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: gray700,
                      ),
                    ),
                    Text(
                      title2,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: gray700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.folder_outlined, size: 12, color: gray500),
                    const SizedBox(width: 4),
                    Text(
                      '$progress • $source',
                      style: const TextStyle(fontSize: 12, color: gray500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              _miniButton(icon: Icons.edit_outlined),
              const SizedBox(width: 4),
              _miniButton(icon: Icons.delete_outline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniButton({required IconData icon}) {
    return Container(
      width: 24,
      height: 32,
      alignment: Alignment.center,
      child: Icon(icon, size: 16, color: const Color(0xFF6B7280)),
    );
  }

  Widget _analyticsCard() {
    const teal = Color(0xFF14B8A6);
    const gray300 = Color(0xFFE5E7EB);
    const gray500 = Color(0xFF6B7280);
    const gray700 = Color(0xFF1F2937);

    return Container(
      width: 287,
      decoration: BoxDecoration(
        border: Border.all(color: gray300),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coverage
          const Text(
            'Coverage Analysis',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.85,
              minHeight: 8,
              backgroundColor: const Color(0xFFF3F4F6),
              color: teal,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '85% of source material covered',
                style: TextStyle(fontSize: 12, color: gray500),
              ),
              Text(
                '15% missing',
                style: TextStyle(fontSize: 12, color: gray500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '3 concepts may need additional cards',
            style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
          ),
          const SizedBox(height: 16),

          // Quality
          const Text(
            'Quality Metrics',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _metricRow('Average confidence', '87%'),
          _metricRow('Card clarity score', '8.5/10'),
          _metricRow('Difficulty distribution', 'Balanced'),
          const SizedBox(height: 16),

          // Suggestions
          const Text(
            'Suggestions',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          _suggestionItem(Icons.add, 'Add 2 cards about synaptic transmission'),
          _suggestionItem(
            Icons.lightbulb_outline,
            'Consider breaking down complex card #7',
          ),
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _suggestionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6B7280)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    const teal = Color(0xFF0D9488);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {},
            child: const Text('Generate more cards'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: teal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Improve low confidence cards',
              style: TextStyle(color: teal),
            ),
          ),
        ),
      ],
    );
  }
}
