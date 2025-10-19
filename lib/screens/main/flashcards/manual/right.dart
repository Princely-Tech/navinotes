import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/create_vm.dart';

class FlashCardsManualCreationRight extends StatelessWidget {
  const FlashCardsManualCreationRight({super.key, this.isAi = false});
  final bool isAi;
  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, __) {
        final flashcards = vm.userFlashCards;
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            border: Border(right: BorderSide(color: AppTheme.lightGray)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                // Header section (fixed)
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Text(
                          'Cards in Deck',
                          style: TextStyle(
                            color: const Color(0xFF374151),
                            fontSize: 16.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                      ),
                      Text(
                        '${flashcards.length} cards',
                        style: TextStyle(
                          color: const Color(0xFF6B7280),
                          fontSize: 12.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Reorderable list (scrollable)
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: flashcards.length,
                    onReorder: (oldIndex, newIndex) {
                      vm.reorderCards(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        key: ValueKey(flashcards[index].id),
                        padding: const EdgeInsets.only(bottom: 15),
                        child: _cardItem(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cardItem(int index) {
    return Consumer<FlashCardCreationVm>(
      builder: (_, vm, _) {
        final flashcards = vm.userFlashCards;
        final card = flashcards[index];
        final isActive = card.id == vm.currentFlashCard?.id;

        // QuillController backController = QuillController(
        //   document: safeDocFromJson(card.back),
        //   selection: const TextSelection.collapsed(offset: 0),
        // );
        // final frontText = frontController.document.toPlainText().trim();
        final frontText = plainTextFromQuillJson(card.front);
        final backText = plainTextFromQuillJson(card.back);
        return GestureDetector(
          onTap: () => vm.selectFlashCard(card, index + 1),
          child: CustomCard(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.iceBlue : AppTheme.transparent,
              border: Border.all(
                color: isActive ? AppTheme.softSkyBlue : AppTheme.lightGray,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Text(
                        'Card ${flashcards.indexOf(card) + 1} ${isActive ? '(Current)' : ''}',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color:
                              isActive
                                  ? AppTheme.vividRose
                                  : AppTheme.steelMist,
                          fontSize: 12.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        // Drag handle
                        Icon(
                          Icons.drag_handle,
                          color: AppTheme.blueGray,
                          size: 16,
                        ),
                        LoadingIndicator(
                          loading: vm.deletingCardId == card.id,
                          child: InkWell(
                            onTap: () => vm.handleDeleteFlashCard(card),
                            child: SVGImagePlaceHolder(
                              imagePath: Images.trash2,
                              color: AppTheme.blueGray,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // ValueListenableBuilder<FlashCard?>(
                //   valueListenable: vm.currentFlashCardNotifier,
                //   builder: (context, value, child) {
                //     return Transform.scale(
                //       scale: 0.5, // 60% of original size
                //       alignment: Alignment.topLeft,
                //       child: QuillEditor.basic(
                //         controller: frontController,
                //         config: QuillEditorConfig(
                //           embedBuilders:
                //               FlutterQuillEmbeds.defaultEditorBuilders(),
                //           padding: EdgeInsets.all(10),
                //           minHeight: 100,
                //           maxHeight: 100,
                //         ),
                //       ),
                //     );
                //   },
                // ),
                if (frontText.isNotEmpty)
                  Text(
                    frontText,
                    // jsonToPlainText(card.front),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: const Color(0xFF1F2937),
                      fontSize: 14.0,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (backText.isNotEmpty)
                  Text(
                    backText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _cardItemAction({required String icon}) {
  //   return SVGImagePlaceHolder(
  //     imagePath: icon,
  //     color: AppTheme.blueGray,
  //     size: 12,
  //   );
  // }
}
