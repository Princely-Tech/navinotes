import 'package:navinotes/packages.dart';

class OverlappingAvatars extends StatelessWidget {
  final List<Widget> avatars;
  final double overlap;
  final double size;

  const OverlappingAvatars({
    super.key,
    required this.avatars,
    this.overlap = 12, // amount to overlap
    this.size = 32, // avatar size
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + (avatars.length - 1) * (size - overlap),
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < avatars.length; i++)
            Positioned(left: i * (size - overlap), child: avatars[i]),
        ],
      ),
    );
  }
}

class SVGImagePlaceHolder extends StatelessWidget {
  const SVGImagePlaceHolder({
    super.key,
    required this.imagePath,
    this.size,
    this.width,
    this.height,
    this.containerSize,
    this.color,
    this.center = false,
    this.decoration,
    this.onTap,
  });

  final String imagePath;
  final double? size;
  final bool center;
  final double? width;
  final double? height;
  final double? containerSize;
  final Decoration? decoration;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: decoration ?? BoxDecoration(shape: BoxShape.circle),
        child:
            isNotNull(containerSize) || center
                ? Center(child: _body())
                : _body(),
      ),
    );
  }

  Widget _body() {
    return SvgPicture.asset(
      height: height ?? size,
      width: width ?? size,
      imagePath,
      fit: BoxFit.cover,
      colorFilter:
          isNotNull(color) ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error);
      },
    );
  }
}

class ImagePlaceHolder extends StatelessWidget {
  const ImagePlaceHolder({
    super.key,
    required this.imagePath,
    this.size,
    this.isCardHeader = false,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.type = ImagePlaceHolderTypes.asset,
  });
  const ImagePlaceHolder.network({
    super.key,
    required this.imagePath,
    this.size,
    this.isCardHeader = false,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.type = ImagePlaceHolderTypes.network,
  });
  final ImagePlaceHolderTypes type;
  final String imagePath;
  final double? size;
  final bool isCardHeader;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    Radius radius = Radius.circular(12);
    BorderRadiusGeometry runBorderRadius =
        isCardHeader
            ? BorderRadius.only(topLeft: radius, topRight: radius)
            : BorderRadius.circular(999);
    return ClipRRect(
      borderRadius: borderRadius ?? runBorderRadius,
      child: _returnChild(),
    );
  }

  Widget _returnChild() {
    if (type.isNetwork) {
      return Image.network(
        height: size,
        width: isCardHeader ? double.infinity : size,
        imagePath,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    }
    return Image.asset(
      height: size,
      width: isCardHeader ? double.infinity : size,
      imagePath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error);
      },
    );
  }
}

class Header6 extends StatelessWidget {
  const Header6({
    super.key,
    required this.title,
    this.required = false,
    this.optional = false,
    this.style,
  });

  final String title;
  final bool required;
  final bool optional;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style:
                style ??
                AppTheme.text.copyWith(
                  color: AppTheme.darkSlateGray,
                  fontSize: 16.0,
                  fontWeight: getFontWeight(500),
                ),
          ),
          if (required)
            TextSpan(
              text: "*",
              style: AppTheme.text.copyWith(
                color: AppTheme.coralRed,
                // color: AppTheme.strongBlue,
                fontSize: 16.0,
                fontWeight: getFontWeight(500),
              ),
            ),
          if (optional)
            TextSpan(
              text: " (optional)",
              style: AppTheme.text.copyWith(color: AppTheme.steelMist),
            ),
        ],
      ),
    );
  }
}

class CustomTag extends StatelessWidget {
  const CustomTag(
    this.data, {
    super.key,
    required this.color,
    required this.textColor,
    this.borderRadius,
    this.prefix,
    this.onTap,
  });

  final String data;
  final Color color;
  final Color textColor;
  final BorderRadiusGeometry? borderRadius;
  final Widget? prefix;

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.whisperGrey),
          borderRadius: borderRadius ?? BorderRadius.circular(9999),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child:
          isNotNull(prefix)
              ? Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [prefix!, _text()],
              )
              : _text(),
    );
  }

  Widget _text() {
    return InkWell(
      onTap: onTap,
      child: Text(
        data,
        style: AppTheme.text.copyWith(color: textColor, fontSize: 12.0),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    required this.child,
    required this.loading,
  });
  final Widget child;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(color: AppTheme.black.withAlpha(20)),
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.bloodFire),
              ),
            ),
          ),
      ],
    );
  }
}

class OutlinedChild extends StatelessWidget {
  const OutlinedChild({
    super.key,
    required this.child,
    this.decoration = const BoxDecoration(),
    this.size = 36,
  });

