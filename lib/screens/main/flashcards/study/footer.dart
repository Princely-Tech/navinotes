import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';

class FlashCardStudyFooter extends StatelessWidget {
  const FlashCardStudyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 1, color: Color(0xFFE5E7EB))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppButton(
            onTap: () {},
            text: 'End Session',
            minHeight: 40,
            textColor: Color(0xFFDC2626),
            color: const Color(0xFFFEF2F2),
            prefix: Icon(Icons.close, size: 16, color: Color(0xFFDC2626)),
            mainAxisSize: MainAxisSize.min,
          ),

          VisibleController(
            mobile: false,
            laptop: true,
            child: Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    AppButton(
                      onTap: () {},
                      text: 'Shuffle',
                      minHeight: 40,
                      textColor: const Color(0xFF4B5563),
                      color: const Color(0xFFF3F4F6),
                      prefix: SVGImagePlaceHolder(
                        imagePath: Images.shuffle,
                        size: 16,
                        color: const Color(0xFF4B5563),
                      ),
                      wrapWithFlexible: true,
                      mainAxisSize: MainAxisSize.min,
                    ),
                    AppButton(
                      onTap: () {},
                      text: 'Filter',
                      minHeight: 40,
                      textColor: const Color(0xFF4B5563),
                      color: const Color(0xFFF3F4F6),
                      prefix: SVGImagePlaceHolder(
                        imagePath: Images.filter,
                        size: 16,
                        color: const Color(0xFF4B5563),
                      ),
                      wrapWithFlexible: true,
                      mainAxisSize: MainAxisSize.min,
                    ),
                    AppButton(
                      onTap: () {},
                      text: 'Settings',
                      minHeight: 40,
                      textColor: const Color(0xFF4B5563),
                      color: const Color(0xFFF3F4F6),
                      prefix: SVGImagePlaceHolder(
                        imagePath: Images.pref,
                        size: 16,
                        color: const Color(0xFF4B5563),
                      ),
                      wrapWithFlexible: true,
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ],
                ),
              ),
            ),
          ),

          VisibleController(
            mobile: false,
            tablet: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: const Row(
                spacing: 8,
                children: [
                  Icon(Icons.access_time, size: 14, color: Color(0xFF6B7280)),
                  Text(
                    'Session time: 4:23',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
