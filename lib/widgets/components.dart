import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navinotes/settings/apptheme.dart';

class SVGImagePlaceHolder extends StatelessWidget {
  const SVGImagePlaceHolder({super.key, required this.imagePath, this.size});

  final String imagePath;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Apptheme.black.withAlpha(100),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        height: size,
        width: size,
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}
