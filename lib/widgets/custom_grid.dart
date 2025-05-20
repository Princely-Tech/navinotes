import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/settings/screen_dimensions.dart';
import 'package:provider/provider.dart';

class CustomGrid extends StatelessWidget {
  const CustomGrid({
    super.key,
    required this.children,
    this.mobile = 1,
    this.tablets,
    this.laptops = 2,
    this.desktops,
    this.largeDesktops = 3,
  });
  final List<Widget> children;
  final int mobile;
  final int? tablets;
  final int? laptops;
  final int? desktops;
  final int? largeDesktops;

  @override
  Widget build(BuildContext context) {
    double defaultSpacing = 20;
    return Consumer<LayoutProviderVm>(
      builder: (context, vm, child) {
        int split = getSplit(vm.deviceType);
        List<List<Widget>> splitChildren = splitArray(children, split);

        return Column(
          spacing: defaultSpacing,
          children:
              splitChildren.map((children) {
                //Ensure each row is of equal length
                if (children.length < split) {
                  for (int i = children.length; i < split; i++) {
                    children.add(SizedBox.shrink());
                  }
                }
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: defaultSpacing,
                    children:
                        children.map((item) => Expanded(child: item)).toList(),
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  int getSplit(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.tablets:
        return tablets ?? mobile;
      case DeviceType.laptops:
        return laptops ?? tablets ?? mobile;
      case DeviceType.desktops:
        return desktops ?? laptops ?? tablets ?? mobile;
      case DeviceType.largeDesktops:
        return largeDesktops ?? desktops ?? laptops ?? tablets ?? mobile;
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
