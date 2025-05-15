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
        color: Apptheme.black.withAlpha(100),
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
