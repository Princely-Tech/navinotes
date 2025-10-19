import 'package:flutter/material.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/screens/main/board_mindmap/board_mindmap_vm.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/settings/enums.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/widgets/content_preview_widget.dart';
import 'package:navinotes/widgets/index.dart';
import 'package:provider/provider.dart';

TextStyle get titleTextStyle => AppTheme.text.copyWith(
  color: AppTheme.wetAsphalt,
  fontWeight: getFontWeight(500),
  height: 1.43,
);

class MindMapContentPanel extends StatelessWidget {
  const MindMapContentPanel({super.key, required this.boardTheme});

  final BoardTheme boardTheme;

  @override
  Widget build(BuildContext context) {
    final themeValues = boardTheme.values;
    Color bgColor =
        themeValues.backgroundColor == AppTheme.transparent
            ? AppTheme.ghostWhite
            : themeValues.backgroundColor;

    return Consumer<BoardMindMapVm>(
      builder: (context, vm, child) {
        // Get selected node and its content
        final selectedNode =
            vm.selectedNodeId != null
                ? vm.mindMap.findNode(vm.selectedNodeId!)
                : null;
        final selectedContent =
            selectedNode?.contentID != null
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
              // Content area
              Expanded(
                child: ScrollableController(
                  mobilePadding: EdgeInsets.all(15),
                  child: Column(
                    spacing: 8,
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

              // Modern action footer with buttons and attachment info
              if (selectedNode != null)
                _buildActionFooter(
                  context,
                  vm,
                  selectedNode,
                  selectedContent,
                  themeValues,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _contentPreview(Content content, BoardMindMapVm vm) {
    return _section(
      title: 'Content Preview',
      child: Builder(
        builder: (context) {
          final dynamicHeight = MediaQuery.of(context).size.height - 310;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large content preview with dynamic height
              Container(
                height: dynamicHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                clipBehavior: Clip.antiAlias,
                child: ContentPreviewWidget(
                  key: ValueKey('preview_${content.id}'),
                  content: content,
                  isCompact: false,
                  width: double.infinity,
                  height: dynamicHeight,
                ),
              ),
              const SizedBox(height: 12),
              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => NavigationHelper.navigateToContent(content),
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('Open Content'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.steelBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _nodeInfo(dynamic selectedNode) {
    return _section(
      title: 'Node Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoCard([
            _infoRow('Type', 'MIND MAP NODE'),
            _infoRow(
              'Text',
              selectedNode.text.isNotEmpty ? selectedNode.text : 'No text',
            ),
            _infoRow(
              'Position',
              '${selectedNode.position.dx.toInt()}, ${selectedNode.position.dy.toInt()}',
            ),
          ]),
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

  // ============ Modern UI Components ============

  /// Professional action footer with buttons and attachment info
  Widget _buildActionFooter(
    BuildContext context,
    BoardMindMapVm vm,
    dynamic selectedNode,
    Content? selectedContent,
    dynamic themeValues,
  ) {
    final hasAttachment =
        selectedNode?.contentID != null && selectedNode!.contentID!.isNotEmpty;
    final isConnectingFrom = vm.connectingFromNodeId == selectedNode?.id;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with attachment indicator

          // Compact icon-only action buttons in single row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _iconOnlyButton(
                icon: isConnectingFrom ? Icons.close : Icons.link,
                tooltip: isConnectingFrom ? 'Cancel Link' : 'Connect',
                color:
                    isConnectingFrom
                        ? Colors.orange[600]!
                        : Colors.indigo[600]!,
                onTap: () {
                  if (isConnectingFrom) {
                    vm.cancelConnecting();
                  } else {
                    vm.startConnectingFrom(selectedNode.id);
                  }
                },
              ),
              _iconOnlyButton(
                icon: Icons.palette_outlined,
                tooltip: vm.isStylingPanelVisible ? 'Hide Design' : 'Design',
                color:
                    vm.isStylingPanelVisible
                        ? Colors.green[600]!
                        : Colors.teal[600]!,
                onTap: () => vm.toggleStylingPanel(),
              ),
              _iconOnlyButton(
                icon: Icons.edit,
                tooltip: 'Edit',
                color: Colors.purple[600]!,
                onTap: () => _editNodeText(context, vm, selectedNode),
              ),
              _iconOnlyButton(
                icon: Icons.delete_outline,
                tooltip: 'Delete',
                color: Colors.red[600]!,
                onTap:
                    () =>
                        vm.deleteNodeWithConfirmation(context, selectedNode.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Compact action button with icon and label
  Widget _iconOnlyButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(height: 4),
              Text(
                tooltip,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Modern info card with clean styling
  Widget _infoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// Modern info row with label and value
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Edit node text dialog
  Future<void> _editNodeText(
    BuildContext context,
    BoardMindMapVm vm,
    dynamic selectedNode,
  ) async {
    final textController = TextEditingController(text: selectedNode.text);
    final newText = await showDialog<String>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Edit Node Text'),
            content: TextField(
              controller: textController,
              autofocus: true,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter node text...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed:
                    () => Navigator.of(dialogContext).pop(textController.text),
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (newText != null && newText.trim().isNotEmpty) {
      await vm.updateNodeText(selectedNode.id, newText.trim());
    }
  }
}
