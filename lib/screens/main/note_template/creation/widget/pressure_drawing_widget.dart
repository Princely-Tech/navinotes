import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import '../controllers/pressure_drawing_controller.dart';
import '../models/stylus_settings.dart';
import '../models/drawing_tools.dart';
import '../vm.dart';

/// Enhanced drawing widget with pressure sensitivity and stylus support
class PressureDrawingWidget extends StatefulWidget {
  final PressureDrawingController controller;
  final double width;
  final double height;
  final NoteCreationVm vm;

  const PressureDrawingWidget({
    Key? key,
    required this.controller,
    required this.width,
    required this.height,
    required this.vm,
  }) : super(key: key);

  @override
  State<PressureDrawingWidget> createState() => _PressureDrawingWidgetState();
}

class _PressureDrawingWidgetState extends State<PressureDrawingWidget>
    with TickerProviderStateMixin {
  late AnimationController _cursorAnimationController;
  late Animation<double> _cursorAnimation;

  // Gesture tracking
  final Map<int, Offset> _activePointers = <int, Offset>{};
  bool _isDrawing = false;

  // Hover state
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _cursorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _cursorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cursorAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    // Stop any running animations before disposing
    try {
      _cursorAnimationController.stop();
      _cursorAnimationController.reset();
      _cursorAnimationController.dispose();
    } catch (e) {
      debugPrint('Error disposing cursor animation controller: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Validate dimensions
    final validWidth =
        widget.width.isFinite && widget.width > 10 ? widget.width : 595.0;
    final validHeight =
        widget.height.isFinite && widget.height > 10 ? widget.height : 842.0;

    if (validWidth < 10 || validHeight < 10) {
      return Container(
        width: 100,
        height: 100,
        color: Colors.transparent,
        child: const Center(child: Text('Drawing unavailable')),
      );
    }

    return IgnorePointer(
      ignoring: widget.vm.currentMode != NoteMode.drawing,
      child: Container(
        width: validWidth,
        height: validHeight,
        child: Stack(
          children: [
            // Main drawing board
            _buildDrawingBoard(validWidth, validHeight),

            // Pressure-sensitive cursor overlay
            if (_shouldShowCursor()) _buildCursor(),

            // Palm rejection visual feedback (debug mode)
            if (_isDebugMode()) _buildPalmRejectionOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawingBoard(double width, double height) {
    return MouseRegion(
      onHover: (event) => _handleMouseHover(event),
      onExit: (event) => _handleMouseExit(event),
      child: RepaintBoundary(
        child: Container(
          width: width,
          height: height,
          child: Stack(
            children: [
              // Main drawing board
              Builder(
                builder: (context) {
                  try {
                    return Container(
                      width: width,
                      height: height,
                      color: Colors.grey.withOpacity(0.06),
                      child: const Center(child: Text('Drawing unavailable')),
                    );
                    return DrawingBoard(
                      controller: widget.controller.drawingController,
                      background: Container(
                        width: width,
                        height: height,
                        color: Colors.transparent,
                      ),
                      showDefaultActions: false,
                      showDefaultTools: false,
                    );
                  } catch (e, st) {
                    // Use e.toString() explicitly for release mode compatibility
                    if (kDebugMode) {
                      debugPrint(
                        'Error creating DrawingBoard: ${e.toString()}',
                      );
                      debugPrint('Stack trace: ${st.toString()}');
                    }
                    return Container(
                      width: width,
                      height: height,
                      color: Colors.grey.withOpacity(0.06),
                      child: const Center(child: Text('Drawing unavailable')),
                    );
                  }
                },
              ),
              // Transparent overlay for pressure/stylus processing
              Positioned.fill(
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: (event) {
                    // Process pressure data but don't consume the event
                    _handlePointerDown(event);
                  },
                  onPointerMove: (event) {
                    // Process pressure data but don't consume the event
                    _handlePointerMove(event);
                  },
                  onPointerUp: (event) {
                    // Process pressure data but don't consume the event
                    _handlePointerUp(event);
                  },
                  onPointerCancel: (event) {
                    // Process pressure data but don't consume the event
                    _handlePointerCancel(event);
                  },
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCursor() {
    final hoverInfo = widget.controller.getHoverInfo();
    if (hoverInfo == null || !hoverInfo.visible) return const SizedBox.shrink();

    // Check if eraser tool is selected
    final isEraserSelected =
        widget.vm.selectedDrawingTool == DrawingToolType.eraser;

    return AnimatedBuilder(
      animation: _cursorAnimation,
      builder: (context, child) {
        return Positioned(
          left: hoverInfo.position.dx - hoverInfo.size / 2,
          top: hoverInfo.position.dy - hoverInfo.size / 2,
          child: IgnorePointer(
            child: Container(
              width: hoverInfo.size,
              height: hoverInfo.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isEraserSelected
                          ? Colors.red.withOpacity(
                            hoverInfo.opacity * _cursorAnimation.value * 0.8,
                          )
                          : Colors.black26.withOpacity(
                            hoverInfo.opacity * _cursorAnimation.value,
                          ),
                  width: isEraserSelected ? 3 : 2,
                ),
                color:
                    isEraserSelected
                        ? Colors.red.withOpacity(
                          hoverInfo.opacity * _cursorAnimation.value * 0.1,
                        )
                        : null,
              ),
              child: Center(
                child:
                    isEraserSelected
                        ? Icon(
                          Icons.cleaning_services,
                          size: (hoverInfo.size * 0.4).clamp(12.0, 24.0),
                          color: Colors.red.withOpacity(
                            hoverInfo.opacity * _cursorAnimation.value * 0.9,
                          ),
                        )
                        : Container(
                          width: hoverInfo.size * 0.3,
                          height: hoverInfo.size * 0.3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor.withOpacity(
                              hoverInfo.opacity * _cursorAnimation.value * 0.5,
                            ),
                          ),
                        ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPalmRejectionOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: PalmRejectionDebugPainter(
            activePointers: _activePointers,
            rejectionRadius:
                widget.controller.stylusSettings.palmRejectionRadius,
          ),
        ),
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    _activePointers[event.pointer] = event.localPosition;

    // Process pressure data and styling (but don't consume the event)
    final shouldProcess = widget.controller.handlePointerDown(event);

    if (shouldProcess) {
      _isDrawing = true;
      widget.vm.setDrawingState(true);

      // Apply pressure-sensitive styling in real-time
      _updateDrawingStyle(event);

      // Provide haptic feedback for stylus
      if (widget.controller.stylusSettings.hapticFeedbackEnabled &&
          event.kind == PointerDeviceKind.stylus) {
        HapticFeedback.lightImpact();
      }

      // Handle double tap actions
      if (widget.controller.shouldExecuteDoubleTapAction) {
        _executeDoubleTapAction(widget.controller.doubleTapAction);
      }
    }

    _updateCursorVisibility();
    // Note: Don't consume the event - let it pass through to DrawingBoard
  }

  void _handlePointerMove(PointerMoveEvent event) {
    _activePointers[event.pointer] = event.localPosition;

    // Process pressure data (but don't consume the event)
    final shouldProcess = widget.controller.handlePointerMove(event);

    if (shouldProcess && _isDrawing) {
      // Apply pressure-sensitive styling in real-time
      _updateDrawingStyle(event);

      // Continue drawing stroke
      widget.vm.setDrawingState(true);
    }
    // Note: Don't consume the event - let it pass through to DrawingBoard
  }

  void _handlePointerUp(PointerUpEvent event) {
    _activePointers.remove(event.pointer);

    // Process pressure data (but don't consume the event)
    widget.controller.handlePointerUp(event);

    if (_isDrawing) {
      _isDrawing = false;
      widget.vm.setDrawingState(false);

      // Provide completion haptic feedback
      if (widget.controller.stylusSettings.hapticFeedbackEnabled) {
        HapticFeedback.selectionClick();
      }
    }

    _updateCursorVisibility();
    // Note: Don't consume the event - let it pass through to DrawingBoard
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _activePointers.remove(event.pointer);

    if (_isDrawing) {
      _isDrawing = false;
      widget.vm.setDrawingState(false);
    }

    _updateCursorVisibility();
    // Note: Don't consume the event - let it pass through to DrawingBoard
  }

  void _handlePointerHover(PointerHoverEvent event) {
    // Create a compatible event for the controller
    widget.controller.handlePointerHover(event);

    if (!_isHovering) {
      _isHovering = true;
      _updateCursorVisibility();
    }
  }

  void _handlePointerExit(PointerExitEvent event) {
    // Create a compatible event for the controller
    widget.controller.handlePointerExit(event);

    _isHovering = false;
    _updateCursorVisibility();
  }

  void _handleMouseHover(PointerHoverEvent event) {
    _handlePointerHover(event);
  }

  void _handleMouseExit(PointerExitEvent event) {
    _handlePointerExit(event);
  }

  void _updateCursorVisibility() {
    // Check if widget is still mounted and controller is not disposed
    if (!mounted) return;

    final shouldShow = _shouldShowCursor();

    // Only animate if controller is not disposed
    try {
      if (shouldShow &&
          _cursorAnimationController.status != AnimationStatus.forward) {
        _cursorAnimationController.forward();
      } else if (!shouldShow &&
          _cursorAnimationController.status != AnimationStatus.reverse) {
        _cursorAnimationController.reverse();
      }
    } catch (e) {
      // Animation controller was disposed, ignore the error
      if (kDebugMode) {
        debugPrint(
          'Animation controller disposed during cursor update: ${e.toString()}',
        );
      }
    }
  }

  bool _shouldShowCursor() {
    final settings = widget.controller.stylusSettings;
    return settings.showCursor &&
        (_isHovering || _isDrawing) &&
        widget.vm.currentMode == NoteMode.drawing;
  }

  bool _isDebugMode() {
    // Enable debug mode for development - you can make this configurable
    return false; // Set to true to see palm rejection visualization
  }

  void _executeDoubleTapAction(DoubleTapAction action) {
    switch (action) {
      case DoubleTapAction.disabled:
        break;
      case DoubleTapAction.switchToEraser:
        widget.vm.setSelectedDrawingTool(DrawingToolType.eraser);
        break;
      case DoubleTapAction.switchToPen:
        widget.vm.setSelectedDrawingTool(DrawingToolType.simpleLine);
        break;
      case DoubleTapAction.undo:
        widget.controller.undo();
        break;
      case DoubleTapAction.redo:
        widget.controller.redo();
        break;
      case DoubleTapAction.colorPicker:
        // This would trigger a color picker dialog
        _showColorPicker();
        break;
    }
  }

  void _showColorPicker() {
    // Implementation for color picker would go here
    // This could show a modal or bottom sheet with color options
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Text(
                'Color Picker\n(Implementation pending)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
    );
  }

  /// Update drawing style based on pressure and stylus settings
  void _updateDrawingStyle(PointerEvent event) {
    if (!widget.controller.stylusSettings.pressureSensitivityEnabled) {
      return;
    }

    // Get current drawing tool settings from VM
    final currentTool = widget.vm.selectedDrawingTool;
    final baseStrokeWidth = widget.vm.strokeWidth;
    final currentColor = widget.vm.selectedColor;

    // Apply pressure sensitivity
    double pressure = 1.0;
    if (event is PointerDownEvent || event is PointerMoveEvent) {
      pressure = event.pressure;
    }

    // Apply pressure curve from settings
    final adjustedPressure = widget.controller.stylusSettings.getPressureValue(
      pressure,
    );

    // Calculate pressure-adjusted stroke width
    final pressureStrokeWidth = baseStrokeWidth * adjustedPressure;

    // Apply tilt adjustments if supported
    double tiltAdjustedWidth = pressureStrokeWidth;
    double tiltAdjustedOpacity = 1.0;

    if (widget.controller.stylusSettings.tiltSensitivityEnabled) {
      // Note: Tilt values would need platform-specific implementation
      // For now, we'll use default values
      tiltAdjustedWidth = widget.controller.stylusSettings.getTiltAdjustedWidth(
        pressureStrokeWidth,
        0.0,
        0.0,
      );
      tiltAdjustedOpacity = widget.controller.stylusSettings
          .getTiltAdjustedOpacity(1.0, 0.0, 0.0);
    }

    // Update the drawing controller with pressure-adjusted style
    widget.controller.setStyle(
      strokeWidth: tiltAdjustedWidth.clamp(0.1, 50.0),
      color: currentColor.withValues(alpha: tiltAdjustedOpacity),
    );
  }
}

/// Debug painter for palm rejection visualization
class PalmRejectionDebugPainter extends CustomPainter {
  final Map<int, Offset> activePointers;
  final double rejectionRadius;

  PalmRejectionDebugPainter({
    required this.activePointers,
    required this.rejectionRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.red.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = Colors.red.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    // Draw palm rejection zones around active pointers
    for (final position in activePointers.values) {
      canvas.drawCircle(position, rejectionRadius, paint);
      canvas.drawCircle(position, rejectionRadius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(PalmRejectionDebugPainter oldDelegate) {
    return oldDelegate.activePointers != activePointers ||
        oldDelegate.rejectionRadius != rejectionRadius;
  }
}
