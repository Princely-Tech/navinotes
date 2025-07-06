import 'package:navinotes/packages.dart';

class CustomGrid extends StatelessWidget {
  const CustomGrid({
    super.key,
    required this.children,
    this.mobile = 1,
    this.tablet,
    this.laptop = 2,
    this.desktop,
    this.spacing,
    this.largeDesktop = 3,
    this.wrapWithIntrinsicHeight = true,
    this.mobileSpacing,
  });
  final List<Widget> children;
  final int mobile;
  final int? tablet;
  final int? laptop;
  final int? desktop;
  final int? largeDesktop;
  final double? spacing;
  final double? mobileSpacing;
  final bool wrapWithIntrinsicHeight;

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (context, vm, child) {
        int split = getSplit(vm.deviceType);
        List<List<Widget>> splitChildren = splitArray(children, split);
        return Column(
          spacing: getDefaultSpacing(),
          children:
              splitChildren.map((children) {
                //Ensure each row is of equal length
                if (children.length < split) {
                  for (int i = children.length; i < split; i++) {
                    children.add(SizedBox.shrink());
                  }
                }
                return wrapWithIntrinsicHeight
                    ? IntrinsicHeight(
                      child: _body(children: children),
                    ) //TODO consider removing intinsic height
                    : _body(children: children);
              }).toList(),
        );
      },
    );
  }

  Widget _body({required List<Widget> children}) {
    return Consumer<LayoutProviderVm>(
      builder: (context, vm, child) {
        return Row(
          crossAxisAlignment:
              wrapWithIntrinsicHeight
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.start,
          spacing: getDefaultSpacing(),
          children: children.map((item) => Expanded(child: item)).toList(),
        );
      },
    );
  }

  double getDefaultSpacing() {
    return spacing ?? 20;
    // return getDeviceResponsiveValue(
    //   deviceType: deviceType,
    //   mobile: mobileSpacing ?? defaultSpace,
    //   tablet: spacing ?? defaultSpace,
    // );
  }

  int getSplit(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.laptop:
        return laptop ?? tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? laptop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? laptop ?? tablet ?? mobile;
      default:
        return mobile;
    }
  }
}

List<List<T>> splitArray<T>(List<T> array, int split) {
  List<List<T>> result = [];

  for (int i = 0; i < array.length; i += split) {
    int end = (i + split < array.length) ? i + split : array.length;
    result.add(array.sublist(i, end));
  }

  return result;
}
