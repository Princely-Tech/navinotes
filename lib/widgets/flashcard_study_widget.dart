import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/study/vm.dart';

/// Reusable flashcard study widget that can be used in different contexts
/// Takes a FlashCardStudyVm as parameter for flexibility
class FlashcardStudyWidget extends StatelessWidget {
  final FlashCardStudyVm vm;
  final bool showProgressIndicator;
  final bool showActions;
  final double? maxWidth;

  const FlashcardStudyWidget({
    super.key,
    required this.vm,
    this.showProgressIndicator = true,
    this.showActions = true,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Align(
        alignment: Alignment.center,
        child: Builder(
          builder: (context) {
            double width = maxWidth ?? screenWidth(context);
            return WidthLimiter(
              mobile: width * 0.9,
              tablet: width * 0.8,
              desktop: width * 0.7,
              largeDesktop: width * 0.6,
              child: Column(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showProgressIndicator) _progressIndicator(),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 48,
                      children: [
                        Flexible(
                          child: FlipCard(
                            controller: vm.flipCardController,
                            rotateSide: RotateSide.right,
                            onTapFlipping: true,
                            axis: FlipAxis.vertical,
                            frontWidget: _inputCard(isFront: true),
                            backWidget: _inputCard(isFront: false),
                          ),
                        ),
                        if (showActions) _actions(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _inputCard({required bool isFront}) {
    return AbsorbPointer(
      child: CustomCard(
        addShadow: true,
        addBorder: true,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 15,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 4,
              children: [
                const SVGImagePlaceHolder(
                  imagePath: Images.refresh2,
                  size: 14,
                  color: Color(0xFF60A5FA),
                ),
                Flexible(
                  child: Text(
                    'Tap to flip',
                    style: TextStyle(
                      color: const Color(0xFF60A5FA),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: QuillEditor.basic(
                controller: isFront ? vm.frontController : vm.backController,
                config: QuillEditorConfig(
                  minHeight: 300,
                  maxHeight: 400,
                  embedBuilders: FlutterQuillEmbeds.defaultEditorBuilders(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                const SVGImagePlaceHolder(
                  imagePath: Images.refresh2,
                  size: 14,
                  color: Color(0xFF00555A),
                ),
                Flexible(
                  child: Text(
                    'Tap card to see ${isFront ? 'answer' : 'question'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF00555A),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressIndicator() {
    return LayoutBuilder(
      builder: (_, constraints) {
        double width = constraints.maxWidth;
        int reviewedCount = vm.reviewedCards.length;
        int cardCount = vm.flashCards.length;
        double value = cardCount > 0 ? reviewedCount / cardCount : 0.0;

        return Align(
          alignment: Alignment.center,
          child: WidthLimiter(
            mobile: width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                Expanded(
                  flex: 3,
                  child: LinearProgressIndicator(
                    value: value,
                    backgroundColor: const Color(0xFFDBEAFE),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF00555A)),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 4,
                  ),
                ),
                Text(
                  'Card $reviewedCount of $cardCount',
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _actions() {
    return Wrap(
      spacing: 12,
      runSpacing: 15,
      alignment: WrapAlignment.center,
      children: [
        ...FlashcardDifficulty.values.map((difficulty) {
          Color textColor = difficulty.textColor;
          IconData? icon;
          String? img;
          switch (difficulty) {
            case FlashcardDifficulty.again:
              img = Images.refresh;
              break;
            case FlashcardDifficulty.easy:
              img = Images.flash;
              break;
            case FlashcardDifficulty.medium:
              icon = Icons.check;
            case FlashcardDifficulty.hard:
              icon = Icons.error;
              break;
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [
              AppButton(
                onTap: () => vm.updateCurrentCardDifficulty(difficulty),
                text: difficulty.toString(),
                mainAxisSize: MainAxisSize.min,
                color: difficulty.color,
                textColor: textColor,
                minHeight: 40,
                padding: EdgeInsets.symmetric(horizontal: 24),
                prefix:
                    img != null
                        ? SVGImagePlaceHolder(
                          imagePath: img,
                          size: 16,
                          color: textColor,
                        )
                        : Icon(icon, color: textColor, size: 18),
              ),
              if (vm.currentCard?.difficulty == difficulty)
                Positioned(
                  right: 0,
                  top: -5,
                  child: Icon(Icons.check_circle, color: textColor, size: 18),
                ),
            ],
          );
        }),
        AppButton(
          onTap: vm.flipCard,
          text: 'Flip Card',
          mainAxisSize: MainAxisSize.min,
          color: const Color(0xFFEFF6FF),
          textColor: const Color(0xFF00555A),
          minHeight: 40,
          padding: EdgeInsets.symmetric(horizontal: 24),
          prefix: SVGImagePlaceHolder(
            imagePath: Images.refresh2,
            size: 16,
            color: const Color(0xFF00555A),
          ),
        ),
        AppButton(
          onTap: vm.nextCardIndex,
          text: 'Skip',
          mainAxisSize: MainAxisSize.min,
          color: const Color(0xFFF3F4F6),
          textColor: const Color(0xFF4B5563),
          minHeight: 40,
          padding: EdgeInsets.symmetric(horizontal: 24),
          prefix: SVGImagePlaceHolder(
            imagePath: Images.skip,
            size: 16,
            color: const Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }
}
