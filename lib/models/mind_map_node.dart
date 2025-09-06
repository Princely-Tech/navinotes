import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MindMapNode {
  final String id;
  String text;
  Offset position;
  Color color;
  double width;
  double height;
  String? noteId; // Optional reference to a note

  MindMapNode({
    String? id,
    required this.text,
    required this.position,
    this.color = Colors.blue,
    this.width = 120.0,
    this.height = 60.0,
    this.noteId,
  }) : id = id ?? const Uuid().v4();

  factory MindMapNode.fromJson(Map<String, dynamic> json) => MindMapNode(
    id: json['id'],
    text: json['text'],
    position: Offset((json['x'] ?? 0).toDouble(), (json['y'] ?? 0).toDouble()),
    color: Color(json['color'] ?? Colors.blue.value),
    width: (json['width'] ?? 120.0).toDouble(),
    height: (json['height'] ?? 60.0).toDouble(),
    noteId: json['noteId'],
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
  };
}
