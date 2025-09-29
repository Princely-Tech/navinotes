import 'package:flutter/material.dart';

/// Drawing tool categories for organizing tools
enum DrawingToolCategory {
  pen,
  shapes,
  arrows,
  text,
  utilities,
}

/// Drawing tool types with expanded shape support
enum DrawingToolType {
  // Pen tools
  simpleLine,
  smoothLine,
  straightLine,
  eraser,
  
  // Basic shapes
  rectangle,
  circle,
  triangle,
  diamond,
  pentagon,
  hexagon,
  star,
  heart,
  
  // Arrows
  arrowStraight,
  arrowCurved,
  arrowDouble,
  arrowBent,
  
  // Lines and connectors
  dottedLine,
  dashedLine,
  zigzagLine,
  
  // Text
  textBox,
  textCallout,
  textBold,
  textItalic,
  textUnderline,
  
  // Utilities
  highlighter,
  marker,
}

/// Stroke styles for drawing tools
enum StrokeStyle {
  solid,
  dashed,
  dotted,
  dashedDot,
}

/// Line cap styles
enum LineCapStyle {
  round,
  square,
  butt,
}

/// Drawing tool configuration
class DrawingToolConfig {
  final DrawingToolType type;
  final String name;
  final String description;
  final IconData icon;
  final Color defaultColor;
  final double defaultStrokeWidth;
  final StrokeStyle defaultStrokeStyle;
  final LineCapStyle defaultLineCap;
  final bool fillEnabled;
  final DrawingToolCategory category;

  const DrawingToolConfig({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    this.defaultColor = Colors.black,
    this.defaultStrokeWidth = 2.0,
    this.defaultStrokeStyle = StrokeStyle.solid,
    this.defaultLineCap = LineCapStyle.round,
    this.fillEnabled = false,
  });
}

/// Predefined color palette for quick access
class DrawingColorPalette {
  static const List<Color> basicColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.cyan,
  ];

  static const List<Color> extendedColors = [
    Color(0xFF1A1A1A), // Dark black
    Color(0xFF333333), // Dark grey
    Color(0xFF666666), // Medium grey
    Color(0xFF999999), // Light grey
    Color(0xFFCCCCCC), // Very light grey
    Color(0xFFFFFFFF), // White
    
    Color(0xFFFF0000), // Red
    Color(0xFFFF6666), // Light red
    Color(0xFF990000), // Dark red
    Color(0xFFFFCCCC), // Very light red
    
    Color(0xFF00FF00), // Green
    Color(0xFF66FF66), // Light green
    Color(0xFF009900), // Dark green
    Color(0xFFCCFFCC), // Very light green
    
    Color(0xFF0000FF), // Blue
    Color(0xFF6666FF), // Light blue
    Color(0xFF000099), // Dark blue
    Color(0xFFCCCCFF), // Very light blue
    
    Color(0xFFFFFF00), // Yellow
    Color(0xFFFFFF99), // Light yellow
    Color(0xFF999900), // Dark yellow
    Color(0xFFFFFFCC), // Very light yellow
    
    Color(0xFFFF8000), // Orange
    Color(0xFFFFB366), // Light orange
    Color(0xFF994D00), // Dark orange
    Color(0xFFFFE6CC), // Very light orange
    
    Color(0xFF8000FF), // Purple
    Color(0xFFB366FF), // Light purple
    Color(0xFF4D0099), // Dark purple
    Color(0xFFE6CCFF), // Very light purple
  ];
}

