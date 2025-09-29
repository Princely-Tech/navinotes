import 'package:flutter/material.dart';
import 'dart:convert';

/// Stylus input types
enum StylusInputType {
  finger,
  applePencil,
  samsungSPen,
  genericStylus,
}

/// Pressure sensitivity curve types
enum PressureCurve {
  linear,
  soft,
  firm,
  custom,
}

/// Palm rejection sensitivity levels
enum PalmRejectionLevel {
  off,
  low,
  medium,
  high,
  maximum,
}

/// Stylus tilt behavior options
enum TiltBehavior {
  disabled,
  opacity,
  width,
  both,
}

/// Double tap action options
enum DoubleTapAction {
  disabled,
  switchToEraser,
  switchToPen,
  undo,
  redo,
  colorPicker,
}

/// Stylus settings configuration class
class StylusSettings {
  // Pressure sensitivity settings
  final bool pressureSensitivityEnabled;
  final double pressureMinimum;
  final double pressureMaximum;
  final PressureCurve pressureCurve;
  final List<Offset> customPressureCurve;
  
  // Stylus detection and palm rejection
  final bool stylusOnlyMode;
  final PalmRejectionLevel palmRejectionLevel;
  final bool fingerDrawingEnabled;
  final double palmRejectionRadius;
  
  // Tilt and orientation
  final bool tiltSensitivityEnabled;
  final TiltBehavior tiltBehavior;
  final double tiltSensitivity;
  final double maxTiltAngle;
  
  // Double tap and gestures
  final DoubleTapAction doubleTapAction;
  final bool doubleTapEnabled;
  final Duration doubleTapTimeout;
  
  // Hover and preview
  final bool hoverPreviewEnabled;
  final double hoverDistance;
  final bool showCursor;
  final double cursorOpacity;
  
  // Smoothing and stabilization
  final bool strokeSmoothingEnabled;
  final double smoothingLevel;
  final bool predictionEnabled;
  final int predictionDistance;
  
  // Haptic feedback
  final bool hapticFeedbackEnabled;
  final double hapticIntensity;
  
  const StylusSettings({
    // Pressure sensitivity defaults
    this.pressureSensitivityEnabled = true,
    this.pressureMinimum = 0.1,
    this.pressureMaximum = 1.0,
    this.pressureCurve = PressureCurve.linear,
    this.customPressureCurve = const [],
    
    // Palm rejection defaults
    this.stylusOnlyMode = false,
    this.palmRejectionLevel = PalmRejectionLevel.medium,
    this.fingerDrawingEnabled = true,
    this.palmRejectionRadius = 50.0,
    
    // Tilt defaults
    this.tiltSensitivityEnabled = true,
    this.tiltBehavior = TiltBehavior.width,
    this.tiltSensitivity = 0.5,
    this.maxTiltAngle = 60.0,
    
    // Double tap defaults
    this.doubleTapAction = DoubleTapAction.switchToEraser,
    this.doubleTapEnabled = true,
    this.doubleTapTimeout = const Duration(milliseconds: 300),
    
    // Hover defaults
    this.hoverPreviewEnabled = true,
    this.hoverDistance = 10.0,
    this.showCursor = true,
    this.cursorOpacity = 0.7,
    
    // Smoothing defaults
    this.strokeSmoothingEnabled = true,
    this.smoothingLevel = 0.5,
    this.predictionEnabled = true,
    this.predictionDistance = 20,
    
    // Haptic defaults
    this.hapticFeedbackEnabled = true,
    this.hapticIntensity = 0.5,
  });

