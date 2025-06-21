import 'package:flutter/material.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class PdfViewFooter extends StatelessWidget {
  const PdfViewFooter({super.key});

  @override
  Widget build(BuildContext context) {
    Color iconColor = Apptheme.stormGray;
    double iconSize = 16;
    return LayoutBuilder(
      builder: (_, constraints) {
        return Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Apptheme.lightGray),
            ),
          ),
          child: ScrollableRow(
            child: Container(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 15,
                    children: [
                      SVGImagePlaceHolder(
                        imagePath: Images.bold,
                        size: iconSize,
                        color: iconColor,
                      ),
                      SVGImagePlaceHolder(
                        imagePath: Images.italic,
                        size: iconSize,
                        color: iconColor,
                      ),
                      SVGImagePlaceHolder(
                        imagePath: Images.underline,
                        size: iconSize,
                        color: iconColor,
                      ),
                      SizedBox(
                        height: 15,
                        child: VerticalDivider(
                          color: Apptheme.lightGray,
                          width: 10,
                        ),
                      ),
                      SVGImagePlaceHolder(
                        imagePath: Images.pen,
                        size: iconSize,
                        color: iconColor,
                      ),
                      SVGImagePlaceHolder(
                        imagePath: Images.menu,
                        size: iconSize,
                        color: iconColor,
                      ),
                      SVGImagePlaceHolder(
                        imagePath: Images.img,
                        size: iconSize,
                        color: iconColor,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 15,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        onTap: () {},
                        text: "View in Mind Map",
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.share,
                          size: iconSize,
                          color: Apptheme.white,
                        ),
                        minHeight: 36,
                        wrapWithFlexible: true,
                        mainAxisSize: MainAxisSize.min,
                      ),
                      AppButton.secondary(
                        onTap: () {},
                        text: "Mind Map Settings",
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.settings,
                          size: iconSize,
                          color: Apptheme.vividBlue,
                        ),
                        minHeight: 36,
                        wrapWithFlexible: true,
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
