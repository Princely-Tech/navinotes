import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/note_page_content.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/page_settings_dialog.dart';

class MultiPageViewer extends StatefulWidget {
  final NoteCreationVm vm;
  final Color backgroundColor;
  final double inputWidth;
  final double inputHeight;

  const MultiPageViewer({
    Key? key,
    required this.vm,
    required this.backgroundColor,
    required this.inputWidth,
    required this.inputHeight,
  }) : super(key: key);

  @override
  State<MultiPageViewer> createState() => _MultiPageViewerState();
}

class _MultiPageViewerState extends State<MultiPageViewer>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _addPageAnimationController;
  late Animation<double> _addPageAnimation;

  bool _showAddPageIndicator = false;
  String _addPageDirection = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.vm.currentPageIndex,
      viewportFraction: 0.95, // Show slight preview of adjacent pages
    );

    _addPageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _addPageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _addPageAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _addPageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCreationVm>(
      builder: (context, vm, child) {
        return Expanded(
          child: Stack(
            children: [
              // Main PageView
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  vm.setCurrentPageIndex(index);
                },
                itemCount: vm.notePages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildPageWithZoomAndPan(vm.notePages[index], vm),
                  );
                },
              ),

              // Add page indicators
              if (_showAddPageIndicator) _buildAddPageIndicator(),

              // Page navigation controls
              _buildPageControls(vm),

              // Page indicator dots
              _buildPageIndicator(vm),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageWithZoomAndPan(NotePage page, NoteCreationVm vm) {
    // Calculate page dimensions based on format with better scaling
    final aspectRatio = page.format.aspectRatio;

    // Use screen dimensions as base, but maintain aspect ratio
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate optimal page size to fit screen while maintaining aspect ratio
    double pageWidth = screenWidth * 0.85; // Use 85% of screen width
    double pageHeight = pageWidth / aspectRatio;

    // If height is too large, scale down based on height
    final maxHeight = screenHeight * 0.75; // Use 75% of screen height
    if (pageHeight > maxHeight) {
      pageHeight = maxHeight;
      pageWidth = pageHeight * aspectRatio;
    }

    // Ensure minimum usable size
    pageWidth = math.max(pageWidth, 400.0);
    pageHeight = math.max(pageHeight, 500.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: vm.currentMode == NoteMode.read
            ? InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                constrained: false,
                child: Container(
                  width: pageWidth,
                  height: pageHeight,
                  child: NotePageContent(
                    page: page,
                    vm: vm,
                    backgroundColor: widget.backgroundColor,
                    inputWidth: pageWidth,
                    inputHeight: pageHeight,
                  ),
                ),
              )
            : Container(
                width: pageWidth,
                height: pageHeight,
                child: NotePageContent(
                  page: page,
                  vm: vm,
                  backgroundColor: widget.backgroundColor,
                  inputWidth: pageWidth,
                  inputHeight: pageHeight,
                ),
              ),
      ),
    );
  }

  Widget _buildAddPageIndicator() {
    return AnimatedBuilder(
      animation: _addPageAnimation,
      builder: (context, child) {
        return Positioned(
          top: 0,
          bottom: 0,
          left: _addPageDirection == 'left' ? 0 : null,
          right: _addPageDirection == 'right' ? 0 : null,
          child: Transform.scale(
            scale: _addPageAnimation.value,
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Release to\nadd page',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageControls(NoteCreationVm vm) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous page button
          if (vm.currentPageIndex > 0)
            FloatingActionButton.small(
              heroTag: "prev_page",
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: Colors.white.withOpacity(0.9),
              child: const Icon(Icons.chevron_left),
            )
          else
            const SizedBox(width: 40),

          // Page settings and add page buttons
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     FloatingActionButton.small(
          //       heroTag: "page_settings",
          //       onPressed: () => _showPageSettings(vm),
          //       backgroundColor: Colors.white.withOpacity(0.9),
          //       child: const Icon(Icons.settings),
          //     ),
          //     const SizedBox(width: 8),
          //     FloatingActionButton.small(
          //       heroTag: "add_page",
          //       onPressed: () => vm.addNewPage(),
          //       backgroundColor: Theme.of(context).primaryColor,
          //       child: const Icon(Icons.add, color: Colors.white),
          //     ),
          //   ],
          // ),

          // Next page button
          if (vm.currentPageIndex < vm.notePages.length - 1)
            FloatingActionButton.small(
              heroTag: "next_page",
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: Colors.white.withOpacity(0.9),
              child: const Icon(Icons.chevron_right),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(NoteCreationVm vm) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${vm.currentPageIndex + 1} / ${vm.notePages.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (vm.currentPage != null) ...[
                const SizedBox(width: 8),
                Text(
                  '• ${vm.currentPage!.format}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
              const SizedBox(width: 12),
              ...List.generate(
                vm.notePages.length.clamp(0, 5), // Show max 5 dots
                (index) {
                  final isActive = index == vm.currentPageIndex;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: isActive ? 8 : 6,
                    height: isActive ? 8 : 6,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.white54,
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
              if (vm.notePages.length > 5)
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: const Text(
                    '...',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPageSettings(NoteCreationVm vm) {
    if (vm.currentPage == null) return;

    showDialog(
      context: context,
      builder:
          (context) => PageSettingsDialog(
            currentFormat: vm.currentPage!.format,
            onFormatChanged: (newFormat) {
              vm.updateCurrentPageFormat(newFormat);
            },
          ),
    );
  }
}
