import 'package:navinotes/packages.dart';

class ScrollableController extends StatelessWidget {
  const ScrollableController({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.laptopPadding,
    this.desktopPadding,
    this.largeDesktopPadding,
    this.scrollDirection = Axis.vertical,
    this.mobile = true,
    this.tablet,
    this.laptop,
    this.desktop,
    this.largeDesktop,
  });

  final Widget child;
  final EdgeInsetsGeometry? mobilePadding;
  final EdgeInsetsGeometry? tabletPadding;
  final EdgeInsetsGeometry? laptopPadding;
  final EdgeInsetsGeometry? desktopPadding;
  final EdgeInsetsGeometry? largeDesktopPadding;
  final Axis scrollDirection;
  final bool mobile;
  final bool? tablet;
  final bool? laptop;
  final bool? desktop;
  final bool? largeDesktop;

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, child) {
        EdgeInsetsGeometry padding = getPaddingFromDeviceWidth(
          deviceType: layoutVm.deviceType,
          mobile: mobilePadding,
          tablet: tabletPadding,
          laptop: laptopPadding,
          desktop: desktopPadding,
          largeDesktop: largeDesktopPadding,
        );
        return getBoolFromDeviceWidth(
              deviceType: layoutVm.deviceType,
              mobile: mobile,
              tablet: tablet,
              laptop: laptop,
              desktop: desktop,
              largeDesktop: largeDesktop,
            )
            ? SingleChildScrollView(
              padding: padding,
              scrollDirection: scrollDirection,
              child: child,
            )
            : Container(padding: padding, child: child);
      },
      child: child,
    );
  }
}

class ExpandableController extends StatelessWidget {
  const ExpandableController({
    super.key,
    required this.child,
    this.mobile = true,
    this.tablet,
    this.laptop,
    this.desktop,
    this.largeDesktop,
  });

  final Widget child;
  final bool mobile;
  final bool? tablet;
  final bool? laptop;
  final bool? desktop;
  final bool? largeDesktop;

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return getBoolFromDeviceWidth(
              deviceType: layoutVm.deviceType,
              mobile: mobile,
              tablet: tablet,
              laptop: laptop,
              desktop: desktop,
              largeDesktop: largeDesktop,
            )
            ? Expanded(child: child)
            : child;
      },
      child: child,
    );
  }
}

class WidthLimiter extends StatelessWidget {
  const WidthLimiter({
    super.key,
    required this.child,
    required this.mobile,
    this.tablet,
    this.laptop,
    this.desktop,
    this.largeDesktop,
  });

  final Widget child;
  final double mobile;
  final double? tablet;
  final double? laptop;
  final double? desktop;
  final double? largeDesktop;

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
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.laptop:
        return laptop ?? tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? laptop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? laptop ?? tablet ?? mobile;
    }
  }
}

class ResponsiveSection extends StatelessWidget {
  const ResponsiveSection({
    super.key,
    required this.mobile,
    this.tablet,
    this.laptop,
    this.desktop,
    this.largeDesktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? laptop;
  final Widget? desktop;
  final Widget? largeDesktop;

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (context, vm, child) {
        switch (vm.deviceType) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.laptop:
            return laptop ?? tablet ?? mobile;
          case DeviceType.desktop:
            return desktop ?? laptop ?? tablet ?? mobile;
          case DeviceType.largeDesktop:
            return largeDesktop ?? desktop ?? laptop ?? tablet ?? mobile;
        }
      },
    );
  }
}

class VisibleController extends StatelessWidget {
  const VisibleController({
    super.key,
    required this.mobile,
    this.tablet,
    this.laptop,
    this.desktop,
    this.largeDesktop,
    required this.child,
  });
  final bool mobile;
  final bool? tablet;
  final bool? laptop;
  final bool? desktop;
  final bool? largeDesktop;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return getVisible(layoutVm.deviceType) ? child : const SizedBox();
      },
    );
  }

  bool getVisible(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.laptop:
        return laptop ?? tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? laptop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? laptop ?? tablet ?? mobile;
    }
  }
}

class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    super.key,
    required this.mobile,
    this.tablet,
    this.laptop,
    this.desktop,
    this.largeDesktop,
    required this.child,
  });
  final EdgeInsets mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? laptop;
  final EdgeInsets? desktop;
  final EdgeInsets? largeDesktop;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Padding(
          padding: getPaddingFromDeviceWidth(
            deviceType: layoutVm.deviceType,
            mobile: mobile,
            tablet: tablet,
            laptop: laptop,
            desktop: desktop,
            largeDesktop: largeDesktop,
          ),
          child: child,
        );
      },
    );
  }
}
