import 'package:flutter/material.dart';
import 'package:navinotes/settings/screen_dimensions.dart';
import 'package:navinotes/settings/ui_helpers.dart';

class LayoutProviderVm extends ChangeNotifier {
  DeviceType deviceType;
  LayoutProviderVm({required this.deviceType});

  void updateDeviceType(BuildContext context) {
    final newDeviceType = getDeviceType(screenWidth(context));
    if (deviceType != newDeviceType) {
      deviceType = newDeviceType;
      notifyListeners();
    }
  }
}
