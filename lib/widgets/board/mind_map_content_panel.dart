import 'package:flutter/material.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/screens/main/board_mindmap/board_mindmap_vm.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/settings/enums.dart';
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
                    spacing: 20,
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
                _buildActionFooter(context, vm, selectedNode, selectedContent, themeValues),
            ],
          ),
        );
      },
    );
  }

  Widget _contentPreview(Content content, BoardMindMapVm vm) {
    return _section(
      title: 'Content Preview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large content preview
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: ContentPreviewWidget(
              content: content,
              isCompact: false,
              width: double.infinity,
              height: 280,
            ),
          ),
          const SizedBox(height: 16),
          // Content details with modern styling
          _infoCard([
            _infoRow('Type', content.type.name.toUpperCase()),
            _infoRow('Title', content.title),
            if (content.tags != null && content.tags!.isNotEmpty)
              _infoRow('Tags', content.tags!),
          ]),
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
          _infoCard([
            _infoRow('Type', 'MIND MAP NODE'),
            _infoRow('Text', selectedNode.text.isNotEmpty ? selectedNode.text : 'No text'),
            _infoRow('Position', '${selectedNode.position.dx.toInt()}, ${selectedNode.position.dy.toInt()}'),
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
  Widget _buildActionFooter(BuildContext context, BoardMindMapVm vm, dynamic selectedNode, Content? selectedContent, dynamic themeValues) {
    final hasAttachment = selectedNode?.contentID != null && selectedNode!.contentID!.isNotEmpty;
    final isConnectingFrom = vm.connectingFromNodeId == selectedNode?.id;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with attachment indicator
          Row(
            children: [
              if (hasAttachment)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[300]!, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.attach_file, size: 16, color: Colors.green[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Attached',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Text(
                'NODE ACTIONS',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Professional action buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _modernActionButton(
                icon: hasAttachment ? Icons.link_off : Icons.attach_file,
                label: hasAttachment ? 'Detach' : 'Attach',
                color: hasAttachment ? Colors.red[600]! : Colors.blue[600]!,
                onTap: () {
                  if (hasAttachment) {
                    vm.removeAttachmentFromNode(selectedNode.id);
                  } else {
                    vm.startAttachToNode(selectedNode.id);
                    // Open documents sidebar
                    (context.findAncestorWidgetOfExactType<Scaffold>()?.key as GlobalKey<ScaffoldState>?)?.currentState?.openDrawer();
                  }
                },
              ),
              _modernActionButton(
                icon: isConnectingFrom ? Icons.close : Icons.link,
                label: isConnectingFrom ? 'Cancel Link' : 'Connect',
                color: isConnectingFrom ? Colors.orange[600]! : Colors.indigo[600]!,
                onTap: () {
                  if (isConnectingFrom) {
                    vm.cancelConnecting();
                  } else {
                    vm.startConnectingFrom(selectedNode.id);
                  }
                },
              ),
              _modernActionButton(
                icon: Icons.palette_outlined,
                label: vm.isStylingPanelVisible ? 'Hide Design' : 'Design',
                color: vm.isStylingPanelVisible ? Colors.green[600]! : Colors.teal[600]!,
                onTap: () => vm.toggleStylingPanel(),
              ),
              _modernActionButton(
                icon: Icons.edit,
                label: 'Edit',
                color: Colors.purple[600]!,
                onTap: () => _editNodeText(context, vm, selectedNode),
              ),
              _modernActionButton(
                icon: Icons.delete_outline,
                label: 'Delete',
                color: Colors.red[600]!,
                onTap: () => vm.deleteNodeWithConfirmation(context, selectedNode.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Modern action button with clean design
  Widget _modernActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
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
  Future<void> _editNodeText(BuildContext context, BoardMindMapVm vm, dynamic selectedNode) async {
    final textController = TextEditingController(text: selectedNode.text);
    final newText = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.of(dialogContext).pop(textController.text),
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
