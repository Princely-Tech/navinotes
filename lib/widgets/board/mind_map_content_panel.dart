import 'package:flutter/material.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/screens/main/board_mindmap/vm.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/content_preview_widget.dart';
import 'package:navinotes/widgets/index.dart';
import 'package:provider/provider.dart';

TextStyle get titleTextStyle => AppTheme.text.copyWith(
      color: AppTheme.wetAsphalt,
      fontWeight: getFontWeight(500),
      height: 1.43,
    );

class MindMapContentPanel extends StatelessWidget {
  const MindMapContentPanel({
    super.key,
    required this.boardTheme,
  });

  final BoardTheme boardTheme;

  @override
  Widget build(BuildContext context) {
    final themeValues = boardTheme.values;
    Color bgColor = themeValues.backgroundColor == AppTheme.transparent
        ? AppTheme.ghostWhite
        : themeValues.backgroundColor;

    return Consumer<MindMapVm>(
      builder: (context, vm, child) {
        // Get selected node and its content
        final selectedNode = vm.selectedNodeId != null
            ? vm.mindMap.findNode(vm.selectedNodeId!)
            : null;
        final selectedContent = selectedNode?.contentID != null
            ? vm.getContentById(selectedNode!.contentID!)
            : null;

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(left: BorderSide(color: themeValues.borderColor)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ScrollableController(
                  mobilePadding: EdgeInsets.all(15),
                  child: Column(
                    spacing: 30,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show content preview if node is selected and has content
                      if (selectedContent != null &&
                          selectedContent.type != AppContentType.mindmapNode)
                        _contentPreview(selectedContent, vm)
                      else if (selectedNode != null)
                        _nodeInfo(selectedNode)
                      else
                        _noSelectionMessage(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _contentPreview(Content content, MindMapVm vm) {
    return _section(
      title: 'Content Preview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large content preview
          ContentPreviewWidget(
            content: content,
            isCompact: false,
            width: double.infinity,
            height: 300,
          ),
          const SizedBox(height: 16),
          // Content details
          Text('Type: ${content.type.name}', style: titleTextStyle),
          const SizedBox(height: 8),
          Text('Title: ${content.title}', style: titleTextStyle),
          const SizedBox(height: 8),
          if (content.tags != null && content.tags!.isNotEmpty)
            Text('Tags: ${content.tags}', style: titleTextStyle),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onTap: () {
                    // TODO: Open content for editing
                  },
                  text: 'Edit Content',
                  color: AppTheme.steelBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  onTap: () {
                    // Remove content attachment from node
                    if (vm.selectedNodeId != null) {
                      vm.removeAttachmentFromNode(vm.selectedNodeId!);
                    }
                  },
                  text: 'Detach',
                  color: AppTheme.coralRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nodeInfo(dynamic selectedNode) {
    return _section(
      title: 'Node Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Node Type: Mind Map Node', style: titleTextStyle),
          const SizedBox(height: 8),
          Text('Text: ${selectedNode.text}', style: titleTextStyle),
          const SizedBox(height: 16),
          AppButton(
            onTap: () {
              // TODO: Edit node text
            },
            text: 'Edit Node',
            color: AppTheme.steelBlue,
          ),
        ],
      ),
    );
  }

  Widget _noSelectionMessage() {
    return _section(
      title: 'Content Preview',
      child: Column(
        children: [
          Icon(Icons.touch_app, size: 48, color: AppTheme.asbestos),
          const SizedBox(height: 16),
          Text(
            'Select a node to view its content',
            style: titleTextStyle.copyWith(
              fontSize: 14,
              color: AppTheme.asbestos,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.wetAsphalt,
            fontWeight: getFontWeight(500),
            height: 1.43,
          ),
        ),
        child,
      ],
    );
  }
}
