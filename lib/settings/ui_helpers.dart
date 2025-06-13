import 'package:navinotes/packages.dart';

double defaultHorizontalPadding = 20;

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

Size deviceSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

FontWeight getFontWeight(int weight) {
  switch (weight) {
    case 100:
      return FontWeight.w200;
    case 200:
      return FontWeight.w300;
    case 300:
      return FontWeight.w400;
    case 400:
      return FontWeight.w500;
    case 500:
      return FontWeight.w600;
    case 600:
      return FontWeight.w700;
    case 700:
      return FontWeight.w800;
    case 800:
      return FontWeight.w900;
    case 900:
      return FontWeight.w900;
    default:
      throw Exception('Invalid font weight');
  }
}

bool getBoolFromDeviceWidth({
  required DeviceType deviceType,
  required bool mobile,
  bool? tablet,
  bool? laptop,
  bool? desktop,
  bool? largeDesktop,
}) {
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