/// Drawing tool definitions
class DrawingTools {
  static const Map<DrawingToolType, DrawingToolConfig> tools = {
    // Pen tools
    DrawingToolType.simpleLine: DrawingToolConfig(
      type: DrawingToolType.simpleLine,
      name: 'Pen',
      description: 'Simple drawing pen',
      icon: Icons.edit,
      category: DrawingToolCategory.pen,
    ),
    DrawingToolType.smoothLine: DrawingToolConfig(
      type: DrawingToolType.smoothLine,
      name: 'Brush',
      description: 'Smooth brush stroke',
      icon: Icons.brush,
      category: DrawingToolCategory.pen,
    ),
    DrawingToolType.straightLine: DrawingToolConfig(
      type: DrawingToolType.straightLine,
      name: 'Line',
      description: 'Straight line',
      icon: Icons.show_chart,
      category: DrawingToolCategory.pen,
    ),
    DrawingToolType.highlighter: DrawingToolConfig(
      type: DrawingToolType.highlighter,
      name: 'Highlighter',
      description: 'Highlight text',
      icon: Icons.highlight,
      category: DrawingToolCategory.pen,
      defaultColor: Colors.yellow,
      defaultStrokeWidth: 8.0,
    ),
    DrawingToolType.marker: DrawingToolConfig(
      type: DrawingToolType.marker,
      name: 'Marker',
      description: 'Thick marker',
      icon: Icons.create,
      category: DrawingToolCategory.pen,
      defaultStrokeWidth: 6.0,
    ),
    
    // Basic shapes
    DrawingToolType.rectangle: DrawingToolConfig(
      type: DrawingToolType.rectangle,
      name: 'Rectangle',
      description: 'Draw rectangle',
      icon: Icons.crop_square,
      category: DrawingToolCategory.shapes,
      fillEnabled: true,
    ),
    DrawingToolType.circle: DrawingToolConfig(
      type: DrawingToolType.circle,
      name: 'Circle',
      description: 'Draw circle',
      icon: Icons.circle_outlined,
      category: DrawingToolCategory.shapes,
      fillEnabled: true,
    ),
    DrawingToolType.triangle: DrawingToolConfig(
      type: DrawingToolType.triangle,
      name: 'Triangle',
      description: 'Draw triangle',
      icon: Icons.change_history,
      category: DrawingToolCategory.shapes,
      fillEnabled: true,
    ),
    DrawingToolType.diamond: DrawingToolConfig(
      type: DrawingToolType.diamond,
      name: 'Diamond',
      description: 'Draw diamond',
      icon: Icons.diamond_outlined,
      category: DrawingToolCategory.shapes,
      fillEnabled: true,
    ),
    DrawingToolType.pentagon: DrawingToolConfig(
      type: DrawingToolType.pentagon,
      name: 'Pentagon',
      description: 'Draw pentagon',
      icon: Icons.pentagon_outlined,
      category: DrawingToolCategory.shapes,
      fillEnabled: true,
    ),
    DrawingToolType.hexagon: DrawingToolConfig(
      type: DrawingToolType.hexagon,
      name: 'Hexagon',
      description: 'Draw hexagon',
      icon: Icons.hexagon_outlined,
      category: DrawingToolCategory.shapes,
      fillEnabled: true,
    ),
    DrawingToolType.star: DrawingToolConfig(
      type: DrawingToolType.star,
      name: 'Star',
      description: 'Draw star',
      icon: Icons.star_outline,
      category: DrawingToolCategory.shapes,
      fillEnabled: true,
    ),
    DrawingToolType.heart: DrawingToolConfig(
      type: DrawingToolType.heart,
      name: 'Heart',
      description: 'Draw heart',
      icon: Icons.favorite_border,
      category: DrawingToolCategory.shapes,
      fillEnabled: true,
    ),
    
    // Arrows
    DrawingToolType.arrowStraight: DrawingToolConfig(
      type: DrawingToolType.arrowStraight,
      name: 'Arrow',
      description: 'Straight arrow',
      icon: Icons.arrow_forward,
      category: DrawingToolCategory.arrows,
    ),
    DrawingToolType.arrowCurved: DrawingToolConfig(
      type: DrawingToolType.arrowCurved,
      name: 'Curved Arrow',
      description: 'Curved arrow',
      icon: Icons.turn_right,
      category: DrawingToolCategory.arrows,
    ),
    DrawingToolType.arrowDouble: DrawingToolConfig(
      type: DrawingToolType.arrowDouble,
      name: 'Double Arrow',
      description: 'Double-headed arrow',
      icon: Icons.swap_horiz,
      category: DrawingToolCategory.arrows,
    ),
    DrawingToolType.arrowBent: DrawingToolConfig(
      type: DrawingToolType.arrowBent,
      name: 'Bent Arrow',
      description: 'L-shaped arrow',
      icon: Icons.call_made,
      category: DrawingToolCategory.arrows,
    ),
    
    // Lines
    DrawingToolType.dottedLine: DrawingToolConfig(
      type: DrawingToolType.dottedLine,
      name: 'Dotted Line',
      description: 'Dotted line',
      icon: Icons.more_horiz,
      category: DrawingToolCategory.pen,
      defaultStrokeStyle: StrokeStyle.dotted,
    ),
    DrawingToolType.dashedLine: DrawingToolConfig(
      type: DrawingToolType.dashedLine,
      name: 'Dashed Line',
      description: 'Dashed line',
      icon: Icons.horizontal_rule,
      category: DrawingToolCategory.pen,
      defaultStrokeStyle: StrokeStyle.dashed,
    ),
    
    // Text
    DrawingToolType.textBox: DrawingToolConfig(
      type: DrawingToolType.textBox,
      name: 'Text Box',
      description: 'Add editable text box',
      icon: Icons.text_fields,
      category: DrawingToolCategory.text,
    ),
    DrawingToolType.textCallout: DrawingToolConfig(
      type: DrawingToolType.textCallout,
      name: 'Callout',
      description: 'Text with callout bubble',
      icon: Icons.chat_bubble_outline,
      category: DrawingToolCategory.text,
    ),
    DrawingToolType.textBold: DrawingToolConfig(
      type: DrawingToolType.textBold,
      name: 'Bold Text',
      description: 'Bold text box',
      icon: Icons.format_bold,
      category: DrawingToolCategory.text,
    ),
    DrawingToolType.textItalic: DrawingToolConfig(
      type: DrawingToolType.textItalic,
      name: 'Italic Text',
      description: 'Italic text box',
      icon: Icons.format_italic,
      category: DrawingToolCategory.text,
    ),
    DrawingToolType.textUnderline: DrawingToolConfig(
      type: DrawingToolType.textUnderline,
      name: 'Underlined Text',
      description: 'Underlined text box',
      icon: Icons.format_underlined,
      category: DrawingToolCategory.text,
    ),
    
    // Utilities
    DrawingToolType.eraser: DrawingToolConfig(
      type: DrawingToolType.eraser,
      name: 'Eraser',
      description: 'Erase drawing',
      icon: Icons.cleaning_services,
      category: DrawingToolCategory.utilities,
    ),
  };

