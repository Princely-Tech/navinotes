import 'package:flutter/material.dart';

/// Page orientation enum
enum PageOrientation {
  portrait,
  landscape;

  String get displayName {
    switch (this) {
      case PageOrientation.portrait:
        return 'Portrait';
      case PageOrientation.landscape:
        return 'Landscape';
    }
  }

  IconData get icon {
    switch (this) {
      case PageOrientation.portrait:
        return Icons.stay_current_portrait;
      case PageOrientation.landscape:
        return Icons.stay_current_landscape;
    }
  }
}

/// Standard page sizes
enum PageSize {
  a4,
  a3,
  a5,
  letter,
  legal,
  tabloid,
  custom;

  String get displayName {
    switch (this) {
      case PageSize.a4:
        return 'A4';
      case PageSize.a3:
        return 'A3';
      case PageSize.a5:
        return 'A5';
      case PageSize.letter:
        return 'Letter';
      case PageSize.legal:
        return 'Legal';
      case PageSize.tabloid:
        return 'Tabloid';
      case PageSize.custom:
        return 'Custom';
    }
  }

  /// Get dimensions in points (72 DPI standard)
  Size get dimensions {
    switch (this) {
      case PageSize.a4:
        return const Size(595, 842); // 210 × 297 mm
      case PageSize.a3:
        return const Size(842, 1191); // 297 × 420 mm
      case PageSize.a5:
        return const Size(420, 595); // 148 × 210 mm
      case PageSize.letter:
        return const Size(612, 792); // 8.5 × 11 inches
      case PageSize.legal:
        return const Size(612, 1008); // 8.5 × 14 inches
      case PageSize.tabloid:
        return const Size(792, 1224); // 11 × 17 inches
      case PageSize.custom:
        return const Size(595, 842); // Default to A4
    }
  }

  /// Get display dimensions (scaled for UI)
  Size getDisplaySize({double scale = 0.5}) {
    final dims = dimensions;
    return Size(dims.width * scale, dims.height * scale);
  }
}

/// Page format combining size and orientation
class PageFormat {
  final PageSize size;
  final PageOrientation orientation;
  final Size? customSize; // For custom page sizes

  const PageFormat({
    required this.size,
    required this.orientation,
    this.customSize,
  });

  /// Default A4 Portrait format
  static const PageFormat defaultFormat = PageFormat(
    size: PageSize.a4,
    orientation: PageOrientation.portrait,
  );

  /// Get actual dimensions considering orientation
  Size get actualDimensions {
    Size baseDimensions = customSize ?? size.dimensions;
    
    if (orientation == PageOrientation.landscape) {
      return Size(baseDimensions.height, baseDimensions.width);
    }
    
    return baseDimensions;
  }

  /// Get display dimensions for UI (scaled down)
  Size getDisplayDimensions({double scale = 0.5}) {
    final dims = actualDimensions;
    return Size(dims.width * scale, dims.height * scale);
  }

  /// Get aspect ratio
  double get aspectRatio {
    final dims = actualDimensions;
    return dims.width / dims.height;
  }

  /// Create a copy with different properties
  PageFormat copyWith({
    PageSize? size,
    PageOrientation? orientation,
    Size? customSize,
  }) {
    return PageFormat(
      size: size ?? this.size,
      orientation: orientation ?? this.orientation,
      customSize: customSize ?? this.customSize,
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'size': size.name,
      'orientation': orientation.name,
      'customSize': customSize != null
          ? {'width': customSize!.width, 'height': customSize!.height}
          : null,
    };
  }

  /// Create from map
  factory PageFormat.fromMap(Map<String, dynamic> map) {
    Size? customSize;
    if (map['customSize'] != null) {
      final customMap = map['customSize'] as Map<String, dynamic>;
      customSize = Size(
        customMap['width']?.toDouble() ?? 0.0,
        customMap['height']?.toDouble() ?? 0.0,
      );
    }

    return PageFormat(
      size: PageSize.values.firstWhere(
        (e) => e.name == map['size'],
        orElse: () => PageSize.a4,
      ),
      orientation: PageOrientation.values.firstWhere(
        (e) => e.name == map['orientation'],
        orElse: () => PageOrientation.portrait,
      ),
      customSize: customSize,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PageFormat &&
        other.size == size &&
        other.orientation == orientation &&
        other.customSize == customSize;
  }

  @override
  int get hashCode {
    return Object.hash(size, orientation, customSize);
  }

  @override
  String toString() {
    return '${size.displayName} ${orientation.displayName}';
  }
}
