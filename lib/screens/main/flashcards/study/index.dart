import 'package:navinotes/packages.dart';
import 'footer.dart';
import 'aside.dart';
import 'header.dart';
import 'vm.dart';

class FlashCardStudyScreen extends StatelessWidget {
  FlashCardStudyScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = FlashCardStudyVm(scaffoldKey: _scaffoldKey);
        vm.initialize();
        return vm;
      },
      child: ScaffoldFrame(
        backgroundColor: const Color(0xFFF9FAFB),
        scaffoldKey: _scaffoldKey,
        endDrawer: CustomDrawer(child: const FlashCardStudyAside()),
        body: Column(
          children: [
            const FlashCardStudyHeader(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _main()),
                  VisibleController(
                    mobile: false,
                    desktop: true,
                    child: WidthLimiter(
                      mobile: 288,
                      child: const FlashCardStudyAside(),
                    ),
                  ),
                ],
              ),
            ),
            const FlashcardStudyFooter(),
          ],
        ),
      ),
    );
  }

  Widget _main() {
    return Consumer<FlashCardStudyVm>(
      builder: (_, vm, _) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Align(
            alignment: Alignment.center,
            child: Builder(
              builder: (context) {
                double width = screenWidth(context);
                return WidthLimiter(
                  mobile: width * 0.9,
                  tablet: width * 0.8,
                  desktop: width * 0.7,
                  largeDesktop: width * 0.6,
                  child: Column(
                    spacing: 30,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _progressIndicator(),
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
                            _actions(),
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
      },
    );
  }

  Widget _inputCard({required bool isFront}) {
    return Consumer<FlashCardStudyVm>(
      builder: (_, vm, _) {
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
                    controller:
                        isFront ? vm.frontController : vm.backController,
                    config: QuillEditorConfig(minHeight: 300),
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
      },
    );
  }

  Widget _progressIndicator() {
    return LayoutBuilder(
      builder: (_, constraints) {
        double width = constraints.maxWidth;
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
                    value: 4 / 12,
                    backgroundColor: const Color(0xFFDBEAFE),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF00555A)),
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 4,
                  ),
                ),
                const Text(
                  'Card 4 of 12',
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
    return Consumer<FlashCardStudyVm>(
      builder: (_, vm, _) {
        return Wrap(
          spacing: 12,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: [
            AppButton(
              onTap: () {},
              text: 'Again',
              mainAxisSize: MainAxisSize.min,
              color: const Color(0xFFFEE2E2),
              textColor: const Color(0xFFDC2626),
              minHeight: 40,
              padding: EdgeInsets.symmetric(horizontal: 24),
              prefix: SVGImagePlaceHolder(
                imagePath: Images.refresh,
                size: 16,
                color: const Color(0xFFDC2626),
              ),
            ),
            AppButton(
              onTap: () {},
              text: 'Hard',
              mainAxisSize: MainAxisSize.min,
              color: const Color(0xFFFFEDD5),
              textColor: const Color(0xFFEA580C),
              minHeight: 40,
              padding: EdgeInsets.symmetric(horizontal: 24),
              prefix: Icon(
                Icons.error,
                color: const Color(0xFFEA580C),
                size: 18,
              ),
            ),
            AppButton(
              onTap: () {},
              text: 'Good',
              mainAxisSize: MainAxisSize.min,
              color: const Color(0xFFD1FAE5),
              textColor: const Color(0xFF059669),
              minHeight: 40,
              padding: EdgeInsets.symmetric(horizontal: 24),
              prefix: Icon(
                Icons.check,
                color: const Color(0xFF059669),
                size: 18,
              ),
            ),
            AppButton(
              onTap: () {},
              text: 'Easy',
              mainAxisSize: MainAxisSize.min,
              color: const Color(0xFFD1FAE5),
              textColor: const Color(0xFF059669),
              minHeight: 40,
              padding: EdgeInsets.symmetric(horizontal: 24),
              prefix: SVGImagePlaceHolder(
                imagePath: Images.flash,
                size: 16,
                color: const Color(0xFF059669),
              ),
            ),
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
              onTap: () {},
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
      },
    );
  }
}
