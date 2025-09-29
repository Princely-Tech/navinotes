import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/note_page_content.dart';
import 'package:navinotes/packages.dart';

class PageNavigator extends StatefulWidget {
  final NoteCreationVm vm;
  final VoidCallback onClose;

  const PageNavigator({Key? key, required this.vm, required this.onClose})
    : super(key: key);

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  Set<String> selectedPageIds = {};
  bool isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Pages grid
          Expanded(child: _buildPagesGrid()),

          // Selection actions (shown when in selection mode)
          if (isSelectionMode) _buildSelectionActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (isSelectionMode) ...[
            IconButton(
              onPressed: _exitSelectionMode,
              icon: const Icon(Icons.close),
            ),
            const SizedBox(width: 8),
            Text(
              '${selectedPageIds.length} selected',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ] else ...[
            const Text(
              'Pages',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPagesGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: widget.vm.notePages.length,
        itemBuilder: (context, index) {
          final page = widget.vm.notePages[index];
          final isSelected = selectedPageIds.contains(page.id);
          final isCurrent = index == widget.vm.currentPageIndex;

          return _buildPageThumbnail(page, index, isSelected, isCurrent);
        },
      ),
    );
  }

  Widget _buildPageThumbnail(
    NotePage page,
    int index,
    bool isSelected,
    bool isCurrent,
  ) {
    return GestureDetector(
      onTap: () => _onPageTap(page, index),
      onLongPress: () => _onPageLongPress(page),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isCurrent
                    ? Colors.blue
                    : isSelected
                    ? Colors.red
                    : Colors.grey.shade300,
            width:
                isCurrent
                    ? 3
                    : isSelected
                    ? 2
                    : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Page thumbnail
              _buildPageThumbnailContent(page),

              // Selection overlay
              if (isSelected)
                Container(
                  color: Colors.red.withOpacity(0.2),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ),

              // Current page indicator
              if (isCurrent && !isSelectionMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Current',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Page number
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageThumbnailContent(NotePage page) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: _buildFullSizeThumbnail(page),
    );
  }

  Widget _buildFullSizeThumbnail(NotePage page) {
    // Get the actual page dimensions to calculate the proper scale
    final pageDimensions = page.format.actualDimensions;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate scale to fill the available space while maintaining aspect ratio
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        final scaleX = availableWidth / pageDimensions.width;
        final scaleY = availableHeight / pageDimensions.height;

        // Use the smaller scale to ensure the page fits entirely
        final scale = math.min(scaleX, scaleY);

        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: pageDimensions.width,
              height: pageDimensions.height,
              child: IgnorePointer(
                child: NotePageContent(
                  key: ValueKey('thumbnail_${page.id}'),
                  page: page,
                  vm: widget.vm,
                  backgroundColor: Colors.white,
                  inputWidth: pageDimensions.width,
                  inputHeight: pageDimensions.height,
                  isThumbnail: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: selectedPageIds.isEmpty ? null : _deleteSelectedPages,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.delete),
              label: Text('Delete ${selectedPageIds.length} page(s)'),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: _exitSelectionMode,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _onPageTap(NotePage page, int index) {
    if (isSelectionMode) {
      _togglePageSelection(page.id);
    } else {
      // Navigate to the selected page
      widget.vm.setCurrentPageIndex(index);
      widget.onClose();
    }
  }

  void _onPageLongPress(NotePage page) {
    if (!isSelectionMode) {
      setState(() {
        isSelectionMode = true;
        selectedPageIds.add(page.id);
      });
    } else {
      _togglePageSelection(page.id);
    }
  }

  void _togglePageSelection(String pageId) {
    setState(() {
      if (selectedPageIds.contains(pageId)) {
        selectedPageIds.remove(pageId);
        if (selectedPageIds.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        selectedPageIds.add(pageId);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
      selectedPageIds.clear();
    });
  }

  void _deleteSelectedPages() {
    if (selectedPageIds.isEmpty) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Pages'),
            content: Text(
              'Are you sure you want to delete ${selectedPageIds.length} page(s)? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _confirmDeletePages();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _confirmDeletePages() {
    // Get indices of pages to delete and sort in descending order
    final indicesToDelete = <int>[];

    for (final pageId in selectedPageIds) {
      final index = widget.vm.notePages.indexWhere((page) => page.id == pageId);
      if (index != -1) {
        indicesToDelete.add(index);
      }
    }

    // Sort indices in descending order to delete from highest to lowest
    // This prevents index shifting issues when deleting multiple pages
    indicesToDelete.sort((a, b) => b.compareTo(a));

    // Delete pages from highest index to lowest
    for (final index in indicesToDelete) {
      widget.vm.deletePage(index);
    }

    final deletedCount = indicesToDelete.length;
    _exitSelectionMode();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted $deletedCount page(s)'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
