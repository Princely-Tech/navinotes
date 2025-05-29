double mobileSize = 640;
double tabletSize = 768;
double laptopSize = 1024;
double desktopSize = 1280;
double largeDesktopSize = 1536;

enum DeviceType {
  mobile,
  tablet,
  laptop,
  desktop,
  largeDesktop;

  bool get isMobile => this == mobile;
  bool get isTablet => this == tablet;
  bool get isLaptop => this == laptop;
  bool get isDesktop => this == desktop;
  bool get isLargeDesktop => this == largeDesktop;
}

DeviceType getDeviceType(double width) {
  if (width <= mobileSize) return DeviceType.mobile;
  if (width <= tabletSize) return DeviceType.tablet;
  if (width <= laptopSize) return DeviceType.laptop;
  if (width <= desktopSize) return DeviceType.desktop;
  return DeviceType.largeDesktop;
}
