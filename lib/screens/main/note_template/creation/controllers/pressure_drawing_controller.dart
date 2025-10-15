import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import '../models/stylus_settings.dart';
import 'dart:math' as math;

/// Enhanced drawing controller with pressure sensitivity and stylus support
class PressureDrawingController extends ChangeNotifier {
  // Wrap the actual DrawingController
  late final DrawingController _drawingController;
  StylusSettings _stylusSettings;

  // Pressure tracking
  final List<PressurePoint> _currentStroke = [];
  bool _isDrawing = false;

  // Palm rejection
  final Set<int> _rejectedPointers = <int>{};
  final Map<int, Offset> _pointerPositions = <int, Offset>{};
  final Map<int, DateTime> _pointerStartTimes = <int, DateTime>{};

  // Double tap detection
  DateTime? _lastTapTime;
  Offset? _lastTapPosition;

  // Hover state
  bool _isHovering = false;
  Offset? _hoverPosition;

  // Stroke smoothing
  final List<Offset> _smoothingBuffer = [];

  PressureDrawingController({StylusSettings? stylusSettings})
    : _stylusSettings = stylusSettings ?? const StylusSettings() {
    _drawingController = DrawingController();
  }

  // Delegate methods to the wrapped controller
  DrawingController get drawingController => _drawingController;

  // Expose common DrawingController methods
  void clear() => _drawingController.clear();
  void undo() => _drawingController.undo();
  void redo() => _drawingController.redo();
  bool canUndo() => _drawingController.canUndo();
  bool canRedo() => _drawingController.canRedo();
  List<Map<String, dynamic>> getJsonList() => _drawingController.getJsonList();
  void addContent(PaintContent content) =>
      _drawingController.addContent(content);
  void setPaintContent(PaintContent content) =>
      _drawingController.setPaintContent(content);

  // Add setStyle method for compatibility
  void setStyle({double? strokeWidth, Color? color}) {
    if (strokeWidth != null || color != null) {
      _drawingController.setStyle(
        strokeWidth: strokeWidth ?? 2.0,
        color: color ?? Colors.black,
      );
    }
  }

  /// Get current stylus settings
  StylusSettings get stylusSettings => _stylusSettings;

  /// Update stylus settings
  void updateStylusSettings(StylusSettings settings) {
    _stylusSettings = settings;
    notifyListeners();
  }

  /// Handle pointer down event with pressure sensitivity
  bool handlePointerDown(PointerDownEvent event) {
    // Check if this is a palm touch that should be rejected
    if (_shouldRejectPointer(event)) {
      _rejectedPointers.add(event.pointer);
      return false;
    }

    // Store pointer information
    _pointerPositions[event.pointer] = event.localPosition;
    _pointerStartTimes[event.pointer] = DateTime.now();

    // Check for double tap
    if (_stylusSettings.doubleTapEnabled) {
      _handleDoubleTap(event);
    }

    // Start new stroke
    _startStroke(event);

    return true;
  }

  /// Handle pointer move event with pressure sensitivity
  bool handlePointerMove(PointerMoveEvent event) {
    // Skip rejected pointers
    if (_rejectedPointers.contains(event.pointer)) {
      return false;
    }

    // Update pointer position
    _pointerPositions[event.pointer] = event.localPosition;

    // Continue stroke if drawing
    if (_isDrawing) {
      _continueStroke(event);
    }

    return true;
  }

  /// Handle pointer up event
  bool handlePointerUp(PointerUpEvent event) {
    // Clean up pointer tracking
    _pointerPositions.remove(event.pointer);
    _pointerStartTimes.remove(event.pointer);
    _rejectedPointers.remove(event.pointer);

    // End stroke if this was the drawing pointer
    if (_isDrawing) {
      _endStroke(event);
    }

    return true;
  }

  /// Handle pointer hover for stylus preview
  void handlePointerHover(PointerHoverEvent event) {
    if (_stylusSettings.hoverPreviewEnabled) {
      _isHovering = true;
      _hoverPosition = event.localPosition;
      notifyListeners();
    }
  }

  /// Handle pointer exit
  void handlePointerExit(PointerExitEvent event) {
    _isHovering = false;
    _hoverPosition = null;
    notifyListeners();
  }

  /// Check if pointer should be rejected (palm rejection)
  bool _shouldRejectPointer(PointerDownEvent event) {
    if (_stylusSettings.palmRejectionLevel == PalmRejectionLevel.off) {
      return false;
    }

    // Check if stylus-only mode is enabled and this isn't a stylus
    if (_stylusSettings.stylusOnlyMode &&
        event.kind != PointerDeviceKind.stylus) {
      return true;
    }

    // Check if finger drawing is disabled and this is a touch
    if (!_stylusSettings.fingerDrawingEnabled &&
        event.kind == PointerDeviceKind.touch) {
      return true;
    }

    // Palm rejection based on touch size and pressure
    if (event.kind == PointerDeviceKind.touch) {
      final rejectionSensitivity =
          _stylusSettings.palmRejectionLevel.sensitivity;

      // Reject large touch areas (likely palm)
      if (event.size >
          _stylusSettings.palmRejectionRadius * rejectionSensitivity) {
        return true;
      }

      // Reject low-pressure touches that are likely accidental
      if (event.pressure < 0.1 * rejectionSensitivity) {
        return true;
      }

      // Check proximity to other active pointers (multi-touch palm detection)
      for (final otherPosition in _pointerPositions.values) {
        final distance = (event.localPosition - otherPosition).distance;
        if (distance <
            _stylusSettings.palmRejectionRadius * rejectionSensitivity) {
          return true;
        }
      }
    }

    return false;
  }

