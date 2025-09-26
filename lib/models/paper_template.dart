import 'package:flutter/material.dart';

/// Paper sizes following standard formats
enum PaperSize {
  a4,
  a5,
  letter,
  legal,
  custom;

  Size get dimensions {
    switch (this) {
      case PaperSize.a4:
        return const Size(595, 842); // A4 in points (72 DPI)
      case PaperSize.a5:
        return const Size(420, 595); // A5 in points
      case PaperSize.letter:
        return const Size(612, 792); // US Letter in points
      case PaperSize.legal:
        return const Size(612, 1008); // US Legal in points
      case PaperSize.custom:
        return const Size(595, 842); // Default to A4
    }
  }

  String get displayName {
    switch (this) {
      case PaperSize.a4:
        return 'A4';
      case PaperSize.a5:
        return 'A5';
      case PaperSize.letter:
        return 'Letter';
      case PaperSize.legal:
        return 'Legal';
      case PaperSize.custom:
        return 'Custom';
    }
  }
}

/// Paper types with different line patterns
enum PaperType {
  blank,
  lined,
  dotted,
  grid,
  cornell,
  music,
  calendar,
  planner;

  String get displayName {
    switch (this) {
      case PaperType.blank:
        return 'Blank';
      case PaperType.lined:
        return 'Lined';
      case PaperType.dotted:
        return 'Dotted';
      case PaperType.grid:
        return 'Grid';
      case PaperType.cornell:
        return 'Cornell Notes';
      case PaperType.music:
        return 'Music Staff';
      case PaperType.calendar:
        return 'Calendar';
      case PaperType.planner:
        return 'Daily Planner';
    }
  }

  String get description {
    switch (this) {
      case PaperType.blank:
        return 'Clean white paper for free-form writing';
      case PaperType.lined:
        return 'Horizontal lines for neat handwriting';
      case PaperType.dotted:
        return 'Dot grid for flexible layouts';
      case PaperType.grid:
        return 'Square grid for precise drawings';
      case PaperType.cornell:
        return 'Cornell note-taking system layout';
      case PaperType.music:
        return 'Musical staff lines for notation';
      case PaperType.calendar:
        return 'Monthly calendar layout';
      case PaperType.planner:
        return 'Daily planning template';
    }
  }
}

/// Paper colors and themes
enum PaperColor {
  white,
  cream,
  yellow,
  blue,
  green,
  pink,
  gray,
  black;

  Color get backgroundColor {
    switch (this) {
      case PaperColor.white:
        return const Color(0xFFFFFFFF);
      case PaperColor.cream:
        return const Color(0xFFFFFDD0);
      case PaperColor.yellow:
        return const Color(0xFFFFFACD);
      case PaperColor.blue:
        return const Color(0xFFE6F3FF);
      case PaperColor.green:
        return const Color(0xFFE8F5E8);
      case PaperColor.pink:
        return const Color(0xFFFFE4E1);
      case PaperColor.gray:
        return const Color(0xFFF5F5F5);
      case PaperColor.black:
        return const Color(0xFF1A1A1A);
    }
  }

  Color get lineColor {
    switch (this) {
      case PaperColor.white:
      case PaperColor.cream:
      case PaperColor.yellow:
      case PaperColor.blue:
      case PaperColor.green:
      case PaperColor.pink:
      case PaperColor.gray:
        return const Color(0xFFE0E0E0);
      case PaperColor.black:
        return const Color(0xFF404040);
    }
  }

  String get displayName {
    switch (this) {
      case PaperColor.white:
        return 'White';
      case PaperColor.cream:
        return 'Cream';
      case PaperColor.yellow:
        return 'Yellow';
      case PaperColor.blue:
        return 'Blue';
      case PaperColor.green:
        return 'Green';
      case PaperColor.pink:
        return 'Pink';
      case PaperColor.gray:
        return 'Gray';
      case PaperColor.black:
        return 'Black';
    }
  }
}

/// Line spacing options
enum LineSpacing {
  narrow,
  standard,
  wide,
  extraWide;

  double get spacing {
    switch (this) {
      case LineSpacing.narrow:
        return 20.0;
      case LineSpacing.standard:
        return 24.0;
      case LineSpacing.wide:
        return 28.0;
      case LineSpacing.extraWide:
        return 32.0;
    }
  }

  String get displayName {
    switch (this) {
      case LineSpacing.narrow:
        return 'Narrow';
      case LineSpacing.standard:
        return 'Standard';
      case LineSpacing.wide:
        return 'Wide';
      case LineSpacing.extraWide:
        return 'Extra Wide';
    }
  }
}

/// Complete paper template configuration
class PaperTemplate {
  final String id;
  final String name;
  final PaperSize size;
  final PaperType type;
  final PaperColor color;
  final LineSpacing lineSpacing;
  final bool showMargins;
  final double marginLeft;
  final double marginRight;
  final double marginTop;
  final double marginBottom;
  final bool isCustom;

