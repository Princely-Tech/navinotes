import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/screen_dimensions.dart';
import 'package:navinotes/settings/ui_helpers.dart';
import 'package:provider/provider.dart';

class SVGImagePlaceHolder extends StatelessWidget {
  const SVGImagePlaceHolder({super.key, required this.imagePath, this.size});

  final String imagePath;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Apptheme.black.withAlpha(100),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        height: size,
        width: size,
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}
class ImagePlaceHolder extends StatelessWidget {
  const ImagePlaceHolder({super.key, required this.imagePath, this.size});

  final String imagePath;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Apptheme.black.withAlpha(100),
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        height: size,
        width: size,
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
  const WidthLimiter({super.key, required this.child, required this.maxWidth});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = screenWidth(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: deviceWidth < maxWidth ? deviceWidth : maxWidth,
      ),
      child: child,
    );
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
    required this.scrollable,
  });

  final Widget child;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return scrollable ? SingleChildScrollView(child: child) : child;
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
  });

  final String title;
  final bool required;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: Apptheme.text.copyWith(
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
