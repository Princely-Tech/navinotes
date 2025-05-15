double mobileSize = 640;
double tabletsSize = 768;
double laptopsSize = 1024;
double desktopsSize = 1280;
double largeDesktopsSize = 1536;

enum DeviceTypes { 
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

DeviceTypes getDeviceType(double width) {
  if (width <= mobileSize) return DeviceTypes.mobile;
  if (width <= tabletsSize) return DeviceTypes.tablets;
  if (width <= laptopsSize) return DeviceTypes.laptops;
  if (width <= desktopsSize) return DeviceTypes.desktops;
  return DeviceTypes.largeDesktops;
}
