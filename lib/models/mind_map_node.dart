import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum MindMapBorderStyle { shadow, border, glow, none }

/// Node geometric shape
enum MindMapShape {
  rounded,
  sharp,
  pill,
  circle,
  diamond,
  hexagon,
  parallelogram,
  octagon,
  trapezoid,
}

class MindMapNode {
  final String id;
  String text;
  Offset position;
  Color color;
  double width;
  double height;
  String? noteId; // Optional reference to a note

  // Styling
  Color textColor;
  double fontSize;
  int fontWeight; // store as numeric weight (e.g., 300, 400, 500, 600)
  String? fontFamily;
  double opacity; // 0..1
  double colorTone; // -1..1 cooler..warmer (hue shift)
  MindMapBorderStyle borderStyle;
  double borderRadius; // corner radius
  MindMapShape shape;

  MindMapNode({
    String? id,
    required this.text,
    required this.position,
    this.color = Colors.blue,
    this.width = 120.0,
    this.height = 60.0,
    this.noteId,
    this.textColor = Colors.white,
    this.fontSize = 14.0,
    this.fontWeight = 500,
    this.fontFamily,
    this.opacity = 1.0,
    this.colorTone = 0.0,
    this.borderStyle = MindMapBorderStyle.shadow,
    this.borderRadius = 8.0,
    this.shape = MindMapShape.rounded,
  }) : id = id ?? const Uuid().v4();

  factory MindMapNode.fromJson(Map<String, dynamic> json) => MindMapNode(
    id: json['id'],
    text: json['text'],
    position: Offset((json['x'] ?? 0).toDouble(), (json['y'] ?? 0).toDouble()),
    color: Color(json['color'] ?? Colors.blue.value),
    width: (json['width'] ?? 120.0).toDouble(),
    height: (json['height'] ?? 60.0).toDouble(),
    noteId: json['noteId'],
    textColor: Color(json['textColor'] ?? Colors.white.value),
    fontSize: (json['fontSize'] ?? 14.0).toDouble(),
    fontWeight: (json['fontWeight'] ?? 500) as int,
    fontFamily: json['fontFamily'],
    opacity: ((json['opacity'] ?? 1.0) as num).toDouble().clamp(0.0, 1.0),
    colorTone: ((json['colorTone'] ?? 0.0) as num).toDouble().clamp(-1.0, 1.0),
    borderStyle:
        _borderStyleFromString(json['borderStyle']) ??
        MindMapBorderStyle.shadow,
    borderRadius: (json['borderRadius'] ?? 8.0).toDouble(),
    shape: _shapeFromString(json['shape']) ?? MindMapShape.rounded,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'x': position.dx,
    'y': position.dy,
    'color': color.value,
    'width': width,
    'height': height,
    'noteId': noteId,
    'textColor': textColor.value,
    'fontSize': fontSize,
    'fontWeight': fontWeight,
    'fontFamily': fontFamily,
    'opacity': opacity,
    'colorTone': colorTone,
    'borderStyle': borderStyle.name,
    'borderRadius': borderRadius,
    'shape': shape.name,
  };
}

MindMapBorderStyle? _borderStyleFromString(dynamic v) {
  if (v == null) return null;
  try {
    final s = v.toString();
    return MindMapBorderStyle.values.firstWhere((e) => e.name == s);
  } catch (_) {
    return null;
  }
}

MindMapShape? _shapeFromString(dynamic v) {
  if (v == null) return null;
  try {
    final s = v.toString();
    return MindMapShape.values.firstWhere((e) => e.name == s);
  } catch (_) {
    return null;
  }
}
