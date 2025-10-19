import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Text box model for drawing canvas
class TextBox {
  final String id;
  final Offset position;
  final Size size;
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final bool hasBorder;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final TextAlign textAlign;
  final EdgeInsets padding;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TextBox({
    required this.id,
    required this.position,
    required this.size,
    required this.text,
    required this.textStyle,
    this.backgroundColor = Colors.transparent,
    this.hasBorder = false,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.borderRadius = BorderRadius.zero,
    this.textAlign = TextAlign.left,
    this.padding = const EdgeInsets.all(8.0),
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new text box with default values
  factory TextBox.create({
    required Offset position,
    String text = 'Text',
    TextStyle? textStyle,
    Size? size,
  }) {
    final now = DateTime.now();
    return TextBox(
      id: const Uuid().v4(),
      position: position,
      size: size ?? const Size(120, 40),
      text: text,
      textStyle:
          textStyle ??
          const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create a copy with updated properties
  TextBox copyWith({
    String? id,
    Offset? position,
    Size? size,
    String? text,
    TextStyle? textStyle,
    Color? backgroundColor,
    bool? hasBorder,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    TextAlign? textAlign,
    EdgeInsets? padding,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TextBox(
      id: id ?? this.id,
      position: position ?? this.position,
      size: size ?? this.size,
      text: text ?? this.text,
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      hasBorder: hasBorder ?? this.hasBorder,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      textAlign: textAlign ?? this.textAlign,
      padding: padding ?? this.padding,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get the bounds rectangle of the text box
  Rect get bounds =>
      Rect.fromLTWH(position.dx, position.dy, size.width, size.height);

  /// Check if a point is inside the text box
  bool containsPoint(Offset point) {
    return bounds.contains(point);
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': {'dx': position.dx, 'dy': position.dy},
      'size': {'width': size.width, 'height': size.height},
      'text': text,
      'textStyle': {
        'fontSize': textStyle.fontSize,
        'color': textStyle.color?.value,
        'fontWeight': textStyle.fontWeight?.index,
        'fontStyle': textStyle.fontStyle?.index,
        'decoration': textStyle.decoration?.toString(),
        'fontFamily': textStyle.fontFamily,
      },
      'backgroundColor': backgroundColor.value,
      'hasBorder': hasBorder,
      'borderColor': borderColor.value,
      'borderWidth': borderWidth,
      'borderRadius': {
        'topLeft': borderRadius.topLeft.x,
        'topRight': borderRadius.topRight.x,
        'bottomLeft': borderRadius.bottomLeft.x,
        'bottomRight': borderRadius.bottomRight.x,
      },
      'textAlign': textAlign.index,
      'padding': {
        'left': padding.left,
        'top': padding.top,
        'right': padding.right,
        'bottom': padding.bottom,
      },
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Create from JSON
  factory TextBox.fromJson(Map<String, dynamic> json) {
    return TextBox(
      id: json['id'] ?? const Uuid().v4(),
      position: Offset(
        (json['position']?['dx'] ?? 0.0).toDouble(),
        (json['position']?['dy'] ?? 0.0).toDouble(),
      ),
      size: Size(
        (json['size']?['width'] ?? 120.0).toDouble(),
        (json['size']?['height'] ?? 40.0).toDouble(),
      ),
      text: json['text'] ?? 'Text',
      textStyle: TextStyle(
        fontSize: (json['textStyle']?['fontSize'] ?? 16.0).toDouble(),
        color:
            json['textStyle']?['color'] != null
                ? Color(json['textStyle']['color'])
                : Colors.black,
        fontWeight:
            json['textStyle']?['fontWeight'] != null
                ? FontWeight.values[json['textStyle']['fontWeight']]
                : FontWeight.normal,
        fontStyle:
            json['textStyle']?['fontStyle'] != null
                ? FontStyle.values[json['textStyle']['fontStyle']]
                : FontStyle.normal,
        fontFamily: json['textStyle']?['fontFamily'],
      ),
      backgroundColor:
          json['backgroundColor'] != null
              ? Color(json['backgroundColor'])
              : Colors.transparent,
      hasBorder: json['hasBorder'] ?? false,
      borderColor:
          json['borderColor'] != null
              ? Color(json['borderColor'])
              : Colors.black,
      borderWidth: (json['borderWidth'] ?? 1.0).toDouble(),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(
          (json['borderRadius']?['topLeft'] ?? 0.0).toDouble(),
        ),
        topRight: Radius.circular(
          (json['borderRadius']?['topRight'] ?? 0.0).toDouble(),
        ),
        bottomLeft: Radius.circular(
          (json['borderRadius']?['bottomLeft'] ?? 0.0).toDouble(),
        ),
        bottomRight: Radius.circular(
          (json['borderRadius']?['bottomRight'] ?? 0.0).toDouble(),
        ),
      ),
      textAlign:
          json['textAlign'] != null
              ? TextAlign.values[json['textAlign']]
              : TextAlign.left,
      padding: EdgeInsets.only(
        left: (json['padding']?['left'] ?? 8.0).toDouble(),
        top: (json['padding']?['top'] ?? 8.0).toDouble(),
        right: (json['padding']?['right'] ?? 8.0).toDouble(),
        bottom: (json['padding']?['bottom'] ?? 8.0).toDouble(),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        json['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

/// Text box formatting options
class TextBoxFormat {
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final String? fontFamily;
  final Color backgroundColor;
  final bool hasBorder;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final TextAlign textAlign;

  const TextBoxFormat({
    this.fontSize = 16.0,
    this.textColor = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.fontFamily,
    this.backgroundColor = Colors.transparent,
    this.hasBorder = false,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.borderRadius = BorderRadius.zero,
    this.textAlign = TextAlign.left,
  });

  /// Create text style from format
  TextStyle get textStyle => TextStyle(
    fontSize: fontSize,
    color: textColor,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    fontFamily: fontFamily,
  );

  /// Create a copy with updated properties
  TextBoxFormat copyWith({
    double? fontSize,
    Color? textColor,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    String? fontFamily,
    Color? backgroundColor,
    bool? hasBorder,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    TextAlign? textAlign,
  }) {
    return TextBoxFormat(
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      fontFamily: fontFamily ?? this.fontFamily,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      hasBorder: hasBorder ?? this.hasBorder,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      textAlign: textAlign ?? this.textAlign,
    );
  }
}
