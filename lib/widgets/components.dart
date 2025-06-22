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
                Apptheme.text.copyWith(
                  color: Apptheme.darkSlateGray,
                  fontSize: 16.0,
                  fontWeight: getFontWeight(500),
                ),
          ),
          if (required)
            TextSpan(
              text: "*",
              style: Apptheme.text.copyWith(
                color: Apptheme.strongBlue,
                fontSize: 16.0,
                fontWeight: getFontWeight(500),
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
        style: Apptheme.text.copyWith(color: textColor, fontSize: 12.0),
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
              decoration: BoxDecoration(color: Apptheme.black.withAlpha(20)),
              child: Center(
                child: CircularProgressIndicator(color: Apptheme.bloodFire),
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
        // border: decoration.border ?? Border.all(color: Apptheme.lightGray),
      ),
      child: Center(child: child),
    );
  }
}

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key, required this.slider});
  final Slider slider;

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
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
      ),
      child: Slider(
        value: sliderValue,
        onChanged: updateValue,
        activeColor: Apptheme.dodgerBlue,
        padding: widget.slider.padding ?? EdgeInsets.zero,
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
  const CustomDrawer({super.key, required this.child, this.bgColor});
  final Widget child;
  final Color? bgColor;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor ?? Apptheme.white,
      shape: RoundedRectangleBorder(),
      child: child,
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key, this.borderColor = Apptheme.transparent});
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
      ),
      child: ImagePlaceHolder.network(
        imagePath:
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80",
        size: 29,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class MessageDisplayContainer extends StatelessWidget {
  const MessageDisplayContainer(this.message, {super.key, this.isError = true});
  final String message;
  final bool isError;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isError ? Apptheme.bloodFire : Apptheme.vitalGreen,
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Apptheme.text.copyWith(color: Apptheme.white),
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
              color: Apptheme.deepMoss,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Icon(Icons.arrow_back, color: Apptheme.white),
          ),
          if (isNotNull(title))
            Flexible(
              child: Text(
                title!,
                style: Apptheme.text.copyWith(
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
        color: Apptheme.white,
        border: Border(bottom: BorderSide(color: Apptheme.lightGray, width: 1)),
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
            style: Apptheme.text.copyWith(
              fontSize: 20.0,
              fontWeight: getFontWeight(600),
              color: Apptheme.vividRose,
            ),
          ),
        ),
      ],
    );
  }
}
