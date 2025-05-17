import 'package:flutter/material.dart';

bool isNotNull(dynamic value) => value != null;

bool isNull(dynamic value) => value == null;

void logError(String message) {
  debugPrint(message);
}

// BoxDecoration copyWithBoxDecoration({
//   required BoxDecoration decoration,
//   Color? color,
//   DecorationImage? image,
//   BoxBorder? border,
//   BorderRadiusGeometry? borderRadius,
//   List<BoxShadow>? boxShadow,
//   Gradient? gradient,
//   BlendMode? backgroundBlendMode,
//   BoxShape? shape,
// }) {
//   return BoxDecoration(
//     color: color ?? decoration.color,
//     image: image ?? decoration.image,
//     border: border ?? decoration.border,
//     borderRadius:
//         shape == BoxShape.circle
//             ? null
//             : (borderRadius ?? decoration.borderRadius),
//     boxShadow: boxShadow ?? decoration.boxShadow,
//     gradient: gradient ?? decoration.gradient,
//     backgroundBlendMode: backgroundBlendMode ?? decoration.backgroundBlendMode,
//     shape: shape ?? decoration.shape,
//   );
// }
