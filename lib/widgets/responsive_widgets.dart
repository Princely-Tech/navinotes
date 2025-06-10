import 'package:navinotes/packages.dart';

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
        return Padding(padding: getPadding(layoutVm.deviceType), child: child);
      },
    );
  }

  EdgeInsets getPadding(DeviceType deviceType) {
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
