import 'package:navinotes/packages.dart';

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
  });

  final String imagePath;
  final double? size;
  final bool isCardHeader;
  final BorderRadiusGeometry? borderRadius;
  @override
  Widget build(BuildContext context) {
    Radius radius = Radius.circular(12);
    BorderRadiusGeometry runBorderRadius =
        isCardHeader
            ? BorderRadius.only(topLeft: radius, topRight: radius)
            : BorderRadius.circular(999);
    return ClipRRect(
      borderRadius: borderRadius ?? runBorderRadius,
      child: Image.asset(
        height: size,
        width: isCardHeader ? double.infinity : size,
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}

class ScrollableController extends StatelessWidget {
  const ScrollableController({
    super.key,
    required this.child,
    this.scrollable = true,
    this.padding,
    this.scrollDirection = Axis.vertical,
  });

  final Widget child;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return scrollable
        ? SingleChildScrollView(
          padding: padding,
          scrollDirection: scrollDirection,
          child: child,
        )
        : Container(padding: padding, child: child);
  }
}

class ExpandableController extends StatelessWidget {
  const ExpandableController({
    super.key,
    required this.child,
    required this.expandable,
  });

  final Widget child;
  final bool expandable;

  @override
  Widget build(BuildContext context) {
    return expandable ? Expanded(child: child) : child;
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
                Apptheme.text.copyWith(
                  color: Apptheme.darkSlateGray,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
          if (required)
            TextSpan(
              text: "*",
              style: Apptheme.text.copyWith(
                color: Apptheme.strongBlue,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (optional)
            TextSpan(
              text: " (optional)",
              style: Apptheme.text.copyWith(color: Apptheme.steelMist),
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
  });

  final String data;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Apptheme.whisperGrey),
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        data,
        style: Apptheme.text.copyWith(color: textColor, fontSize: 12),
      ),
    );
  }
}

class OutlinedChild extends StatelessWidget {
  const OutlinedChild({
    super.key,
    required this.child,
    this.decoration = const BoxDecoration(),
    this.size = 36,
    // this.unbounded = false,
  });

  final Widget child;
  final BoxDecoration decoration;
  final double size;
  // final bool unbounded;

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
        // border: decoration.border ?? Border.all(color: Apptheme.lightGray),
      ),
      child: Center(child: child),
    );
  }
}

class CustomSlider extends StatelessWidget {
  const CustomSlider({super.key, required this.slider});
  final Slider slider;
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 8.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
      ),
      child: Slider(
        value: slider.value,
        onChanged: slider.onChanged,
        activeColor: Apptheme.dodgerBlue,
        padding: slider.padding ?? EdgeInsets.zero,
        inactiveColor: Apptheme.gainsboro,
      ),
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
      padding: padding,
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
  });
  final Color color;
  final double size;
  final bool addBorder;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color:
              color == Apptheme.white || addBorder
                  ? Apptheme.coolGray
                  : Apptheme.transparent,
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Apptheme.white,
      shape: RoundedRectangleBorder(),
      child: child,
    );
  }
}
