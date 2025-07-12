import 'package:navinotes/packages.dart';import 'vm.dart';

class FlashcardsRight extends StatelessWidget {
  const FlashcardsRight({super.key});

  @override
  Widget build(BuildContext context) {
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
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          '12 cards',
                          style: TextStyle(
                            color: const Color(0xFF6B7280),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    _cardItem(
                      answer: 'Neurons process and transmit',
                      question: 'What is the function of neurons in the brain?',
                      title: 'Card 1',
                      isActive: true,
                    ),
                    _cardItem(
                      answer: 'Chemical messengers that transmit signals',
                      question: 'Define neurotransmitters and their role',
                      title: 'Card 2',
                    ),
                    _cardItem(
                      answer: 'The ability of neural networks to change',
                      question: 'Explain the concept of neuroplasticity',
                      title: 'Card 3',
                    ),
                    _cardItem(
                      answer: 'Cerebrum, cerebellum, brain stem',
                      question: 'What are the major parts of the brain?',
                      title: 'Card 4',
                    ),
                    _cardItem(
                      answer: 'Insulates nerve fibers and increases...',
                      question: 'Describe the function of myelin sheath',
                      title: 'Card 5',
                    ),
                  ],
                ),
              ),
            ),
            AppButton.text(onTap: () {}, text: 'Show all cards'),
          ],
        ),
      ),
    );
  }

  Widget _cardItem({
    required String title,
    required String question,
    required String answer,
    bool isActive = false,
  }) {
    return CustomCard(
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
                  '$title ${isActive ? '(Current)' : ''}',
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: isActive ? AppTheme.vividRose : AppTheme.steelMist,
                    fontSize: 12,
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
            question,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: const Color(0xFF1F2937),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            answer,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
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
