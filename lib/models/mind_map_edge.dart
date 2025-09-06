import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

enum EdgeLineType { straight, dashed, dotted, curved, elbow }

class MindMapEdge {
  final String id;
  final String sourceId;
  final String targetId;
  String? label;
  Color color;
  EdgeLineType lineType;
  double thickness; // stroke width
  double opacity; // 0..1

  MindMapEdge({
    String? id,
    required this.sourceId,
    required this.targetId,
    this.label,
    this.color = Colors.grey,
    this.lineType = EdgeLineType.straight,
    this.thickness = 2.0,
    this.opacity = 1.0,
  }) : id = id ?? const Uuid().v4();

  factory MindMapEdge.fromJson(Map<String, dynamic> json) => MindMapEdge(
    id: json['id'],
    sourceId: json['sourceId'],
    targetId: json['targetId'],
    label: json['label'],
    color: Color(json['color'] ?? Colors.grey.value),
    lineType:
        _edgeLineTypeFromString(json['lineType']) ?? EdgeLineType.straight,
    thickness: ((json['thickness'] ?? 2.0) as num).toDouble(),
    opacity: ((json['opacity'] ?? 1.0) as num).toDouble().clamp(0.0, 1.0),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'sourceId': sourceId,
    'targetId': targetId,
    'label': label,
    'color': color.value,
    'lineType': lineType.name,
    'thickness': thickness,
    'opacity': opacity,
  };
}

EdgeLineType? _edgeLineTypeFromString(dynamic v) {
  if (v == null) return null;
  try {
    final s = v.toString();
    return EdgeLineType.values.firstWhere((e) => e.name == s);
  } catch (_) {
    return null;
  }
}
