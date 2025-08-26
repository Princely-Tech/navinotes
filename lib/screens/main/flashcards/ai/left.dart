import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/ai/file_upload.dart';
import 'package:navinotes/screens/main/flashcards/create_vm.dart';

class FlashCardAiCreationLeft extends StatelessWidget {
  const FlashCardAiCreationLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CREATION MODE
                  _sectionTitle('CREATION MODE'),
                  _smallVGap(),
                  _buildModeOptions(),

                  // _divider(),
                  const SizedBox(height: 24),

                  // AI CONTENT SOURCE
                  _sectionTitle('AI CONTENT SOURCE'),
                  _smallVGap(),
                  Column(
                    children:
                        AIContentSource.values
                            .map((item) => _contentSourceRow(item))
                            .toList(),
                  ),

                  const SizedBox(height: 24),

                  _returnCreationModeSection(),
                  const SizedBox(height: 24),
                  _sectionTitle('GENERATION SETTINGS'),
                  _smallVGap(),
                  _buildSettings(),
                  // const SizedBox(height: 24),

                  // // DECK MANAGEMENT
                  // _sectionTitle('DECK MANAGEMENT'),
                  // _smallVGap(),
                  // _buildDeckManagement(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadSection() {
                                                return ContentFileUpload();

  }

  Widget _textInputSection(FlashCardCreationVm vm) {
    return CustomInputField(
      controller: vm.contentController,
      hintText: 'Content for Flash Cards',
      label: 'Content',
      minLines: 5,
      maxLines: 10,
    );
  }

  Widget _returnCreationModeSection() {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        switch (vm.selectedAISource) {
          case AIContentSource.fromNotes:
            return _notesSection();
          case AIContentSource.upload:
            return _uploadSection();
          case AIContentSource.textInput:
            return _textInputSection(vm);
        }
      },
    );
  }

  Widget _notesSection() {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        if (vm.gettingAllBoards) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('SELECT NOTES'),
            _smallVGap(),
            // _buildNotebookSelector(),
            SearchDropdownField<Board>(
              controller: TextEditingController(text: vm.selectedBoard?.name),
              suggestionsCallback: (search) {
                return vm.allBoards
                    .where((item) => checkStringMatch(item.name, search))
                    .toList();
              },
              itemBuilder: (_, item) {
                return CustomListTile(
                  onTap: () {
                    vm.updateNoteBookControllerText(item);
                  },
                  title: item.name,
                  color: AppTheme.steelMist,
                  activeColor: AppTheme.strongBlue,
                );
              },
              input: CustomInputField(
                suffixIcon: Icon(Icons.keyboard_arrow_down),
                label: 'Notebook',
              ),
            ),
            if (vm.selectedBoard != null) _buildNoteList(),
          ],
        );
      },
    );
  }

  Widget _divider() =>
      const Divider(color: Color(0xFFE5E7EB), thickness: 1, height: 48);

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
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        return Column(
          spacing: 8,
          children: [
            InkWell(
              onTap:
                  () => NavigationHelper.navigateToManualFlashCard(
                    ManualFlashCardProps(deck: vm.deck),
                    replace: true,
                  ),
              child: _selectableRow(
                text: 'Manual Creation',
                selected: false,
                icon: Images.edit,
              ),
            ),

            _selectableRow(
              text: 'AI-Assisted',
              selected: true,
              icon: Images.aiBot,
            ),

            // _selectableRow(text: 'Import from Notes', selected: false),
            // _selectableRow(text: 'Batch Creation', selected: false),
          ],
        );
      },
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
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            if (vm.allContent.isNotEmpty) ...[
              const Text(
                'Available notes',
                style: TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children:
                        vm.allContent.map((item) {
                          return _checkableRow(
                            text: item.title,
                            onTap: () => vm.updateSelectedContents(item),
                            selected: vm.selectedContent.contains(item),
                          );
                        }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton.text(
                    onTap: vm.selectAllContents,
                    text: 'Select All',
                    style: TextStyle(
                      color: Color(0xFF0D9488),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                  AppButton.text(
                    onTap: vm.deselectAllContents,
                    text: 'Deselect All',
                    style: TextStyle(
                      color: Color(0xFF0D9488),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ] else if (vm.selectedBoard != null)
              AppButton(
                onTap: vm.goToCreateNote,
                text: 'Create ${vm.selectedBoard?.name} Note',
              ),
          ],
        );
      },
    );
  }

  /* ──────────  GENERATION SETTINGS  ────────── */
  Widget _buildSettings() {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sliderField(),
            const SizedBox(height: 16),
            CustomInputField(
              controller: vm.difficultyController,
              selectItems:
                  FlashcardDifficulty.values
                      .where(
                        (e) => e != FlashcardDifficulty.again,
                      ) // remove hard
                      .map((e) => e.toString())
                      .toList(),
              label: 'Difficulty level',
              isMultipleSelect: true,
            ),

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

            // const SizedBox(height: 16),
            // const Text(
            //   'Focus on',
            //   style: TextStyle(
            //     color: Color(0xFF4B5563),
            //     fontSize: 14,
            //     fontFamily: 'Inter',
            //   ),
            // ),
            // const SizedBox(height: 4),
            // _buildFocusTags(),

            // Add button
            _actionButtons(),
          ],
        );
      },
    );
  }

  Widget _actionButtons() {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        bool hasCards = vm.userFlashCards.isNotEmpty;
        return Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return Column(
              spacing: 12,
              children: [
                AppButton(
                  onTap: () => vm.generateCardsHandler(apiServiceProvider),
                  text: hasCards ? 'Generate more cards' : 'Generate cards',
                ),

                // AppButton.secondary(
                //   onTap: () {},
                //   text: 'Improve low confidence cards',
                // ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCardTypes() {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        return Column(
          children:
              vm.cardTypes
                  .map(
                    (e) => _checkableRow(
                      text: e,
                      selected: vm.selectedCardTypes.contains(e),
                      onTap: () => vm.updateSelectedCardTypes(e),
                    ),
                  )
                  .toList(),
        );
      },
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

  Widget _selectableRow({
    required String text,
    required String icon,
    bool selected = false,
  }) {
    Color color = selected ? const Color(0xFF0F766E) : const Color(0xFF374151);
    return Container(
      // height: 40,
      // margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: selected ? const Color(0xFFF0FDFA) : Colors.transparent,
      // decoration: ShapeDecoration(

      //   shape: RoundedRectangleBorder(
      //     side: const BorderSide(color: Color(0xFFE5E7EB)),
      //     borderRadius: BorderRadius.circular(6),
      //   ),
      // ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          spacing: 8,
          children: [
            SVGImagePlaceHolder(imagePath: icon, size: 16, color: color),

            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentSourceRow(AIContentSource source) {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        bool selected = source == vm.selectedAISource;
        return InkWell(
          onTap: () => vm.updateSelectedAiSource(source),
          child: Container(
            // height: 40,
            padding: const EdgeInsets.symmetric(vertical: 10),
            // decoration: ShapeDecoration(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xFFE5E7EB)),
            //     borderRadius: BorderRadius.circular(6),
            //   ),
            // ),
            child: Row(
              spacing: 8,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          selected ? const Color(0xFF0075FF) : Colors.black54,
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

                Expanded(
                  child: Text(
                    source.toString(),
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 16,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _checkableRow({
    required String text,
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: const Color(0xFFF9FAFB),
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.only(bottom: 10),
        // decoration: ShapeDecoration(
        //   color: const Color(0xFFF9FAFB),
        //   shape: RoundedRectangleBorder(
        //     side: const BorderSide(color: Color(0xFFE5E7EB)),
        //     borderRadius: BorderRadius.circular(6),
        //   ),
        // ),
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
      ),
    );
  }

  Widget _sliderField() {
    return Consumer<FlashCardCreationVm>(
      builder: (context, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number of cards',
              style: const TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 4),
            Row(
              spacing: 8,
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
                      value: vm.numberOfCards.toDouble(),
                      min: 0,
                      max: 30,
                      divisions: 30,
                      activeColor: const Color(0xFF0075FF),
                      inactiveColor: const Color(0xFFE5E5E5),
                      onChanged:
                          (value) => vm.updateNumberOfCards(value.toInt()),
                    ),
                  ),
                ),

                Text(
                  vm.numberOfCards.toString(),
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
