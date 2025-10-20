import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:navinotes/models/board.dart';
import 'package:navinotes/models/mind_map_node.dart';
import 'package:navinotes/models/mind_map.dart';
import 'package:navinotes/models/mind_map_edge.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/settings/navigation_helper.dart';

/// Reusable widget for displaying a live mind map preview
///
/// Shows the actual mind map canvas content in a clipped, read-only format:
/// - Real mind map nodes and connections
/// - Scaled to fit within preview bounds
/// - Click-to-navigate functionality to open the full mind map
/// - Uses actual content from the database
///
/// Usage:
/// ```dart
/// MindMapPreview(
///   board: myBoard,
///   height: 140,
///   onTap: () => NavigationHelper.navigateToMindmap(myBoard),
/// )
/// ```
class MindMapPreview extends StatefulWidget {
  final Board board;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const MindMapPreview({
    super.key,
    required this.board,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  State<MindMapPreview> createState() => _MindMapPreviewState();
}

class _MindMapPreviewState extends State<MindMapPreview> {
  MindMap? _mindMap;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMindMap();
  }

  Future<void> _loadMindMap() async {
    try {
      // Load board contents
      final contents = await DatabaseHelper.instance.getAllContents(
        widget.board.id,
      );

      // Create mind map from content (similar to BoardMindMapVm logic)
      final mindMap = MindMap(name: '${widget.board.name} Mind Map');

      for (final content in contents) {
        // Create mind map node from content
        final node = _createNodeFromContent(content);
        mindMap.nodes.add(node);
      }

      // Load connections (simplified - can be enhanced later)
      await _loadContentConnections(mindMap, contents);

      if (mounted) {
        setState(() {
          _mindMap = mindMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading mind map for preview: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  MindMapNode _createNodeFromContent(Content content) {
    // Default position if not set
    Offset position = content.mindMapPosition ?? const Offset(10000, 7500);

    return MindMapNode(
      id: content.id,
      text: content.title.isNotEmpty ? content.title : 'Untitled',
      position: position,
      color:
          _parseColor(content.nodeColor) ??
          _getNodeColorForContentType(content.type),
      width: content.nodeWidth ?? 200.0,
      height: content.nodeHeight ?? 100.0,
    );
  }

  Future<void> _loadContentConnections(
    MindMap mindMap,
    List<Content> contents,
  ) async {
    for (final content in contents) {
      if (content.connectedContentIds != null &&
          content.connectedContentIds!.isNotEmpty) {
        try {
          final connectionIds = List<String>.from(
            jsonDecode(content.connectedContentIds!),
          );

          for (final targetId in connectionIds) {
            // Check if target node exists in mind map
            final targetExists = mindMap.nodes.any((n) => n.id == targetId);

            if (targetExists) {
              // Check if edge already exists (to avoid duplicates)
              final edgeExists = mindMap.edges.any(
                (e) =>
                    (e.sourceId == content.id && e.targetId == targetId) ||
                    (e.sourceId == targetId && e.targetId == content.id),
              );

              if (!edgeExists) {
                mindMap.edges.add(
                  MindMapEdge(sourceId: content.id, targetId: targetId),
                );
              }
            }
          }
        } catch (e) {
          debugPrint('Error parsing connections for ${content.id}: $e');
        }
      }
    }
  }

  Color? _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return null;
    try {
      return Color(int.parse(colorStr.replaceFirst('#', '0x')));
    } catch (e) {
      return null;
    }
  }

  Color _getNodeColorForContentType(AppContentType type) {
    switch (type) {
      case AppContentType.note:
        return Colors.blue;
      case AppContentType.file:
        return Colors.green;
      case AppContentType.flashcardDeck:
        return Colors.purple;
      case AppContentType.mindmapNode:
        return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          widget.onTap ??
          () => NavigationHelper.navigateToMindmap(widget.board),
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 200,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.lightGray, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : _buildMindMapCanvas(),
        ),
      ),
    );
  }

  Widget _buildMindMapCanvas() {
    if (_mindMap == null || _mindMap!.nodes.isEmpty) {
      return Center(
        child: Text(
          'No mind map content',
          style: AppTheme.text.copyWith(
            color: AppTheme.blueGray,
            fontSize: 14.0,
          ),
        ),
      );
    }

    return _MindMapPreviewCanvas(mindMap: _mindMap!);
  }
}

/// Read-only canvas widget for mind map preview
class _MindMapPreviewCanvas extends StatelessWidget {
  final MindMap mindMap;

  const _MindMapPreviewCanvas({required this.mindMap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the scale to fit all nodes in the preview
        final scale = _calculateOptimalScale(constraints.biggest);

        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: AppTheme.ghostWhite,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Draw edges first (below nodes)
              if (mindMap.edges.isNotEmpty)
                CustomPaint(
                  size: constraints.biggest,
                  painter: _PreviewEdgePainter(
                    mindMap.edges,
                    mindMap.nodes,
                    scale,
                    constraints.biggest,
                  ),
                ),

              // Draw nodes
              for (final node in mindMap.nodes)
                _buildScaledNode(node, scale, constraints.biggest),
            ],
          ),
        );
      },
    );
  }

  double _calculateOptimalScale(Size previewSize) {
    if (mindMap.nodes.isEmpty) return 1.0;

    // Find bounding box of all nodes
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final node in mindMap.nodes) {
      minX = math.min(minX, node.position.dx);
      minY = math.min(minY, node.position.dy);
      maxX = math.max(maxX, node.position.dx + node.width);
      maxY = math.max(maxY, node.position.dy + node.height);
    }

    final contentWidth = maxX - minX;
    final contentHeight = maxY - minY;

    // Add padding (10% of preview size)
    final paddingX = previewSize.width * 0.1;
    final paddingY = previewSize.height * 0.1;
    final availableWidth = previewSize.width - (paddingX * 2);
    final availableHeight = previewSize.height - (paddingY * 2);

    // Calculate scale to fit all content
    final scaleX = availableWidth / contentWidth;
    final scaleY = availableHeight / contentHeight;

    return math
        .min(scaleX, scaleY)
        .clamp(0.005, 1.0); // Allow much smaller scale for zoom out
  }

  Rect _getContentBounds() {
    if (mindMap.nodes.isEmpty) return const Rect.fromLTWH(0, 0, 1, 1);

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final node in mindMap.nodes) {
      minX = math.min(minX, node.position.dx);
      minY = math.min(minY, node.position.dy);
      maxX = math.max(maxX, node.position.dx + node.width);
      maxY = math.max(maxY, node.position.dy + node.height);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  Widget _buildScaledNode(MindMapNode node, double scale, Size previewSize) {
    // Calculate content bounds for centering
    final contentBounds = _getContentBounds();
    final contentCenter = Offset(
      (contentBounds.left + contentBounds.right) / 2,
      (contentBounds.top + contentBounds.bottom) / 2,
    );
    final previewCenter = Offset(previewSize.width / 2, previewSize.height / 2);

    // Calculate offset to center content in preview
    final centerOffset =
        previewCenter -
        Offset(contentCenter.dx * scale, contentCenter.dy * scale);

    final scaledWidth = node.width * scale;
    final scaledHeight = node.height * scale;
    final scaledPosition = Offset(
      (node.position.dx * scale) + centerOffset.dx,
      (node.position.dy * scale) + centerOffset.dy,
    );

    // Only show nodes that are visible in preview
    if (scaledPosition.dx + scaledWidth >= 0 &&
        scaledPosition.dy + scaledHeight >= 0 &&
        scaledPosition.dx < previewSize.width &&
        scaledPosition.dy < previewSize.height) {
      return Positioned(
        left: scaledPosition.dx,
        top: scaledPosition.dy,
        width: scaledWidth,
        height: scaledHeight,
        child: Container(
          decoration: BoxDecoration(
            color: node.color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(4 * scale),
            border: Border.all(
              color: node.color.withOpacity(1.0),
              width: 1 * scale,
            ),
          ),
          child: Center(
            child: Text(
              node.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: (12.0 * scale).clamp(6, 16),
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Custom painter for drawing edges in the preview
class _PreviewEdgePainter extends CustomPainter {
  final List<MindMapEdge> edges;
  final List<MindMapNode> nodes;
  final double scale;
  final Size previewSize;

  _PreviewEdgePainter(this.edges, this.nodes, this.scale, this.previewSize);

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.0, 2 * scale)
          ..color = AppTheme.blueGray.withOpacity(0.6);

    // Calculate content bounds and center offset (same logic as nodes)
    final contentBounds = _getContentBounds();
    final contentCenter = Offset(
      (contentBounds.left + contentBounds.right) / 2,
      (contentBounds.top + contentBounds.bottom) / 2,
    );
    final previewCenter = Offset(previewSize.width / 2, previewSize.height / 2);
    final centerOffset =
        previewCenter -
        Offset(contentCenter.dx * scale, contentCenter.dy * scale);

    for (final edge in edges) {
      final sourceNode = nodes.cast<MindMapNode?>().firstWhere(
        (n) => n?.id == edge.sourceId,
        orElse: () => null,
      );
      final targetNode = nodes.cast<MindMapNode?>().firstWhere(
        (n) => n?.id == edge.targetId,
        orElse: () => null,
      );

      if (sourceNode != null && targetNode != null) {
        final sourceCenter = Offset(
          ((sourceNode.position.dx + sourceNode.width / 2) * scale) +
              centerOffset.dx,
          ((sourceNode.position.dy + sourceNode.height / 2) * scale) +
              centerOffset.dy,
        );
        final targetCenter = Offset(
          ((targetNode.position.dx + targetNode.width / 2) * scale) +
              centerOffset.dx,
          ((targetNode.position.dy + targetNode.height / 2) * scale) +
              centerOffset.dy,
        );

        canvas.drawLine(sourceCenter, targetCenter, paint);
      }
    }
  }

  Rect _getContentBounds() {
    if (nodes.isEmpty) return const Rect.fromLTWH(0, 0, 1, 1);

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final node in nodes) {
      minX = math.min(minX, node.position.dx);
      minY = math.min(minY, node.position.dy);
      maxX = math.max(maxX, node.position.dx + node.width);
      maxY = math.max(maxY, node.position.dy + node.height);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
