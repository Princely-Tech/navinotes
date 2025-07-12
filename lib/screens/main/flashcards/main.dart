import 'package:navinotes/packages.dart';

class FlashCardsMain extends StatelessWidget {
  const FlashCardsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardsVm>(
      builder: (_, vm, _) {
        return ScrollableController(
          mobilePadding: const EdgeInsets.only(top: 10),
          tabletPadding: const EdgeInsets.only(top: 20),
          child: ResponsiveHorizontalPadding(
            child: Column(
              spacing: 20,
              children: [
                _options(),
                _sideIndicator(),
                _firstInputField(),
                _secondInputField(),
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
                        onTap: () {},
                      ),
                      _cardOption(
                        text: 'Clear Card',
                        icon: Images.eraser,
                        onTap: () {},
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
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _secondInputField() {
    return Consumer<FlashCardsVm>(
      builder: (_, vm, _) {
        FlashCardsSide side =
            vm.currentSide == FlashCardsSide.front
                ? FlashCardsSide.back
                : FlashCardsSide.front;
        return ResponsiveHorizontalPadding(
          child: Stack(
            children: [
              CustomInputField(
                maxLines: 6,
                fillColor: AppTheme.lightAsh,
                hintText: 'Enter answer or definition...',
                hintStyle: TextStyle(
                  color: const Color(0xFFADAEBC),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
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
        );
      },
    );
  }

  Widget _firstInputField() {
    return Consumer<FlashCardsVm>(
      builder: (_, vm, _) {
        return CustomCard(
          addShadow: true,
          // height: 250,
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomInputField(
                maxLines: 8,
                hintText: 'Enter question or term...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.transparent),
                ),
                hintStyle: TextStyle(
                  color: const Color(0xFFADAEBC),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.56,
                ),
              ),
              AppButton.text(
                onTap: vm.toggleSide,
                text: 'Flip',
                prefix: SVGImagePlaceHolder(
                  imagePath: Images.refresh2,
                  size: 14,
                  color: AppTheme.lightBlue,
                ),
                style: TextStyle(
                  color: AppTheme.lightBlue,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sideIndicator() {
    final radius = BorderRadius.circular(999);
    return Consumer<FlashCardsVm>(
      builder: (_, vm, _) {
        return CustomCard(
          width: null,
          addBorder: true,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(borderRadius: radius),
          child: ScrollableController(
            scrollDirection: Axis.horizontal,
            mobilePadding: EdgeInsets.all(5),
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
                      onTap: vm.toggleSide,
                      mainAxisSize: MainAxisSize.min,
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      minHeight: 25,
                      style: TextStyle(
                        color:
                            isActive ? AppTheme.white : AppTheme.darkSlateGray,
                        fontSize: 14,
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

  Widget _options() {
    return CustomCard(
      width: null,
      padding: EdgeInsets.zero,
      addBorder: true,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: ScrollableController(
        mobilePadding: EdgeInsets.all(5),
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            children: [
              _optionItem(icon: Images.bold),
              _optionItem(icon: Images.italic),
              _optionItem(icon: Images.underline),
              _divider(),
              _optionItem(icon: Images.menu),
              _optionItem(icon: Images.menu4),
              _divider(),
              _optionItem(icon: Images.img),
              _optionItem(icon: Images.hook),
              _optionItem(icon: Images.code),
              _divider(),
              _selectField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectField() {
    return Consumer<FlashCardsVm>(
      builder: (_, vm, _) {
        final controller = vm.textTypeController;
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ValueListenableBuilder(
            valueListenable: vm.textTypeController,
            builder: (_, value, _) {
              final style = TextStyle(
                color: const Color(0xFF1F2937),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              );
              final textWidth = calculateTextWidth(value.text, style) + 60;
              return WidthLimiter(
                mobile: textWidth,
                child: CustomInputField(
                  controller: controller,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: AppTheme.lightGray),
                  ),
                  selectItems: flashCardsTextTypes,
                  style: style,
                  constraints: BoxConstraints(maxHeight: 30),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _divider() {
    return Text(
      '|',
      style: TextStyle(
        color: const Color(0xFFD1D5DB),
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _optionItem({required String icon}) {
    return IconButton(
      onPressed: () {},
      icon: SVGImagePlaceHolder(
        imagePath: icon,
        size: 14,
        color: AppTheme.stormGray,
      ),
    );
  }
}