  /// Handle double tap detection and actions
  void _handleDoubleTap(PointerDownEvent event) {
    final now = DateTime.now();

    if (_lastTapTime != null && _lastTapPosition != null) {
      final timeDiff = now.difference(_lastTapTime!);
      final positionDiff = (event.localPosition - _lastTapPosition!).distance;

      if (timeDiff <= _stylusSettings.doubleTapTimeout && positionDiff < 20.0) {
        // Execute double tap action
        _executeDoubleTapAction();
        _lastTapTime = null;
        _lastTapPosition = null;
        return;
      }
    }

    _lastTapTime = now;
    _lastTapPosition = event.localPosition;
  }

  /// Execute the configured double tap action
  void _executeDoubleTapAction() {
    // Provide haptic feedback if enabled
    if (_stylusSettings.hapticFeedbackEnabled) {
      HapticFeedback.lightImpact();
    }

    // Note: Actual action execution would be handled by the parent widget
    // This controller just signals that a double tap occurred
    notifyListeners();
  }

  /// Start a new stroke
  void _startStroke(PointerDownEvent event) {
    _isDrawing = true;
    _currentStroke.clear();
    _smoothingBuffer.clear();

    final pressurePoint = _createPressurePoint(event);
    _currentStroke.add(pressurePoint);

    // Add the initial point to the drawing
    _addPointToDrawing(pressurePoint);
  }

  /// Continue the current stroke
  void _continueStroke(PointerMoveEvent event) {
    if (!_isDrawing) return;

    final pressurePoint = _createPressurePoint(event);
    _currentStroke.add(pressurePoint);

    // Apply stroke smoothing if enabled
    if (_stylusSettings.strokeSmoothingEnabled) {
      _addSmoothedPoint(pressurePoint);
    } else {
      _addPointToDrawing(pressurePoint);
    }
  }

  /// End the current stroke
  void _endStroke(PointerUpEvent event) {
    if (!_isDrawing) return;

    _isDrawing = false;

    // Finalize the stroke with any remaining smoothed points
    if (_stylusSettings.strokeSmoothingEnabled && _smoothingBuffer.isNotEmpty) {
      for (final point in _smoothingBuffer) {
        _addPointToDrawing(_createPressurePointFromOffset(point, 1.0));
      }
      _smoothingBuffer.clear();
    }

    _currentStroke.clear();
  }

  /// Create a pressure point from pointer event
  PressurePoint _createPressurePoint(PointerEvent event) {
    double pressure = 1.0;
    double tiltX = 0.0;
    double tiltY = 0.0;

    // Extract pressure information if available
    if (event is PointerDownEvent || event is PointerMoveEvent) {
      pressure = event.pressure;

      // Note: tiltX and tiltY are not available in standard Flutter PointerEvent
      // They would need to be accessed through platform channels for specific devices
      // For now, we'll use default values
      if (event.kind == PointerDeviceKind.stylus) {
        // Tilt information would need platform-specific implementation
        tiltX = 0.0; // Placeholder
        tiltY = 0.0; // Placeholder
      }
    }

    // Apply stylus settings to pressure
    final adjustedPressure = _stylusSettings.getPressureValue(pressure);

    return PressurePoint(
      offset: event.localPosition,
      pressure: adjustedPressure,
      tiltX: tiltX,
      tiltY: tiltY,
      timestamp: DateTime.now(),
    );
  }

  /// Create a pressure point from offset (for smoothing)
  PressurePoint _createPressurePointFromOffset(Offset offset, double pressure) {
    return PressurePoint(
      offset: offset,
      pressure: pressure,
      tiltX: 0.0,
      tiltY: 0.0,
      timestamp: DateTime.now(),
    );
  }

  /// Add smoothed point using buffer
  void _addSmoothedPoint(PressurePoint point) {
    _smoothingBuffer.add(point.offset);

    // Keep buffer size manageable
    if (_smoothingBuffer.length > 5) {
      _smoothingBuffer.removeAt(0);
    }

    // Apply smoothing algorithm
    if (_smoothingBuffer.length >= 3) {
      final smoothedOffset = _calculateSmoothedPoint();
      final smoothedPoint = PressurePoint(
        offset: smoothedOffset,
        pressure: point.pressure,
        tiltX: point.tiltX,
        tiltY: point.tiltY,
        timestamp: point.timestamp,
      );
      _addPointToDrawing(smoothedPoint);
    }
  }

