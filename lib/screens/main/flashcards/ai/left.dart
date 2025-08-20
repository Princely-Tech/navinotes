import 'package:navinotes/packages.dart';

class FlashCardAiCreationLeft extends StatelessWidget {
  const FlashCardAiCreationLeft({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 16),

                  // CREATION MODE
                  _sectionTitle('CREATION MODE'),
                  _smallVGap(),
                  _buildModeOptions(),

                  const SizedBox(height: 24),

                  // AI CONTENT SOURCE
                  _sectionTitle('AI CONTENT SOURCE'),
                  _smallVGap(),
                  _buildContentSources(),

                  const SizedBox(height: 24),

                  // SELECT NOTES
                  _sectionTitle('SELECT NOTES'),
                  _smallVGap(),
                  _buildNotebookSelector(),
                  _buildNoteList(),

                  const SizedBox(height: 24),

                  // GENERATION SETTINGS
                  _sectionTitle('GENERATION SETTINGS'),
                  _smallVGap(),
                  _buildSettings(),

                  const SizedBox(height: 24),

                  // DECK MANAGEMENT
                  _sectionTitle('DECK MANAGEMENT'),
                  _smallVGap(),
                  _buildDeckManagement(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ──────────  Helpers  ────────── */

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF6B7280),
      fontSize: 14,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      height: 1.43,
    ),
  );

  Widget _smallVGap() => const SizedBox(height: 12);

  /* ──────────  CREATION MODE  ────────── */
  Widget _buildModeOptions() {
    return Column(
      children: [
        _selectableRow(text: 'Manual Creation', selected: false),
        _selectableRow(text: 'AI-Assisted', selected: true),
        _selectableRow(text: 'Import from Notes', selected: false),
        _selectableRow(text: 'Batch Creation', selected: false),
      ],
    );
  }

  /* ──────────  AI CONTENT SOURCE  ────────── */
  Widget _buildContentSources() {
    return Column(
      children: [
        _radioRow(text: '🗒️ From My Notes', selected: true),
        _radioRow(text: '📄 Upload Document'),
        _radioRow(text: '✏️ Text Input'),
        _radioRow(text: '🔗 From URL'),
        _radioRow(text: '🎤 Audio Transcript'),
      ],
    );
  }

  /* ──────────  SELECT NOTES  ────────── */
  Widget _buildNotebookSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notebook',
          style: TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        _dropdownField('Neuroscience Basics'),
      ],
    );
  }

  Widget _buildNoteList() {
    final notes = [
      'Memory Formation',
      'Neural Networks',
      'Brain Development',
      'Cognitive Functions',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Available notes',
          style: TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 156,
          child: ListView.separated(
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder:
                (_, i) => _checkableRow(text: notes[i], selected: i < 2),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Select All',
              style: TextStyle(
                color: Color(0xFF0D9488),
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              'Deselect All',
              style: TextStyle(
                color: Color(0xFF0D9488),
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ],
    );
  }

  /* ──────────  GENERATION SETTINGS  ────────── */
  Widget _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sliderField('Number of cards', 12),
        const SizedBox(height: 16),
        _dropdownField('Difficulty level'),
        const SizedBox(height: 16),
        const Text(
          'Card types',
          style: TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        _buildCardTypes(),
        const SizedBox(height: 16),
        const Text(
          'Focus on',
          style: TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        _buildFocusTags(),
      ],
    );
  }

  Widget _buildCardTypes() {
    final types = [
      ('Question & Answer', true),
      ('Definition & Term', true),
      ('Multiple Choice', false),
      ('True/False', false),
    ];
    return Column(
      children:
          types.map((e) => _checkableRow(text: e.$1, selected: e.$2)).toList(),
    );
  }

  Widget _buildFocusTags() {
    final active = ['#neuroscience', '#biology', '#definitions'];
    final inactive = ['#processes', '#examples', '#applications'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...active.map((t) => _chip(t, active: true)),
        ...inactive.map((t) => _chip(t, active: false)),
        _chip('+ Add Tag', active: false),
      ],
    );
  }

  /* ──────────  DECK MANAGEMENT  ────────── */
  Widget _buildDeckManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deck Name',
          style: TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        _textField('Neuroscience Basics'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Cards in deck',
              style: TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            Text(
              '12',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Categories/Tags',
          style: TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _chip('#neuroscience', active: false),
            _chip('#biology', active: false),
            _chip('+ Add Tag', active: false),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Spaced Repetition',
          style: TextStyle(
            color: Color(0xFF4B5563),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        _dropdownField('Select interval'),
      ],
    );
  }

  /* ──────────  Re-usable UI bits  ────────── */

  Widget _selectableRow({required String text, bool selected = false}) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: ShapeDecoration(
        color: selected ? const Color(0xFFF0FDFA) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color:
                  selected ? const Color(0xFF0F766E) : const Color(0xFF374151),
              fontSize: 16,
              fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioRow({required String text, bool selected = false}) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? const Color(0xFF0075FF) : Colors.black54,
                width: 0.5,
              ),
            ),
            child:
                selected
                    ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: Color(0xFF0075FF),
                      ),
                    )
                    : null,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 16,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkableRow({required String text, bool selected = false}) {
    return Container(
      height: 36,
      decoration: ShapeDecoration(
        color: const Color(0xFFF9FAFB),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF0075FF) : Colors.white,
              border: Border.all(width: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
            child:
                selected
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _sliderField(String label, int value) {
    return Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 9,
                      ),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: value.toDouble(),
                      min: 0,
                      max: 30,
                      divisions: 30,
                      activeColor: const Color(0xFF0075FF),
                      inactiveColor: const Color(0xFFE5E5E5),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$value',
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _dropdownField(String hint) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 16,
              fontFamily: 'Inter',
            ),
          ),
          const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _textField(String text) {
    return Container(
      height: 42,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 16,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _chip(String text, {required bool active}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        color: active ? const Color(0xFFCCFBF1) : const Color(0xFFF3F4F6),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? const Color(0xFF115E59) : const Color(0xFF1F2937),
          fontSize: 12,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