  /// Get tools by category
  static List<DrawingToolConfig> getToolsByCategory(DrawingToolCategory category) {
    return tools.values.where((tool) => tool.category == category).toList();
  }

  /// Get tool config by type
  static DrawingToolConfig? getToolConfig(DrawingToolType type) {
    return tools[type];
  }

  /// Get all categories
  static List<DrawingToolCategory> getAllCategories() {
    return DrawingToolCategory.values;
  }
}

/// Extension to get category display properties
extension DrawingToolCategoryExtension on DrawingToolCategory {
  String get displayName {
    switch (this) {
      case DrawingToolCategory.pen:
        return 'Pen Tools';
      case DrawingToolCategory.shapes:
        return 'Shapes';
      case DrawingToolCategory.arrows:
        return 'Arrows';
      case DrawingToolCategory.text:
        return 'Text';
      case DrawingToolCategory.utilities:
        return 'Utilities';
    }
  }

  IconData get icon {
    switch (this) {
      case DrawingToolCategory.pen:
        return Icons.edit;
      case DrawingToolCategory.shapes:
        return Icons.crop_square;
      case DrawingToolCategory.arrows:
        return Icons.arrow_forward;
      case DrawingToolCategory.text:
        return Icons.text_fields;
      case DrawingToolCategory.utilities:
        return Icons.build;
    }
  }

  Color get color {
    switch (this) {
      case DrawingToolCategory.pen:
        return Colors.blue;
      case DrawingToolCategory.shapes:
        return Colors.green;
      case DrawingToolCategory.arrows:
        return Colors.orange;
      case DrawingToolCategory.text:
        return Colors.purple;
      case DrawingToolCategory.utilities:
        return Colors.grey;
    }
  }
}
