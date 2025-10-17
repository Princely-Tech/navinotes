import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/screens/main/note_template/read/vm.dart';
import 'package:navinotes/screens/main/note_template/read/widget/note_page_content.dart';
import 'package:navinotes/screens/main/note_template/read/widget/page_navigator.dart';
import 'package:navinotes/screens/main/note_template/read/widget/voice.dart';
import 'package:navinotes/packages.dart';

class MultiPageViewer extends StatefulWidget {
  final NoteReadVm vm;
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
  final Map<String, TransformationController> _transformationControllers = {};
  final Map<String, bool> _zoomStates = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.vm.currentPageIndex,
      viewportFraction: 0.95, // Show slight preview of adjacent pages
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Dispose all transformation controllers
    for (final controller in _transformationControllers.values) {
      controller.dispose();
    }
    _transformationControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteReadVm>(
      builder: (context, vm, child) {
        // Sync PageController with ViewModel's current page index
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients &&
              _pageController.page?.round() != vm.currentPageIndex) {
            _pageController.animateToPage(
              vm.currentPageIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });

        return Stack(
          children: [
            // Main PageView - always present to maintain controller connection
            PageView.builder(
              controller: _pageController,
              physics:
                  _isZoomedOut(vm) || vm.currentMode == NoteMode.drawing
                      ? const NeverScrollableScrollPhysics()
                      : const PageScrollPhysics(),
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

            // Overlay voice recorder when in voice mode
            if (vm.currentMode == NoteMode.voice)
              buildVoiceRecorder(vm, widget.backgroundColor, context),

            // Page navigation controls
            if (vm.currentMode != NoteMode.voice) _buildPageControls(vm),

            // Page indicator dots
            if (vm.currentMode != NoteMode.voice) _buildPageIndicator(vm),

            // Mode toggle button - always visible
            _buildModeToggle(vm),
          ],
        );
      },
    );
  }

  TransformationController _getTransformationController(String pageId) {
    if (!_transformationControllers.containsKey(pageId)) {
      final controller = TransformationController();

      // Add listener to trigger rebuilds when zoom changes
      controller.addListener(() {
        if (mounted) {
          setState(() {
            // Trigger rebuild to check if we should switch view modes
          });
        }
      });

      _transformationControllers[pageId] = controller;
      _zoomStates[pageId] = false;

      // Center the page on initial load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerPage(pageId);
      });
    }
    return _transformationControllers[pageId]!;
  }

  void _centerPage(String pageId) {
    final controller = _transformationControllers[pageId];
    if (controller != null) {
      // Reset to identity matrix (centered and at scale 1.0)
      controller.value = Matrix4.identity();
    }
  }

  void _handleDoubleTap(NotePage page) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pageDimensions = page.format.actualDimensions;
    final controller = _getTransformationController(page.id);
    final isZoomedToFit = _zoomStates[page.id] ?? false;

    // Calculate the scale needed to fit page width to screen width
    final fitToWidthScale = (screenWidth * 0.9) / pageDimensions.width;

    if (isZoomedToFit) {
      // Zoom out to actual size (scale = 1.0) and center
      controller.value = Matrix4.identity();
      _zoomStates[page.id] = false;
    } else {
      // Zoom to fit width if page is smaller than screen
      final currentScale = controller.value.getMaxScaleOnAxis();
      if (currentScale < fitToWidthScale) {
        final matrix = Matrix4.identity()..scale(fitToWidthScale);
        controller.value = matrix;
        _zoomStates[page.id] = true;
      }
    }
  }

  void _zoomIn(NotePage page) {
    final controller = _getTransformationController(page.id);
    final currentScale = controller.value.getMaxScaleOnAxis();
    final newScale = (currentScale * 1.2).clamp(0.5, 3.0);

    final matrix = Matrix4.identity()..scale(newScale);
    controller.value = matrix;

    // Update zoom state
    _zoomStates[page.id] = newScale > 1.0;
  }

  void _zoomOut(NotePage page) {
    final controller = _getTransformationController(page.id);
    final currentScale = controller.value.getMaxScaleOnAxis();
    final newScale = (currentScale / 1.2).clamp(0.5, 3.0);

    if (newScale <= 1.0) {
      // If zooming to 1.0x or less, center the page
      controller.value = Matrix4.identity()..scale(newScale);
    } else {
      // For scales above 1.0x, maintain current position
      final matrix = Matrix4.identity()..scale(newScale);
      controller.value = matrix;
    }

    // Update zoom state
    _zoomStates[page.id] = newScale > 1.0;
  }

  double _getCurrentScale(NotePage page) {
    final controller = _getTransformationController(page.id);
    return controller.value.getMaxScaleOnAxis();
  }

  bool _isZoomedOut(NoteReadVm vm) {
    // Check if current page is zoomed out (< 1.0x)
    if (vm.currentPage != null) {
      final currentScale = _getCurrentScale(vm.currentPage!);
      return currentScale < 1.0;
    }
    return false;
  }

  Widget _buildPageWithZoomAndPan(NotePage page, NoteReadVm vm) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get actual page dimensions from format (in points)
    final pageDimensions = page.format.actualDimensions;

    // Calculate display scale to fit page on screen while maintaining aspect ratio
    final maxDisplayWidth = screenWidth * 0.85;
    final maxDisplayHeight = screenHeight * 0.75;

    double displayScale = math.min(
      maxDisplayWidth / pageDimensions.width,
      maxDisplayHeight / pageDimensions.height,
    );

    // Ensure minimum readable scale
    displayScale = math.max(displayScale, 0.3);

    // Use scaled dimensions for the container to ensure proper layout/centering
    final displayWidth = pageDimensions.width * displayScale;
    final displayHeight = pageDimensions.height * displayScale;

    // Canvas background (carton/desk color)
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
      width: screenWidth * 0.95,
      height: screenHeight * 0.8,
      decoration: BoxDecoration(
        color: AppTheme.lightAsh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: GestureDetector(
          onDoubleTap: () => _handleDoubleTap(page),
          child: InteractiveViewer(
            transformationController: _getTransformationController(page.id),
            minScale: 0.5,
            maxScale: 3.0,
            constrained: false,
            clipBehavior: Clip.none,
            panEnabled: vm.currentMode != NoteMode.drawing,
            scaleEnabled: true,
            boundaryMargin:
                _getCurrentScale(page) < 1.0
                    ? const EdgeInsets.all(double.infinity)
                    : const EdgeInsets.all(50),
            child: Container(
              width: displayWidth,
              height: displayHeight,
              child: Transform.scale(
                scale: displayScale,
                child: Container(
                  width: pageDimensions.width,
                  height: pageDimensions.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: NotePageContent(
                      page: page,
                      vm: vm,
                      backgroundColor: Colors.white,
                      inputWidth: pageDimensions.width,
                      inputHeight: pageDimensions.height,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageControls(NoteReadVm vm) {
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

          // Spacer for center
          const SizedBox(width: 40),

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

  Widget _buildPageIndicator(NoteReadVm vm) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () => _showPageNavigator(vm),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Zoom out button
                if (vm.currentPage != null) ...[
                  GestureDetector(
                    onTap: () => _zoomOut(vm.currentPage!),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.zoom_out,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

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

                // Zoom in button
                if (vm.currentPage != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _zoomIn(vm.currentPage!),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.zoom_in,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeToggle(NoteReadVm vm) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton.small(
        heroTag: "mode_toggle",
        onPressed: () {
          // Toggle between read and voice mode
          vm.setMode(
            vm.currentMode == NoteMode.read ? NoteMode.voice : NoteMode.read,
          );
        },
        backgroundColor: Colors.white.withOpacity(0.9),
        child: Icon(
          vm.currentMode == NoteMode.read ? Icons.mic : Icons.menu_book,
          color: vm.currentMode == NoteMode.read ? Colors.blue : Colors.green,
        ),
      ),
    );
  }

  void _showPageNavigator(NoteReadVm vm) {
    if (!vm.showPageThumbnails) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) =>
              PageNavigator(vm: vm, onClose: () => Navigator.of(context).pop()),
    );
  }
}