  final Widget child;
  final BoxDecoration decoration;
  final double? size;

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry borderRadius =
        decoration.borderRadius ?? BorderRadius.circular(6);
    // double? runSize = unbounded ? null : size;
    return Container(
      width: size,
      height: size,
      decoration: decoration.copyWith(
        borderRadius: decoration.shape == BoxShape.circle ? null : borderRadius,
        // border: decoration.border,
      ),
      child: Center(child: child),
    );
  }
}

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key, required this.slider, this.trackShape});
  final Slider slider;
  final SliderTrackShape? trackShape;
  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double sliderValue;

  void updateValue(double value) {
    setState(() {
      sliderValue = value;
    });
    widget.slider.onChanged?.call(value);
  }

  @override
  void initState() {
    super.initState();
    sliderValue = widget.slider.value;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 8.0,
        trackShape: widget.trackShape,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
      ),
      child: Slider(
        value: sliderValue,
        onChanged: updateValue,
        activeColor: AppTheme.dodgerBlue,
        padding: widget.slider.padding ?? EdgeInsets.zero,
        inactiveColor: AppTheme.gainsboro,
      ),
    );
  }
}

class GradientSliderTrackShape extends SliderTrackShape {
  final LinearGradient gradient;
  final Color activeColor;

  GradientSliderTrackShape({required this.gradient, required this.activeColor});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;

    return Rect.fromLTWH(
      offset.dx,
      trackTop,
      parentBox.size.width, // full width
      trackHeight,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    const double trackRadius = 4.0;

    // Full gradient paint
    final Paint gradientPaint =
        Paint()
          ..shader = gradient.createShader(trackRect)
          ..style = PaintingStyle.fill;

    // Left overlay paint (e.g., solid blue)
    final Paint maskPaint =
        Paint()
          ..color = activeColor
          ..style = PaintingStyle.fill;

    // Draw the gradient first (entire track)
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(trackRadius)),
      gradientPaint,
    );

    // Mask the left side of the track
    final Rect maskRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(maskRect, Radius.circular(trackRadius)),
      maskPaint,
    );
  }
}

class ScrollableRow extends StatelessWidget {
  const ScrollableRow({
    super.key,
    this.children = const [],
    this.child,
    this.padding,
  });
  final List<Widget> children;
  final Widget? child;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return ScrollableController(
      mobilePadding: padding,
      scrollDirection: Axis.horizontal,
      child: child ?? Row(spacing: 10, children: children),
    );
  }
}

class ColorWidget extends StatelessWidget {
  const ColorWidget(
    this.color, {
    super.key,
    this.size = 24,
    this.addBorder = false,
    this.borderRadius,
  });
  final Color color;
  final double size;
  final bool addBorder;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: isNotNull(borderRadius) ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: borderRadius,
        border: Border.all(
          color:
              color == AppTheme.white || addBorder
                  ? AppTheme.coolGray
                  : AppTheme.transparent,
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.child, this.bgColor});
  final Widget child;
  final Color? bgColor;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor ?? AppTheme.white,
      shape: RoundedRectangleBorder(),
      // width: double.infinity,
      child: child,
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    this.borderColor = AppTheme.transparent,
    this.size = 29,
  });
  final Color borderColor;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Consumer<SessionManager>(
      builder: (_, sessionManager, _) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SVGImagePlaceHolder(imagePath: Images.avatar, size: size),
          ),
        );
      },
    );
  }
}

class MessageDisplayContainer extends StatelessWidget {
  const MessageDisplayContainer(this.message, {super.key, this.isError = true});
  final String message;
  final bool isError;
  @override
  Widget build(BuildContext context) {
    final double maxWidth = screenWidth(context) * 0.9;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isError ? AppTheme.bloodFire : AppTheme.vitalGreen,
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTheme.text.copyWith(color: AppTheme.white),
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.title});
  final String? title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: NavigationHelper.pop,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: ShapeDecoration(
              color: AppTheme.deepMoss,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Icon(Icons.arrow_back, color: AppTheme.white),
          ),
          if (isNotNull(title))
            Flexible(
              child: Text(
                title!,
                style: AppTheme.text.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AppHeaderOne extends StatelessWidget {
  const AppHeaderOne({
    super.key,
    this.widthLimit,
    this.isBackButton = false,
    this.title = AppStrings.appName,
  });
  final double? widthLimit;
  final String title;
  final bool isBackButton;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.lightGray, width: 1)),
      ),

      child: ResponsivePadding(
        mobile: EdgeInsets.symmetric(
          horizontal: isBackButton ? 10 : defaultHorizontalPadding,
          vertical: 10,
        ),
        laptop: EdgeInsets.symmetric(
          horizontal: defaultHorizontalPadding,
          vertical: 10,
        ),
        child:
            isNotNull(widthLimit)
                ? Center(
                  child: WidthLimiter(mobile: widthLimit!, child: _body()),
                )
                : _body(),
      ),
    );
  }

  Widget _body() {
    if (isBackButton) {
      return Row(children: [Expanded(child: CustomBackButton(title: title))]);
    }
    return Row(
      spacing: 10,
      children: [
        SVGImagePlaceHolder(imagePath: Images.logo, size: 30),
        Expanded(
          child: Text(
            title,
            style: AppTheme.text.copyWith(
              fontSize: 20.0,
              fontWeight: getFontWeight(600),
              color: AppTheme.vividRose,
            ),
          ),
        ),
      ],
    );
  }
}

