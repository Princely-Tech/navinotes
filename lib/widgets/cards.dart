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
    this.addShadow = false,
    this.addCardShadow = false,
    this.addBorder = false,
    // this.edgeClipRadius,
  });
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxDecoration decoration;
  final double? width;
  final double? height;
  final bool addShadow;
  final bool addCardShadow;
  final bool addBorder;
  // final double? edgeClipRadius;
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius =
        decoration.borderRadius ?? BorderRadius.circular(12);
    List<BoxShadow>? boxShadow = decoration.boxShadow;
    if (addShadow) boxShadow = boxShadows;
    if (addCardShadow) boxShadow = cardShadows;
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: decoration.copyWith(
        color: decoration.color ?? AppTheme.white,
        borderRadius: decoration.shape == BoxShape.circle ? null : radius,
        shape: null,
        boxShadow: boxShadow,
        border:
            decoration.border ??
            Border.all(
              color: addBorder ? AppTheme.lightGray : AppTheme.transparent,
            ),
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
    this.width,
    this.height,
  });
  final void Function()? onTap;
  final String text;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: width ?? 0,
              minHeight: height ?? 0,
            ),
            child: CustomCard(
              addBorder: true,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  CustomCard(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.babyIce,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.zero,
                    child: Icon(Icons.add, color: AppTheme.vividRose),
                  ),
                  Column(
                    spacing: 5,
                    children: [
                      Text(
                        text,
                        style: AppTheme.text.copyWith(
                          fontSize: 16.0,
                          fontWeight: getFontWeight(500),
                        ),
                      ),
                      Text(
                        'Start organizing your ideas',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.steelMist,
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
