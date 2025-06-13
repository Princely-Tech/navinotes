import 'package:navinotes/packages.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
    this.decoration = const BoxDecoration(),
    this.width = double.infinity,
    this.height,
    this.margin,
    // this.edgeClipRadius,
  });
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxDecoration decoration;
  final double? width;
  final double? height;
  // final double? edgeClipRadius;
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius =
        decoration.borderRadius ?? BorderRadius.circular(12);
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: decoration.copyWith(
        color: decoration.color ?? Apptheme.white,
        borderRadius: decoration.shape == BoxShape.circle ? null : radius,
        shape: null,
        border: decoration.border ?? Border.all(color: Apptheme.lightGray),
      ),
      padding: padding,
      child: child,
    );
  }
}

class CreateCard extends StatelessWidget {
  const CreateCard({
    super.key,
    required this.onTap,
    required this.text,
    this.width = 0.0,
    this.height = 0.0,
  });
  final void Function()? onTap;
  final String text;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: width, minHeight: height),
            child: CustomCard(
              width: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  CustomCard(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Apptheme.babyIce,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.zero,
                    child: Icon(Icons.add, color: Apptheme.vividRose),
                  ),
                  Column(
                    spacing: 5,
                    children: [
                      Text(
                        text,
                        style: Apptheme.text.copyWith(
                          fontSize: 16,
                          fontWeight: getFontWeight(500),
                        ),
                      ),
                      Text(
                        'Start organizing your ideas',
                        style: Apptheme.text.copyWith(
                          color: Apptheme.steelMist,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
