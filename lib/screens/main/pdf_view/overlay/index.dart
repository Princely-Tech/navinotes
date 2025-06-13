import 'package:navinotes/packages.dart';

class PdfViewOverlay extends StatelessWidget {
  const PdfViewOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PdfViewOverlayViewModel(),
      child: PdfOverlayBody(),
    );
  }
}

class PdfOverlayBody extends StatefulWidget {
  const PdfOverlayBody({super.key});

  @override
  State<PdfOverlayBody> createState() => _PdfOverlayBodyState();
}

class _PdfOverlayBodyState extends State<PdfOverlayBody> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PdfViewOverlayViewModel>().initialize();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfViewOverlayViewModel>(
      builder: (_, vm, _) {
        return Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (vm.showOverlay)
                Flexible(
                  child: WidthLimiter(
                    mobile: 720,
                    child: ResponsivePadding(
                      mobile: EdgeInsets.all(10),
                      tablet: EdgeInsets.all(20),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Apptheme.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: Apptheme.pastelBlue,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Apptheme.black.withAlpha(63),
                              blurRadius: 50,
                              offset: Offset(0, 25),
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(15),
                        child: ScrollableController(
                          child: Column(
                            spacing: 30,
                            children: [
                              _header(vm),
                              _guideCard(
                                title: 'Add to Mind Map',
                                body:
                                    'Connect key concepts to your mind map for visual learning and better understanding',
                                icon: _outlinedChild(
                                  img: Images.share,
                                  imgColor: Apptheme.strongBlue,
                                  bgColor: Apptheme.paleBlue,
                                ),
                              ),
                              _guideCard(
                                title: 'Create Flashcard',
                                body:
                                    'Transform highlights into flashcards for effective memorization and review',
                                icon: _outlinedChild(
                                  img: Images.card,
                                  imgColor: Apptheme.jungleGreen,
                                  bgColor: Apptheme.lightMintGreen,
                                ),
                              ),
                              _guideCard(
                                title: 'Create Note',
                                body:
                                    'Make detailed notes and link them to your study materials',
                                icon: _outlinedChild(
                                  img: Images.copy2,
                                  imgColor: Apptheme.electricPurple,
                                  bgColor: Apptheme.purple,
                                ),
                              ),
                              _footer(vm),
                            ],
                          ),
                        ),
                      ).animate().fadeIn().scale(duration: 1.seconds),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _footer(PdfViewOverlayViewModel vm) {
    return Column(
      spacing: 15,
      children: [
        Divider(color: Apptheme.lightAsh, height: 1),
        LayoutBuilder(
          builder: (context, constraints) {
            return ScrollableRow(
              child: Container(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  spacing: 30,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton.text(
                      color: Apptheme.steelMist,
                      mainAxisSize: MainAxisSize.min,
                      onTap: vm.toggleDontShowAgain,
                      text: 'Don\'t show this again',
                      prefix: Icon(
                        vm.dontShowAgain
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color:
                            vm.dontShowAgain
                                ? Apptheme.strongBlue
                                : Apptheme.blueGray,
                        size: 20,
                      ),
                    ),
                    AppButton(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      mainAxisSize: MainAxisSize.min,
                      onTap: vm.addHandler,
                      text: 'Add',
                      minHeight: 30,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _outlinedChild({
    required String img,
    required Color imgColor,
    required Color bgColor,
  }) {
    return OutlinedChild(
      size: 40,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: SVGImagePlaceHolder(imagePath: img, color: imgColor, size: 18),
    );
  }

  Widget _guideCard({
    required String title,
    required String body,
    required Widget icon,
  }) {
    return Row(
      spacing: 10,
      children: [
        icon,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                'Add to Mind Map',
                style: TextStyle(
                  color: const Color(0xFF111827),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: getFontWeight(500),
                ),
              ),
              Text(
                'Connect key concepts to your mind map for visual learning and better understanding',
                style: TextStyle(
                  color: const Color(0xFF4B5563),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: getFontWeight(400),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header(PdfViewOverlayViewModel vm) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              Icon(Icons.lightbulb, color: Apptheme.orangeYellow, size: 22),
              Flexible(
                child: Text(
                  'Quick Start Guide',
                  style: TextStyle(
                    color: const Color(0xFF1D4ED8),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: vm.closeOverlay,
          child: Icon(Icons.close, color: Apptheme.blueGray, size: 20),
        ),
      ],
    );
  }
}