  /// Create a copy with modified values
  StylusSettings copyWith({
    bool? pressureSensitivityEnabled,
    double? pressureMinimum,
    double? pressureMaximum,
    PressureCurve? pressureCurve,
    List<Offset>? customPressureCurve,
    bool? stylusOnlyMode,
    PalmRejectionLevel? palmRejectionLevel,
    bool? fingerDrawingEnabled,
    double? palmRejectionRadius,
    bool? tiltSensitivityEnabled,
    TiltBehavior? tiltBehavior,
    double? tiltSensitivity,
    double? maxTiltAngle,
    DoubleTapAction? doubleTapAction,
    bool? doubleTapEnabled,
    Duration? doubleTapTimeout,
    bool? hoverPreviewEnabled,
    double? hoverDistance,
    bool? showCursor,
    double? cursorOpacity,
    bool? strokeSmoothingEnabled,
    double? smoothingLevel,
    bool? predictionEnabled,
    int? predictionDistance,
    bool? hapticFeedbackEnabled,
    double? hapticIntensity,
  }) {
    return StylusSettings(
      pressureSensitivityEnabled: pressureSensitivityEnabled ?? this.pressureSensitivityEnabled,
      pressureMinimum: pressureMinimum ?? this.pressureMinimum,
      pressureMaximum: pressureMaximum ?? this.pressureMaximum,
      pressureCurve: pressureCurve ?? this.pressureCurve,
      customPressureCurve: customPressureCurve ?? this.customPressureCurve,
      stylusOnlyMode: stylusOnlyMode ?? this.stylusOnlyMode,
      palmRejectionLevel: palmRejectionLevel ?? this.palmRejectionLevel,
      fingerDrawingEnabled: fingerDrawingEnabled ?? this.fingerDrawingEnabled,
      palmRejectionRadius: palmRejectionRadius ?? this.palmRejectionRadius,
      tiltSensitivityEnabled: tiltSensitivityEnabled ?? this.tiltSensitivityEnabled,
      tiltBehavior: tiltBehavior ?? this.tiltBehavior,
      tiltSensitivity: tiltSensitivity ?? this.tiltSensitivity,
      maxTiltAngle: maxTiltAngle ?? this.maxTiltAngle,
      doubleTapAction: doubleTapAction ?? this.doubleTapAction,
      doubleTapEnabled: doubleTapEnabled ?? this.doubleTapEnabled,
      doubleTapTimeout: doubleTapTimeout ?? this.doubleTapTimeout,
      hoverPreviewEnabled: hoverPreviewEnabled ?? this.hoverPreviewEnabled,
      hoverDistance: hoverDistance ?? this.hoverDistance,
      showCursor: showCursor ?? this.showCursor,
      cursorOpacity: cursorOpacity ?? this.cursorOpacity,
      strokeSmoothingEnabled: strokeSmoothingEnabled ?? this.strokeSmoothingEnabled,
      smoothingLevel: smoothingLevel ?? this.smoothingLevel,
      predictionEnabled: predictionEnabled ?? this.predictionEnabled,
      predictionDistance: predictionDistance ?? this.predictionDistance,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      hapticIntensity: hapticIntensity ?? this.hapticIntensity,
    );
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'pressureSensitivityEnabled': pressureSensitivityEnabled,
      'pressureMinimum': pressureMinimum,
      'pressureMaximum': pressureMaximum,
      'pressureCurve': pressureCurve.name,
      'customPressureCurve': customPressureCurve.map((point) => {
        'dx': point.dx,
        'dy': point.dy,
      }).toList(),
      'stylusOnlyMode': stylusOnlyMode,
      'palmRejectionLevel': palmRejectionLevel.name,
      'fingerDrawingEnabled': fingerDrawingEnabled,
      'palmRejectionRadius': palmRejectionRadius,
      'tiltSensitivityEnabled': tiltSensitivityEnabled,
      'tiltBehavior': tiltBehavior.name,
      'tiltSensitivity': tiltSensitivity,
      'maxTiltAngle': maxTiltAngle,
      'doubleTapAction': doubleTapAction.name,
      'doubleTapEnabled': doubleTapEnabled,
      'doubleTapTimeoutMs': doubleTapTimeout.inMilliseconds,
      'hoverPreviewEnabled': hoverPreviewEnabled,
      'hoverDistance': hoverDistance,
      'showCursor': showCursor,
      'cursorOpacity': cursorOpacity,
      'strokeSmoothingEnabled': strokeSmoothingEnabled,
      'smoothingLevel': smoothingLevel,
      'predictionEnabled': predictionEnabled,
      'predictionDistance': predictionDistance,
      'hapticFeedbackEnabled': hapticFeedbackEnabled,
      'hapticIntensity': hapticIntensity,
    };
  }

  /// Create from JSON
  factory StylusSettings.fromJson(Map<String, dynamic> json) {
    return StylusSettings(
      pressureSensitivityEnabled: json['pressureSensitivityEnabled'] ?? true,
      pressureMinimum: (json['pressureMinimum'] ?? 0.1).toDouble(),
      pressureMaximum: (json['pressureMaximum'] ?? 1.0).toDouble(),
      pressureCurve: PressureCurve.values.firstWhere(
        (e) => e.name == json['pressureCurve'],
        orElse: () => PressureCurve.linear,
      ),
      customPressureCurve: (json['customPressureCurve'] as List<dynamic>?)
          ?.map((point) => Offset(
                (point['dx'] ?? 0.0).toDouble(),
                (point['dy'] ?? 0.0).toDouble(),
              ))
          .toList() ?? [],
      stylusOnlyMode: json['stylusOnlyMode'] ?? false,
      palmRejectionLevel: PalmRejectionLevel.values.firstWhere(
        (e) => e.name == json['palmRejectionLevel'],
        orElse: () => PalmRejectionLevel.medium,
      ),
      fingerDrawingEnabled: json['fingerDrawingEnabled'] ?? true,
      palmRejectionRadius: (json['palmRejectionRadius'] ?? 50.0).toDouble(),
      tiltSensitivityEnabled: json['tiltSensitivityEnabled'] ?? true,
      tiltBehavior: TiltBehavior.values.firstWhere(
        (e) => e.name == json['tiltBehavior'],
        orElse: () => TiltBehavior.width,
      ),
      tiltSensitivity: (json['tiltSensitivity'] ?? 0.5).toDouble(),
      maxTiltAngle: (json['maxTiltAngle'] ?? 60.0).toDouble(),
      doubleTapAction: DoubleTapAction.values.firstWhere(
        (e) => e.name == json['doubleTapAction'],
        orElse: () => DoubleTapAction.switchToEraser,
      ),
      doubleTapEnabled: json['doubleTapEnabled'] ?? true,
      doubleTapTimeout: Duration(
        milliseconds: json['doubleTapTimeoutMs'] ?? 300,
      ),
      hoverPreviewEnabled: json['hoverPreviewEnabled'] ?? true,
      hoverDistance: (json['hoverDistance'] ?? 10.0).toDouble(),
      showCursor: json['showCursor'] ?? true,
      cursorOpacity: (json['cursorOpacity'] ?? 0.7).toDouble(),
      strokeSmoothingEnabled: json['strokeSmoothingEnabled'] ?? true,
      smoothingLevel: (json['smoothingLevel'] ?? 0.5).toDouble(),
      predictionEnabled: json['predictionEnabled'] ?? true,
      predictionDistance: json['predictionDistance'] ?? 20,
      hapticFeedbackEnabled: json['hapticFeedbackEnabled'] ?? true,
      hapticIntensity: (json['hapticIntensity'] ?? 0.5).toDouble(),
    );
  }

  /// Get pressure value based on curve and input
  double getPressureValue(double rawPressure) {
    if (!pressureSensitivityEnabled) return 1.0;
    
    // Clamp to min/max range
    final clampedPressure = rawPressure.clamp(pressureMinimum, pressureMaximum);
    
    // Normalize to 0-1 range
    final normalizedPressure = (clampedPressure - pressureMinimum) / 
                              (pressureMaximum - pressureMinimum);
    
    // Apply pressure curve
    switch (pressureCurve) {
      case PressureCurve.linear:
        return normalizedPressure;
      case PressureCurve.soft:
        return _applySoftCurve(normalizedPressure);
      case PressureCurve.firm:
        return _applyFirmCurve(normalizedPressure);
      case PressureCurve.custom:
        return _applyCustomCurve(normalizedPressure);
    }
  }

  /// Apply soft pressure curve (easier to reach full pressure)
  double _applySoftCurve(double input) {
    return 1.0 - (1.0 - input) * (1.0 - input);
  }

  /// Apply firm pressure curve (harder to reach full pressure)
  double _applyFirmCurve(double input) {
    return input * input;
  }

  /// Apply custom pressure curve using control points
  double _applyCustomCurve(double input) {
    if (customPressureCurve.isEmpty) return input;
    
    // Find the two control points to interpolate between
    for (int i = 0; i < customPressureCurve.length - 1; i++) {
      final p1 = customPressureCurve[i];
      final p2 = customPressureCurve[i + 1];
      
      if (input >= p1.dx && input <= p2.dx) {
        // Linear interpolation between the two points
        final t = (input - p1.dx) / (p2.dx - p1.dx);
        return p1.dy + t * (p2.dy - p1.dy);
      }
    }
    
    return input; // Fallback to linear
  }

  /// Get tilt-adjusted stroke width
  double getTiltAdjustedWidth(double baseWidth, double tiltX, double tiltY) {
    if (!tiltSensitivityEnabled || tiltBehavior == TiltBehavior.disabled) {
      return baseWidth;
    }
    
    if (tiltBehavior == TiltBehavior.opacity || tiltBehavior == TiltBehavior.both) {
      // Calculate tilt angle
      final tiltAngle = (tiltX.abs() + tiltY.abs()) / 2;
      final normalizedTilt = (tiltAngle / maxTiltAngle).clamp(0.0, 1.0);
      
      // Apply tilt sensitivity
      final tiltEffect = normalizedTilt * tiltSensitivity;
      
      if (tiltBehavior == TiltBehavior.width || tiltBehavior == TiltBehavior.both) {
        // Increase width with tilt (simulating brush behavior)
        return baseWidth * (1.0 + tiltEffect * 2.0);
      }
    }
    
    return baseWidth;
  }

  /// Get tilt-adjusted opacity
  double getTiltAdjustedOpacity(double baseOpacity, double tiltX, double tiltY) {
    if (!tiltSensitivityEnabled || 
        (tiltBehavior != TiltBehavior.opacity && tiltBehavior != TiltBehavior.both)) {
      return baseOpacity;
    }
    
    // Calculate tilt angle
    final tiltAngle = (tiltX.abs() + tiltY.abs()) / 2;
    final normalizedTilt = (tiltAngle / maxTiltAngle).clamp(0.0, 1.0);
    
    // Apply tilt sensitivity (more tilt = more opacity)
    final tiltEffect = normalizedTilt * tiltSensitivity;
    return (baseOpacity + tiltEffect * 0.5).clamp(0.0, 1.0);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StylusSettings &&
        other.pressureSensitivityEnabled == pressureSensitivityEnabled &&
        other.pressureMinimum == pressureMinimum &&
        other.pressureMaximum == pressureMaximum &&
        other.pressureCurve == pressureCurve &&
        other.stylusOnlyMode == stylusOnlyMode &&
        other.palmRejectionLevel == palmRejectionLevel &&
        other.tiltSensitivityEnabled == tiltSensitivityEnabled &&
        other.tiltBehavior == tiltBehavior;
  }

  @override
  int get hashCode {
    return Object.hash(
      pressureSensitivityEnabled,
      pressureMinimum,
      pressureMaximum,
      pressureCurve,
      stylusOnlyMode,
      palmRejectionLevel,
      tiltSensitivityEnabled,
      tiltBehavior,
    );
  }
}

