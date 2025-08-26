import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/create_vm.dart';

class AiGenerationInputView extends StatefulWidget {
  const AiGenerationInputView({super.key});

  @override
  State<AiGenerationInputView> createState() => _AiGenerationInputViewState();
}

class _AiGenerationInputViewState extends State<AiGenerationInputView> {
  // FlashCardsSide flashCardSide = FlashCardsSide.front;

  // void updateIsFront(FlashCardsSide value) {
  //   setState(() {
  //     flashCardSide = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (vm.currentFlashCardIndex == null)
                        ? 'Cards 1 of ${vm.userFlashCards.length}'
                        : 'Cards ${vm.currentFlashCardIndex} of ${vm.userFlashCards.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Row(
                    children: [
                      _iconButton(Icons.chevron_left),
                      const SizedBox(width: 2),
                      _iconButton(Icons.chevron_right),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _toolbar(), const SizedBox(height: 16),
              _inputDisplay(),
              const SizedBox(height: 16),

              // Row 3: per-card actions
              // _CardActionsRow(),
              // const SizedBox(height: 16),

              // Row 4: bulk actions
              // _BulkActionsCard(),
              // const SizedBox(height: 16),

              // Row 5: AI tip banner
              // _AiTipBanner(),
            ],
          ),
        );
      },
    );
  }

  Widget _inputField() {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        bool isFront = vm.currentSide == FlashCardsSide.front;
        double height = 300;
        return QuillEditor.basic(
          controller: isFront ? vm.frontController : vm.backController,
          focusNode: isFront ? vm.frontFocusNode : vm.backFocusNode,
          config: QuillEditorConfig(
            embedBuilders: FlutterQuillEmbeds.defaultEditorBuilders(),
            padding: EdgeInsets.all(20),
            minHeight: height,
            maxHeight: height,
            autoFocus: true,
            showCursor: true,
          ),
        );
      },
    );
  }

  Widget _inputDisplay() {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        return Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(8),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              // Tabs
              SizedBox(
                child: Row(
                  children:
                      FlashCardsSide.values.map((item) {
                        bool isActive = vm.currentSide == item;
                        return Expanded(
                          child: InkWell(
                            onTap: () => vm.updateSide(item),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 2,
                                    color:
                                        isActive
                                            ? Color(0xFF0D9488)
                                            : AppTheme.lightGray,
                                  ),
                                ),
                              ),
                              child: Text(
                                item.shortString(),
                                style: TextStyle(
                                  color:
                                      isActive
                                          ? Color(0xFF0D9488)
                                          : Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              _inputField(),
              if (vm.generationInfo != null)
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  child: Row(
                    spacing: 15,
                    children: [
                      Expanded(
                        child: Row(
                          spacing: 4,
                          children: [
                            Flexible(
                              child: const Text(
                                'AI Confidence:',
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            Text(
                              //  vm.,
                              vm.generationInfo!['confidence_level'] ?? '',
                              style: TextStyle(
                                color: Color(0xFF16A34A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Icon(
                              Icons.check_circle,
                              color: Color(0xFF16A34A),
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                      //TODO return
                      // const Text(
                      //   'Source: Memory Formation notes, Page 2',
                      //   style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                      // ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _toolbar() {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        return CustomCard(
          width: null,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          addBorder: true,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: QuillSimpleToolbar(
            controller:
                vm.currentSide == FlashCardsSide.front
                    ? vm.frontController
                    : vm.backController,
            config: buildCustomToolbarConfig(
              decoration: BoxDecoration(color: AppTheme.white),
              multiRowsDisplay: false,
              showAlignmentButtons: true,
              showBoldButton: true,
              showItalicButton: true,
              showUnderLineButton: true,
              showStrikeThrough: true,
              showListBullets: true,
              showListNumbers: true,
              // showQuote: true,
              showUndo: true,
              showRedo: true,
              customButtons: [
                QuillToolbarCustomButtonOptions(
                  icon: SVGImagePlaceHolder(
                    imagePath: Images.img,
                    size: 14,
                    color: AppTheme.darkSlateGray,
                  ),
                  afterButtonPressed: vm.addImage,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _iconButton extends StatelessWidget {
  final IconData icon;
  const _iconButton(this.icon);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      height: 24,
      child: Icon(icon, size: 16, color: const Color(0xFF6B7280)),
    );
  }
}

class _CardActionsRow extends StatelessWidget {
  final List<_ActionButton> actions = const [
    _ActionButton(icon: Icons.refresh, label: 'Regenerate'),
    _ActionButton(icon: Icons.edit, label: 'Improve'),
    _ActionButton(icon: Icons.image, label: 'Add Visual'),
    _ActionButton(icon: Icons.link, label: 'Link Concepts'),
    _ActionButton(icon: Icons.edit_note, label: 'Edit Manually'),
  ];

  const _CardActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          actions
              .map(
                (e) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: e,
                  ),
                ),
              )
              .toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1F2937)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
          ),
        ],
      ),
    );
  }
}

class _BulkActionsCard extends StatelessWidget {
  const _BulkActionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 166,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bulk AI Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                children: [
                  _bulkButton(
                    'Regenerate All',
                    bg: const Color(0xFFF0FDFA),
                    border: const Color(0xFF99F6E4),
                    textColor: const Color(0xFF0F766E),
                  ),
                  const SizedBox(width: 12),
                  _bulkButton(
                    'Improve Weak Cards',
                    bg: const Color(0xFFFFFBEB),
                    border: const Color(0xFFFDE68A),
                    textColor: const Color(0xFFB45309),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _bulkButton(
                    'Add Missing Topics',
                    bg: const Color(0xFFEFF6FF),
                    border: const Color(0xFFBFDBFE),
                    textColor: const Color(0xFF1D4ED8),
                  ),
                  const SizedBox(width: 12),
                  _bulkButton(
                    'Balance Difficulty',
                    bg: const Color(0xFFFAF5FF),
                    border: const Color(0xFFE9D5FF),
                    textColor: const Color(0xFF7E22CE),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bulkButton(
    String text, {
    required Color bg,
    required Color border,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(width: 1, color: border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text, style: TextStyle(color: textColor, fontSize: 14)),
      ),
    );
  }
}

class _AiTipBanner extends StatelessWidget {
  const _AiTipBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 80,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(width: 1, color: const Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: Color(0xFF1E40AF),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.43,
                      color: Color(0xFF1E40AF),
                    ),
                    children: [
                      TextSpan(
                        text: 'AI Suggestion: ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text:
                            'This concept appears in 3 other notes. Create linking cards?',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _miniButton('Yes, create links', primary: true),
                    const SizedBox(width: 8),
                    _miniButton('No thanks', primary: false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniButton(String text, {required bool primary}) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primary ? const Color(0xFF2563EB) : Colors.white,
        border: Border.all(
          color: primary ? const Color(0xFF2563EB) : const Color(0xFFD1D5DB),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: primary ? Colors.white : const Color(0xFF374151),
        ),
      ),
    );
  }
}
