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
  final Map<String, TransformationController> _transformationControllers = {};
  final Map<String, bool> _zoomStates = {};

  bool _showAddPageIndicator = false;
  String _addPageDirection = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.vm.currentPageIndex,
      viewportFraction: 0.95, // Show slight preview of adjacent pages
    );

    // Transformation controllers will be created per page as needed

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
    // Dispose all transformation controllers
    for (var controller in _transformationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCreationVm>(
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

  TransformationController _getTransformationController(String pageId) {
    if (!_transformationControllers.containsKey(pageId)) {
      _transformationControllers[pageId] = TransformationController();
      _zoomStates[pageId] = false;
    }
    return _transformationControllers[pageId]!;
  }

  void _handleDoubleTap(NotePage page) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pageDimensions = page.format.actualDimensions;
    final controller = _getTransformationController(page.id);
    final isZoomedToFit = _zoomStates[page.id] ?? false;
    
    // Calculate the scale needed to fit page width to screen width
    final fitToWidthScale = (screenWidth * 0.9) / pageDimensions.width;
    
    if (isZoomedToFit) {
      // Zoom out to actual size (scale = 1.0)
      controller.value = Matrix4.identity();
      _zoomStates[page.id] = false;
    } else {
      // Zoom to fit width if page is smaller than screen
      final currentScale = controller.value.getMaxScaleOnAxis();
      if (currentScale < fitToWidthScale) {
        final matrix = Matrix4.identity()
          ..scale(fitToWidthScale);
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
    
    final matrix = Matrix4.identity()..scale(newScale);
    controller.value = matrix;
    
    // Update zoom state
    _zoomStates[page.id] = newScale > 1.0;
  }

  Widget _buildPageWithZoomAndPan(NotePage page, NoteCreationVm vm) {
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

    final displayWidth = pageDimensions.width * displayScale;
    final displayHeight = pageDimensions.height * displayScale;

    // Canvas background (carton/desk color)
    return Container(
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
            child: Container(
              width: displayWidth,
              height: displayHeight,
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
            currentTemplate: vm.currentPage!.template,
            onTemplateChanged: (newTemplate) {
              vm.updateCurrentPageTemplate(newTemplate);
            },
          ),
    );
  }
}
