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
    this.onEndReached,
    this.controller,
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
  final VoidCallback? onEndReached;
  final double endReachedThreshold = 100.0; // pixels from bottom to trigger onEndReached
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, child) {
        EdgeInsetsGeometry padding = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: mobilePadding ?? EdgeInsets.zero,
          tablet: tabletPadding,
          laptop: laptopPadding,
          desktop: desktopPadding,
          largeDesktop: largeDesktopPadding,
        );
        
        final shouldScroll = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: mobile,
          tablet: tablet,
          laptop: laptop,
          desktop: desktop,
          largeDesktop: largeDesktop,
        );
        
        if (!shouldScroll) {
          return Padding(padding: padding, child: child);
        }
        
        return NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (onEndReached != null && 
                metrics.pixels >= metrics.maxScrollExtent - endReachedThreshold) {
              onEndReached!();
            }
            return false;
          },
          child: SingleChildScrollView(
            padding: padding,
            scrollDirection: scrollDirection,
            controller: controller,
            child: child,
          ),
        );
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
    this.isFlexible = false,
  });

  const ExpandableController.flexible({
    super.key,
    required this.child,
    this.mobile = true,
    this.tablet,
    this.laptop,
    this.desktop,
    this.largeDesktop,
    this.isFlexible = true,
  });

  final Widget child;
  final bool mobile;
  final bool isFlexible;
  final bool? tablet;
  final bool? laptop;
  final bool? desktop;
  final bool? largeDesktop;

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return getDeviceResponsiveValue(
              deviceType: layoutVm.deviceType,
              mobile: mobile,
              tablet: tablet,
              laptop: laptop,
              desktop: desktop,
              largeDesktop: largeDesktop,
            )
            ? _returnChild()
            : child;
      },
      child: child,
    );
  }

  Widget _returnChild() {
    if (isFlexible) {
      return Flexible(child: child);
    }
    return Expanded(child: child);
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

class HeightLimiter extends StatelessWidget {
  const HeightLimiter({
    super.key,
    required this.child,
    required this.maxHeight,
  });

  final Widget child;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: child,
    );
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
        return getDeviceResponsiveValue(
              deviceType: layoutVm.deviceType,
              mobile: mobile,
              tablet: tablet,
              laptop: laptop,
              desktop: desktop,
              largeDesktop: largeDesktop,
            )
            ? child
            : const SizedBox();
      },
    );
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
          padding: getDeviceResponsiveValue(
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

class ResponsiveAspectRatio extends StatelessWidget {
  const ResponsiveAspectRatio({
    super.key,
    required this.mobile,
    this.tablet,
    this.laptop,
    this.desktop,
    this.largeDesktop,
    required this.child,
  });
  final double mobile;
  final double? tablet;
  final double? laptop;
  final double? desktop;
  final double? largeDesktop;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return AspectRatio(
          aspectRatio: getDeviceResponsiveValue(
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

class ResponsiveHorizontalPadding extends StatelessWidget {
  const ResponsiveHorizontalPadding({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      mobile: EdgeInsets.symmetric(horizontal: mobileHorPadding),
      laptop: EdgeInsets.symmetric(horizontal: laptopHorPadding),
      desktop: EdgeInsets.symmetric(horizontal: desktopHorPadding),
      child: child,
    );
  }
}
