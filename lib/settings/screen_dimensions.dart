double mobileSize = 640;
double tabletsSize = 768;
double laptopsSize = 1024;
double desktopsSize = 1280;
double largeDesktopsSize = 1536;

enum DeviceType { 
  mobile,
  tablets,
  laptops,
  desktops,
  largeDesktops;

  bool get isMobile => this == mobile;
  bool get isTablets => this == tablets;
  bool get isLaptops => this == laptops;
  bool get isDesktops => this == desktops;
  bool get isLargeDesktops => this == largeDesktops;
}

DeviceType getDeviceType(double width) {
  if (width <= mobileSize) return DeviceType.mobile;
  if (width <= tabletsSize) return DeviceType.tablets;
  if (width <= laptopsSize) return DeviceType.laptops;
  if (width <= desktopsSize) return DeviceType.desktops;
  return DeviceType.largeDesktops;
}
