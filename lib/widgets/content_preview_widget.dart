import 'package:flutter/material.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/widgets/content_compact_preview_widget.dart';
import 'package:navinotes/widgets/content_full_preview_widget.dart';

/// Reusable widget for previewing different content types
/// Used in mind map nodes and right panel previews
class ContentPreviewWidget extends StatelessWidget {
  final Content content;
  final bool isCompact; // For small previews in mind map nodes
  final double? width;
  final double? height;

  const ContentPreviewWidget({
    super.key,
    required this.content,
    this.isCompact = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return isCompact ? ContentCompactPreviewWidget(
      content: content,
      width: width,
      height: height,
    ) : ContentFullPreviewWidget(
      content: content,
      width: width,
      height: height,
    );
  }
}