/// Extensions for enum display names
extension StylusInputTypeExtension on StylusInputType {
  String get displayName {
    switch (this) {
      case StylusInputType.finger:
        return 'Finger';
      case StylusInputType.applePencil:
        return 'Apple Pencil';
      case StylusInputType.samsungSPen:
        return 'Samsung S Pen';
      case StylusInputType.genericStylus:
        return 'Generic Stylus';
    }
  }

  IconData get icon {
    switch (this) {
      case StylusInputType.finger:
        return Icons.touch_app;
      case StylusInputType.applePencil:
        return Icons.edit;
      case StylusInputType.samsungSPen:
        return Icons.create;
      case StylusInputType.genericStylus:
        return Icons.edit;
    }
  }
}

extension PressureCurveExtension on PressureCurve {
  String get displayName {
    switch (this) {
      case PressureCurve.linear:
        return 'Linear';
      case PressureCurve.soft:
        return 'Soft';
      case PressureCurve.firm:
        return 'Firm';
      case PressureCurve.custom:
        return 'Custom';
    }
  }

  String get description {
    switch (this) {
      case PressureCurve.linear:
        return 'Pressure responds linearly';
      case PressureCurve.soft:
        return 'Easier to reach full pressure';
      case PressureCurve.firm:
        return 'Requires more pressure for full effect';
      case PressureCurve.custom:
        return 'Custom pressure curve';
    }
  }
}

