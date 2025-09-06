import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MindMapEdge {
  final String id;
  final String sourceId;
  final String targetId;
  String? label;
  Color color;

  MindMapEdge({
    String? id,
    required this.sourceId,
    required this.targetId,
    this.label,
    this.color = Colors.grey,
  }) : id = id ?? const Uuid().v4();

  factory MindMapEdge.fromJson(Map<String, dynamic> json) => MindMapEdge(
    id: json['id'],
    sourceId: json['sourceId'],
    targetId: json['targetId'],
    label: json['label'],
    color: Color(json['color'] ?? Colors.grey.value),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'sourceId': sourceId,
    'targetId': targetId,
    'label': label,
    'color': color.value,
  };
}