  /// Calculate smoothed point using weighted average
  Offset _calculateSmoothedPoint() {
    if (_smoothingBuffer.length < 3) return _smoothingBuffer.last;

    final smoothingFactor = _stylusSettings.smoothingLevel;
    double totalWeight = 0.0;
    double weightedX = 0.0;
    double weightedY = 0.0;

    for (int i = 0; i < _smoothingBuffer.length; i++) {
      final weight =
          math.pow(smoothingFactor, _smoothingBuffer.length - i - 1).toDouble();
      totalWeight += weight;
      weightedX += _smoothingBuffer[i].dx * weight;
      weightedY += _smoothingBuffer[i].dy * weight;
    }

    return Offset(weightedX / totalWeight, weightedY / totalWeight);
  }

  /// Add point to the actual drawing
  void _addPointToDrawing(PressurePoint point) {
    // Get current drawing configuration - use default values
    const defaultStrokeWidth = 2.0;
    const defaultColor = Colors.black;

    // Calculate pressure-adjusted stroke width
    double strokeWidth = defaultStrokeWidth;
    if (_stylusSettings.pressureSensitivityEnabled) {
      strokeWidth *= point.pressure;
    }

    // Apply tilt adjustments
    strokeWidth = _stylusSettings.getTiltAdjustedWidth(
      strokeWidth,
      point.tiltX,
      point.tiltY,
    );

    // Calculate opacity
    double opacity = 1.0;
    if (_stylusSettings.tiltSensitivityEnabled) {
      opacity = _stylusSettings.getTiltAdjustedOpacity(
        opacity,
        point.tiltX,
        point.tiltY,
      );
    }

    // Create paint content with pressure-adjusted properties
    final adjustedConfig = PressureDrawingConfig(
      strokeWidth: strokeWidth.clamp(0.1, 50.0),
      color: defaultColor.withValues(alpha: opacity),
    );

    // Add to drawing using the wrapped controller
    _addPressureAwarePaintContent(point, adjustedConfig);
  }

  /// Add pressure-aware paint content
  void _addPressureAwarePaintContent(
    PressurePoint point,
    PressureDrawingConfig config,
  ) {
    // Update the drawing controller's style with pressure-adjusted properties
    _drawingController.setStyle(
      strokeWidth: config.strokeWidth,
      color: config.color,
    );

    // The actual drawing will be handled by the DrawingBoard widget
    // when it receives pointer events. We just need to ensure the
    // style is set correctly for pressure sensitivity.
  }

  /// Get hover information for cursor display
  HoverInfo? getHoverInfo() {
    if (!_isHovering || _hoverPosition == null) return null;

    return HoverInfo(
      position: _hoverPosition!,
      visible: _stylusSettings.showCursor,
      opacity: _stylusSettings.cursorOpacity,
      size: 2.0, // Default stroke width since drawConfig is not available
    );
  }

  /// Check if double tap action should be executed
  bool get shouldExecuteDoubleTapAction =>
      _lastTapTime == null && _lastTapPosition == null;

  /// Get the configured double tap action
  DoubleTapAction get doubleTapAction => _stylusSettings.doubleTapAction;

  @override
  void dispose() {
    _currentStroke.clear();
    _rejectedPointers.clear();
    _pointerPositions.clear();
    _pointerStartTimes.clear();
    _smoothingBuffer.clear();
    _drawingController.dispose();
    super.dispose();
  }
}

/// Represents a point with pressure and tilt information
class PressurePoint {
  final Offset offset;
  final double pressure;
  final double tiltX;
  final double tiltY;
  final DateTime timestamp;

  const PressurePoint({
    required this.offset,
    required this.pressure,
    required this.tiltX,
    required this.tiltY,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'PressurePoint(offset: $offset, pressure: $pressure, tiltX: $tiltX, tiltY: $tiltY)';
  }
}

/// Hover information for cursor display
class HoverInfo {
  final Offset position;
  final bool visible;
  final double opacity;
  final double size;

  const HoverInfo({
    required this.position,
    required this.visible,
    required this.opacity,
    required this.size,
  });
}

/// Simple drawing configuration for pressure-aware drawing
class PressureDrawingConfig {
  final double strokeWidth;
  final Color color;
  final PaintingStyle style;
  final StrokeCap strokeCap;

  const PressureDrawingConfig({
    required this.strokeWidth,
    required this.color,
    this.style = PaintingStyle.stroke,
    this.strokeCap = StrokeCap.round,
  });

  PressureDrawingConfig copyWith({
    double? strokeWidth,
    Color? color,
    PaintingStyle? style,
    StrokeCap? strokeCap,
  }) {
    return PressureDrawingConfig(
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      style: style ?? this.style,
      strokeCap: strokeCap ?? this.strokeCap,
    );
  }
}