extension PalmRejectionLevelExtension on PalmRejectionLevel {
  String get displayName {
    switch (this) {
      case PalmRejectionLevel.off:
        return 'Off';
      case PalmRejectionLevel.low:
        return 'Low';
      case PalmRejectionLevel.medium:
        return 'Medium';
      case PalmRejectionLevel.high:
        return 'High';
      case PalmRejectionLevel.maximum:
        return 'Maximum';
    }
  }

  double get sensitivity {
    switch (this) {
      case PalmRejectionLevel.off:
        return 0.0;
      case PalmRejectionLevel.low:
        return 0.2;
      case PalmRejectionLevel.medium:
        return 0.5;
      case PalmRejectionLevel.high:
        return 0.8;
      case PalmRejectionLevel.maximum:
        return 1.0;
    }
  }
}

extension DoubleTapActionExtension on DoubleTapAction {
  String get displayName {
    switch (this) {
      case DoubleTapAction.disabled:
        return 'Disabled';
      case DoubleTapAction.switchToEraser:
        return 'Switch to Eraser';
      case DoubleTapAction.switchToPen:
        return 'Switch to Pen';
      case DoubleTapAction.undo:
        return 'Undo';
      case DoubleTapAction.redo:
        return 'Redo';
      case DoubleTapAction.colorPicker:
        return 'Color Picker';
    }
  }

  IconData get icon {
    switch (this) {
      case DoubleTapAction.disabled:
        return Icons.block;
      case DoubleTapAction.switchToEraser:
        return Icons.cleaning_services;
      case DoubleTapAction.switchToPen:
        return Icons.edit;
      case DoubleTapAction.undo:
        return Icons.undo;
      case DoubleTapAction.redo:
        return Icons.redo;
      case DoubleTapAction.colorPicker:
        return Icons.palette;
    }
  }
}