  const PaperTemplate({
    required this.id,
    required this.name,
    required this.size,
    required this.type,
    required this.color,
    this.lineSpacing = LineSpacing.standard,
    this.showMargins = true,
    this.marginLeft = 72.0, // 1 inch in points
    this.marginRight = 72.0,
    this.marginTop = 72.0,
    this.marginBottom = 72.0,
    this.isCustom = false,
  });

  PaperTemplate copyWith({
    String? id,
    String? name,
    PaperSize? size,
    PaperType? type,
    PaperColor? color,
    LineSpacing? lineSpacing,
    bool? showMargins,
    double? marginLeft,
    double? marginRight,
    double? marginTop,
    double? marginBottom,
    bool? isCustom,
  }) {
    return PaperTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      size: size ?? this.size,
      type: type ?? this.type,
      color: color ?? this.color,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      showMargins: showMargins ?? this.showMargins,
      marginLeft: marginLeft ?? this.marginLeft,
      marginRight: marginRight ?? this.marginRight,
      marginTop: marginTop ?? this.marginTop,
      marginBottom: marginBottom ?? this.marginBottom,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'size': size.name,
      'type': type.name,
      'color': color.name,
      'lineSpacing': lineSpacing.name,
      'showMargins': showMargins,
      'marginLeft': marginLeft,
      'marginRight': marginRight,
      'marginTop': marginTop,
      'marginBottom': marginBottom,
      'isCustom': isCustom,
    };
  }

  factory PaperTemplate.fromMap(Map<String, dynamic> map) {
    return PaperTemplate(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      size: PaperSize.values.firstWhere(
        (e) => e.name == map['size'],
        orElse: () => PaperSize.a4,
      ),
      type: PaperType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => PaperType.blank,
      ),
      color: PaperColor.values.firstWhere(
        (e) => e.name == map['color'],
        orElse: () => PaperColor.white,
      ),
      lineSpacing: LineSpacing.values.firstWhere(
        (e) => e.name == map['lineSpacing'],
        orElse: () => LineSpacing.standard,
      ),
      showMargins: map['showMargins'] ?? true,
      marginLeft: map['marginLeft']?.toDouble() ?? 72.0,
      marginRight: map['marginRight']?.toDouble() ?? 72.0,
      marginTop: map['marginTop']?.toDouble() ?? 72.0,
      marginBottom: map['marginBottom']?.toDouble() ?? 72.0,
      isCustom: map['isCustom'] ?? false,
    );
  }
}

/// Predefined paper templates similar to GoodNotes
class PaperTemplates {
  static const List<PaperTemplate> defaultTemplates = [
    // Blank templates
    PaperTemplate(
      id: 'blank_white_a4',
      name: 'Blank White A4',
      size: PaperSize.a4,
      type: PaperType.blank,
      color: PaperColor.white,
    ),
    PaperTemplate(
      id: 'blank_cream_a4',
      name: 'Blank Cream A4',
      size: PaperSize.a4,
      type: PaperType.blank,
      color: PaperColor.cream,
    ),
    
    // Lined templates
    PaperTemplate(
      id: 'lined_white_a4',
      name: 'Lined White A4',
      size: PaperSize.a4,
      type: PaperType.lined,
      color: PaperColor.white,
    ),
    PaperTemplate(
      id: 'lined_yellow_a4',
      name: 'Lined Yellow A4',
      size: PaperSize.a4,
      type: PaperType.lined,
      color: PaperColor.yellow,
    ),
    
    // Dotted templates
    PaperTemplate(
      id: 'dotted_white_a4',
      name: 'Dotted White A4',
      size: PaperSize.a4,
      type: PaperType.dotted,
      color: PaperColor.white,
    ),
    
    // Grid templates
    PaperTemplate(
      id: 'grid_white_a4',
      name: 'Grid White A4',
      size: PaperSize.a4,
      type: PaperType.grid,
      color: PaperColor.white,
    ),
    
    // Cornell templates
    PaperTemplate(
      id: 'cornell_white_a4',
      name: 'Cornell Notes A4',
      size: PaperSize.a4,
      type: PaperType.cornell,
      color: PaperColor.white,
    ),
    
    // Letter size templates
    PaperTemplate(
      id: 'lined_white_letter',
      name: 'Lined White Letter',
      size: PaperSize.letter,
      type: PaperType.lined,
      color: PaperColor.white,
    ),
  ];

  static PaperTemplate getDefault() {
    return defaultTemplates.first;
  }

  static PaperTemplate? getById(String id) {
    try {
      return defaultTemplates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<PaperTemplate> getByType(PaperType type) {
    return defaultTemplates.where((template) => template.type == type).toList();
  }

  static List<PaperTemplate> getBySize(PaperSize size) {
    return defaultTemplates.where((template) => template.size == size).toList();
  }
}
