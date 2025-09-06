import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'mind_map_node.dart';
import 'mind_map_edge.dart';

class MindMap {
  final String id;
  String name;
  final List<MindMapNode> nodes;
  final List<MindMapEdge> edges;

  MindMap({
    String? id,
    required this.name,
    List<MindMapNode>? nodes,
    List<MindMapEdge>? edges,
  }) : id = id ?? const Uuid().v4(),
       nodes = nodes ?? [],
       edges = edges ?? [];

  factory MindMap.fromJson(Map<String, dynamic> json) => MindMap(
    id: json['id'],
    name: json['name'] ?? 'Untitled Mind Map',
    nodes:
        (json['nodes'] as List?)
            ?.map((e) => MindMapNode.fromJson(e))
            .toList() ??
        [],
    edges:
        (json['edges'] as List?)
            ?.map((e) => MindMapEdge.fromJson(e))
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nodes': nodes.map((e) => e.toJson()).toList(),
    'edges': edges.map((e) => e.toJson()).toList(),
  };

  // Add a new node
  MindMapNode addNode({
    required String text,
    required Offset position,
    Color color = Colors.blue,
    String? noteId,
  }) {
    final node = MindMapNode(
      text: text,
      position: position,
      color: color,
      noteId: noteId,
    );
    nodes.add(node);
    return node;
  }

  // Connect two nodes with an edge
  MindMapEdge connectNodes({
    required String sourceId,
    required String targetId,
    String? label,
  }) {
    final edge = MindMapEdge(
      sourceId: sourceId,
      targetId: targetId,
      label: label,
    );
    edges.add(edge);
    return edge;
  }

  // Remove a node and its connections
  void removeNode(String nodeId) {
    nodes.removeWhere((node) => node.id == nodeId);
    edges.removeWhere(
      (edge) => edge.sourceId == nodeId || edge.targetId == nodeId,
    );
  }

  // Remove an edge
  void removeEdge(String edgeId) {
    edges.removeWhere((edge) => edge.id == edgeId);
  }

  // Find a node by ID
  MindMapNode? findNode(String nodeId) {
    try {
      return nodes.firstWhere((node) => node.id == nodeId);
    } catch (e) {
      return null;
    }
  }

  // Find an edge by ID
  MindMapEdge? findEdge(String edgeId) {
    try {
      return edges.firstWhere((edge) => edge.id == edgeId);
    } catch (_) {
      return null;
    }
  }

  // Find all edges connected to a node
  List<MindMapEdge> findConnectedEdges(String nodeId) {
    return edges
        .where((edge) => edge.sourceId == nodeId || edge.targetId == nodeId)
        .toList();
  }
}
