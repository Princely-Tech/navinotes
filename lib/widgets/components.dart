import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/screen_dimensions.dart';
import 'package:navinotes/settings/ui_helpers.dart';
import 'package:navinotes/settings/util_functions.dart';
import 'package:provider/provider.dart';

class SVGImagePlaceHolder extends StatelessWidget {
  const SVGImagePlaceHolder({
    super.key,
    required this.imagePath,
    this.size,
    this.containerSize,
    this.color,
    this.decoration,
  });

  final String imagePath;
  final double? size;
  final double? containerSize;
  final Decoration? decoration;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: decoration ?? BoxDecoration(shape: BoxShape.circle),
      child: isNotNull(containerSize) ? Center(child: _body()) : _body(),
    );
  }

  Widget _body() {
    return SvgPicture.asset(
      height: size,
      width: size,
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

class WidthLimiter extends StatelessWidget {
  const WidthLimiter({
    super.key,
    required this.child,
    required this.mobile,
    this.tablets,
    this.laptops,
    this.desktops,
    this.largeDesktops,
  });

  final Widget child;
  final double mobile;
  final double? tablets;
  final double? laptops;
  final double? desktops;
  final double? largeDesktops;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = screenWidth(context);
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, child) {
        double maxWidth = getMaxWidth(layoutVm.deviceType);
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: deviceWidth < maxWidth ? deviceWidth : maxWidth,
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  double getMaxWidth(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablets:
        return tablets ?? mobile;
      case DeviceType.laptops:
        return laptops ?? tablets ?? mobile;
      case DeviceType.desktops:
        return desktops ?? laptops ?? tablets ?? mobile;
      case DeviceType.largeDesktops:
        return largeDesktops ?? desktops ?? laptops ?? tablets ?? mobile;
    }
  }
}

class ResponsiveSection extends StatelessWidget {
  const ResponsiveSection({
    super.key,
    required this.mobile,
    this.tablets,
    this.laptops,
    this.desktops,
    this.largeDesktops,
  });

  final Widget mobile;
  final Widget? tablets;
  final Widget? laptops;
  final Widget? desktops;
  final Widget? largeDesktops;

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (context, vm, child) {
        switch (vm.deviceType) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablets:
            return tablets ?? mobile;
          case DeviceType.laptops:
            return laptops ?? tablets ?? mobile;
          case DeviceType.desktops:
            return desktops ?? laptops ?? tablets ?? mobile;
          case DeviceType.largeDesktops:
            return largeDesktops ?? desktops ?? laptops ?? tablets ?? mobile;
        }
      },
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

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
    this.decoration = const BoxDecoration(),
    this.width = double.infinity,
    this.height,
    this.margin,
    // this.edgeClipRadius,
  });
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxDecoration decoration;
  final double? width;
  final double? height;
  // final double? edgeClipRadius;
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius =
        decoration.borderRadius ?? BorderRadius.circular(12);
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: decoration.copyWith(
        color: decoration.color ?? Apptheme.white,
        borderRadius: decoration.shape == BoxShape.circle ? null : radius,
        shape: null,
        border: decoration.border ?? Border.all(color: Apptheme.lightGray),
      ),
      padding: padding,
      child: child,
    );
  }
}

class VisibleController extends StatelessWidget {
  const VisibleController({
    super.key,
    required this.visible,
    required this.child,
  });
  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return visible ? child : const SizedBox();
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
  });

  final Widget child;
  final BoxDecoration decoration;
  final double size;

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry borderRadius =
        decoration.borderRadius ?? BorderRadius.circular(6);
    return Container(
      width: size,
      height: size,
      decoration: decoration.copyWith(
        borderRadius: decoration.shape == BoxShape.circle ? null : borderRadius,
        border: decoration.border ?? Border.all(color: Apptheme.lightGray),
      ),
      child: Center(child: child),
    );
  }
}

class CreateCard extends StatelessWidget {
  const CreateCard({super.key, required this.onTap, required this.text});
  final void Function()? onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap:onTap,
          child: CustomCard(
            child: Column(
              spacing: 15,
              children: [
                CustomCard(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Apptheme.paleBlue,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.zero,
                  child: Icon(Icons.add, color: Apptheme.vividBlue),
                ),
                Column(
                  spacing: 5,
                  children: [
                    Text(
                      text,
                      style: Apptheme.text.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Start organizing your ideas',
                      style: Apptheme.text.copyWith(color: Apptheme.steelMist),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
