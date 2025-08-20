import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/vm.dart';

class FlashCardsRight extends StatelessWidget {
  const FlashCardsRight({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardsVm>(
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      spacing: 15,
                      children: [
                        Row(
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
                        for (int i = 0; i < flashcards.length; i++)
                          _cardItem(i),
                      ],
                    ),
                  ),
                ),
                AppButton.text(onTap: () {}, text: 'Show all cards'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cardItem(int index) {
    return Consumer<FlashCardsVm>(
      builder: (_, vm, _) {
        final flashcards = vm.userFlashCards;
        final card = flashcards[index];
        final isActive = card.id == vm.currentFlashCard?.id;
        return GestureDetector(
          onTap: () => vm.selectFlashCard(card),
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
                        _cardItemAction(icon: Images.pencil),
                        _cardItemAction(icon: Images.trash2),
                      ],
                    ),
                  ],
                ),
                Text(
                  jsonToPlainText(card.front),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 14.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  jsonToPlainText(card.back),
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

  Widget _cardItemAction({required String icon}) {
    return SVGImagePlaceHolder(
      imagePath: icon,
      color: AppTheme.blueGray,
      size: 12,
    );
  }
}