class AuthFrame extends StatelessWidget {
  const AuthFrame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth(context),
      height: screenHeight(context),
      child: ScrollableController(
        mobilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        laptopPadding: const EdgeInsets.all(20),
        child: Center(
          child: WidthLimiter(
            mobile: 500,
            child: SingleChildScrollView(child: child),
          ),
        ),
      ),
    );
  }
}

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        SVGImagePlaceHolder(imagePath: Images.logo, size: 80),
        Text(
          'NaviNotes',
          textAlign: TextAlign.center,
          style: AppTheme.text.copyWith(
            color: AppTheme.vividRose,
            fontSize: 30.0,
            fontFamily: AppTheme.fontPoppins,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Your supportive study companion',
          textAlign: TextAlign.center,
          style: AppTheme.text.copyWith(
            color: AppTheme.stormGray,
            fontSize: 16.0,
            fontFamily: AppTheme.fontPoppins,
          ),
        ),
      ],
    );
  }
}

class CustomCheckBoxItem extends StatefulWidget {
  const CustomCheckBoxItem({
    super.key,
    this.title,
    this.child,
    this.shape,
    this.onChanged,
  });
  final String? title;
  final Widget? child;
  final OutlinedBorder? shape;
  final void Function(bool)? onChanged;
  @override
  State<CustomCheckBoxItem> createState() => _CustomCheckBoxItemState();
}

class _CustomCheckBoxItemState extends State<CustomCheckBoxItem> {
  bool? _value = false;

  updateValue(bool value) {
    setState(() {
      _value = value;
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => updateValue(!_value!),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: _value,
            onChanged: (value) => updateValue(value!),
            activeColor: AppTheme.royalBlue,
            side: BorderSide(color: AppTheme.black, width: 1),
            shape: widget.shape,
          ),
          if (isNotNull(widget.child)) Flexible(child: widget.child!),
          if (isNotNull(widget.title))
            Flexible(
              child: Text(
                widget.title!,
                style: AppTheme.text.copyWith(color: AppTheme.darkSlateGray),
              ),
            ),
        ],
      ),
    );
  }
}

class StarRows extends StatelessWidget {
  const StarRows({
    super.key,
    this.fullStars = 0,
    this.emptyStars = 0,
    this.halfStars = 0,
  });
  final int fullStars;
  final int emptyStars;
  final int halfStars;
  @override
  Widget build(BuildContext context) {
    double size = 12;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < fullStars; i++)
          SVGImagePlaceHolder(
            imagePath: Images.star2,
            color: AppTheme.orangeYellow,
            size: size,
          ),
        for (int i = 0; i < emptyStars; i++)
          SVGImagePlaceHolder(
            imagePath: Images.star,
            color: AppTheme.orangeYellow,
            size: size,
          ),
        for (int i = 0; i < halfStars; i++)
          SVGImagePlaceHolder(
            imagePath: Images.starHalf,
            color: AppTheme.orangeYellow,
            size: size,
          ),
      ],
    );
  }
}

class CustomPaination extends StatelessWidget {
  const CustomPaination({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        _paignationItem(
          child: Icon(Icons.keyboard_arrow_left, color: AppTheme.darkSlateGray),
        ),
        ...List.generate(
          2,
          (index) => _paignationItem(
            text: (index + 1).toString(),
            isActive: index == 0,
          ),
        ),
        _paignationItem(
          child: Icon(
            Icons.keyboard_arrow_right,
            color: AppTheme.darkSlateGray,
          ),
        ),
      ],
    );
  }

  Widget _paignationItem({Widget? child, String? text, bool isActive = false}) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: ShapeDecoration(
        color: isActive ? AppTheme.tealStone : AppTheme.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppTheme.coolGray),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
      child: Center(
        child:
            child ??
            Text(
              text ?? '',
              style: AppTheme.text.copyWith(
                color: isActive ? AppTheme.white : AppTheme.darkSlateGray,
                fontSize: 16.0,
              ),
            ),
      ),
    );
  }
}

class StarRowWithText extends StatelessWidget {
  const StarRowWithText({
    super.key,
    required this.text,
    required this.starRows,
  });
  final String text;
  final Widget starRows;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Flexible(child: starRows),
        Text(
          text,
          style: AppTheme.text.copyWith(color: AppTheme.darkSlateGray),
        ),
      ],
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    this.leading,
    this.isActive = false,
    this.trailing,
    required this.title,
    required this.color,
    required this.activeColor,
  });
  final Widget? leading;
  final bool isActive;
  final Widget? trailing;
  final String title;
  final Color color;
  final Color activeColor;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: leading,
        selected: isActive,
        selectedTileColor: AppTheme.iceBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        trailing: trailing,
        contentPadding: const EdgeInsets.only(left: 15, right: 10),
        title: Text(
          title,
          style: AppTheme.text.copyWith(
            color: color,
            fontSize: 16.0,
            fontWeight: isActive ? getFontWeight(500) : null,
            height: 1.0,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
