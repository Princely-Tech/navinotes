import 'package:flutter/material.dart';
import 'package:navinotes/models/board.dart';
import 'package:navinotes/models/mind_map_node.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/settings/navigation_helper.dart';

/// Reusable widget for displaying a mind map preview
///
/// Shows a visual preview of a board's mind map with:
/// - Simplified node visualization using CustomPainter
/// - Statistics overlay showing node and connection counts
/// - Click-to-navigate functionality to open the full mind map
/// - Professional card design with gradient overlay
///
/// Usage:
/// ```dart
/// MindMapPreview(
///   board: myBoard,
///   height: 140,
///   onTap: () => NavigationHelper.navigateToMindmap(myBoard),
/// )
/// ```
class MindMapPreview extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final mindMap = board.getOrCreateMindMap();
    final nodeCount = mindMap.nodes.length;
    final edgeCount = mindMap.edges.length;

    return GestureDetector(
      onTap: onTap ?? () => NavigationHelper.navigateToMindmap(board),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 120,
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
        child: Stack(
          children: [
            // Background pattern
            _buildBackgroundPattern(),

            // Mind map visualization
            if (nodeCount > 0) _buildMindMapVisualization(mindMap.nodes),

            // Overlay with stats and title
            _buildOverlay(nodeCount, edgeCount),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.ghostWhite, AppTheme.white],
        ),
      ),
    );
  }

  Widget _buildMindMapVisualization(List<MindMapNode> nodes) {
    return CustomPaint(
      size: Size.infinite,
      painter: MindMapPreviewPainter(nodes),
    );
  }

  Widget _buildOverlay(int nodeCount, int edgeCount) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          stops: const [0.5, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with icon
            Row(
              children: [
                Icon(
                  Icons.account_tree,
                  color: AppTheme.darkMossGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mind Map',
                  style: AppTheme.text.copyWith(
                    fontSize: 14.0,
                    fontWeight: getFontWeight(600),
                    color: AppTheme.black,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.0,
                  color: AppTheme.lightGray,
                ),
              ],
            ),

            const Spacer(),

            // Bottom section with stats
            Row(
              children: [
                _buildStat(nodeCount, 'Nodes', Icons.circle),
                const SizedBox(width: 16),
                _buildStat(edgeCount, 'Connections', Icons.linear_scale),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(int count, String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppTheme.white),
        const SizedBox(width: 4),
        Text(
          '$count $label',
          style: AppTheme.text.copyWith(
            fontSize: 12.0,
            color: AppTheme.white,
            fontWeight: getFontWeight(500),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for drawing a simplified mind map preview
class MindMapPreviewPainter extends CustomPainter {
  final List<MindMapNode> nodes;

  MindMapPreviewPainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.isEmpty) return;

    final paint =
        Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 1.5;

    final linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = AppTheme.lightGray;

    // Scale factor to fit nodes in preview
    final scaleX = size.width / 20000; // Assuming canvas is 20000 wide
    final scaleY = size.height / 15000; // Assuming canvas is 15000 tall
    final scale = (scaleX + scaleY) / 2;

    // Draw connections (simplified)
    for (int i = 0; i < nodes.length - 1; i++) {
      final node1 = nodes[i];
      final node2 = nodes[i + 1];

      final pos1 = Offset(node1.position.dx * scale, node1.position.dy * scale);
      final pos2 = Offset(node2.position.dx * scale, node2.position.dy * scale);

      canvas.drawLine(pos1, pos2, linePaint);
    }

    // Draw nodes
    for (final node in nodes) {
      final position = Offset(
        node.position.dx * scale,
        node.position.dy * scale,
      );

      // Ensure position is within bounds
      if (position.dx >= 0 &&
          position.dx <= size.width &&
          position.dy >= 0 &&
          position.dy <= size.height) {
        paint.color = node.color.withOpacity(0.8);
        canvas.drawCircle(position, 4, paint);

        // Draw border
        paint.color = node.color;
        paint.style = PaintingStyle.stroke;
        canvas.drawCircle(position, 4, paint);
        paint.style = PaintingStyle.fill;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
