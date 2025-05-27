import 'package:flutter/material.dart';
import 'package:navinotes/settings/screen_dimensions.dart';
import 'package:navinotes/settings/ui_helpers.dart';

class LayoutProviderVm extends ChangeNotifier {
  DeviceType deviceType;
  BuildContext context;
  LayoutProviderVm({required this.deviceType, required this.context});

  void updateDeviceType() {
    final newDeviceType = getDeviceType(screenWidth(context));
    if (deviceType != newDeviceType) {
      deviceType = newDeviceType;
      notifyListeners();
    }
  }
  double deviceWidth(){
    return screenWidth(context);
  }
}
