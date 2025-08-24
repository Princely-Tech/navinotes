import 'package:navinotes/packages.dart';
import 'vm.dart';

class FlashCardsManualCreationMain extends StatelessWidget {
  const FlashCardsManualCreationMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardsManualCreationVm>(
      builder: (_, vm, _) {
        List<Widget> inputFields = [
          _inputfield(FlashCardsSide.front),
          _inputfield(FlashCardsSide.back),
        ];
        if (vm.currentSide == FlashCardsSide.back) {
          inputFields = inputFields.reversed.toList();
        }
        return ScrollableController(
          mobilePadding: const EdgeInsets.only(top: 10),
          tabletPadding: const EdgeInsets.only(top: 20),
          child: ResponsiveHorizontalPadding(
            child: Column(
              spacing: 20,
              children: [
                // _options(),
                _toolbar(),

                _sideIndicator(),
                ...inputFields,
                ScrollableController(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 15,
                    children: [
                      _cardOption(
                        text: 'Flip Card',
                        icon: Images.refresh2,
                        onTap: vm.toggleSide,
                      ),
                      _cardOption(
                        text: 'Add Image',
                        icon: Images.img,
                        onTap: vm.addImage,
                      ),
                      _cardOption(
                        text: 'Clear Card',
                        icon: Images.eraser,
                        onTap: vm.clearCard,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _toolbar() {
    return Consumer<FlashCardsManualCreationVm>(
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

  Widget _cardOption({
    required String text,
    required String icon,
    required VoidCallback onTap,
  }) {
    return AppButton(
      onTap: onTap,
      mainAxisSize: MainAxisSize.min,
      text: text,
      minHeight: 25,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: AppTheme.white,
      borderColor: AppTheme.lightGray,
      prefix: SVGImagePlaceHolder(
        imagePath: icon,
        size: 14,
        color: AppTheme.darkSlateGray,
      ),
      style: TextStyle(
        color: const Color(0xFF374151),
        fontSize: 14.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _padInactive({required Widget child, required bool isActive}) {
    return Consumer<LayoutProviderVm>(
      builder: (_, vm, _) {
        double padding = getDeviceResponsiveValue(
          deviceType: vm.deviceType,
          mobile: mobileHorPadding,
          laptop: laptopHorPadding,
          desktop: desktopHorPadding,
        );
        if (isActive) {
          padding = 0;
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: child,
        );
      },
    );
  }

  Widget _inputfield(FlashCardsSide side) {
    return Consumer<FlashCardsManualCreationVm>(
      builder: (_, vm, _) {
        bool isActive = vm.currentSide == side;
        bool isFront = side == FlashCardsSide.front;
        Color color = isFront ? AppTheme.white : AppTheme.lightAsh;
        return _padInactive(
          isActive: isActive,
          child: CustomCard(
            addShadow: isActive,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(color: color),
            child: Stack(
              children: [
                Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    QuillEditor.basic(
                      controller:
                          isFront ? vm.frontController : vm.backController,
                      focusNode: isFront ? vm.frontFocusNode : vm.backFocusNode,
                      config: QuillEditorConfig(
                        embedBuilders:
                            FlutterQuillEmbeds.defaultEditorBuilders(),
                        padding: EdgeInsets.all(20),
                        minHeight: isActive ? 200 : 146,
                        // scrollable: false,
                        maxHeight: 300,
                        placeholder:
                            isFront
                                ? 'Enter question or term...'
                                : 'Enter answer or definition...',
                        customStyles: DefaultStyles(
                          placeHolder: DefaultTextBlockStyle(
                            TextStyle(
                              color: const Color(0xFFADAEBC),
                              fontSize: isActive ? 18.0 : 14.0,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                            HorizontalSpacing.zero,
                            VerticalSpacing.zero,
                            VerticalSpacing.zero,
                            BoxDecoration(),
                          ),
                        ),
                        autoFocus: isActive,
                        showCursor: true,
                      ),
                    ),

                    if (isActive)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: AppButton.text(
                          onTap: vm.toggleSide,
                          text: 'Flip',
                          prefix: SVGImagePlaceHolder(
                            imagePath: Images.refresh2,
                            size: 14,
                            color: AppTheme.lightBlue,
                          ),
                          style: TextStyle(
                            color: AppTheme.lightBlue,
                            fontSize: 12.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                  ],
                ),
                if (!isActive)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CustomTag(
                      side.toString(),
                      color: AppTheme.lightGray,
                      textColor: AppTheme.stormGray,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sideIndicator() {
    final radius = BorderRadius.circular(999);
    return Consumer<FlashCardsManualCreationVm>(
      builder: (_, vm, _) {
        return CustomCard(
          width: null,
          addBorder: true,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(borderRadius: radius),
          child: ScrollableController(
            scrollDirection: Axis.horizontal,
            mobilePadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              // spacing: 5,
              children:
                  FlashCardsSide.values.map((side) {
                    bool isActive = side == vm.currentSide;
                    return AppButton(
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: radius,
                      ),
                      color:
                          isActive ? AppTheme.vividRose : AppTheme.transparent,
                      text: side.toString(),
                      onTap: () => vm.updateSide(side),
                      mainAxisSize: MainAxisSize.min,
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      minHeight: 25,
                      style: TextStyle(
                        color:
                            isActive ? AppTheme.white : AppTheme.darkSlateGray,
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
