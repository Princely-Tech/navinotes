import 'package:flutter/material.dart';
import 'package:navinotes/settings/app_strings.dart';
import 'package:navinotes/settings/Apptheme.dart';
import 'package:navinotes/settings/util_functions.dart';

enum ButtonType {
  primary,
  secondary,
  text;

  // bool get isPrimary => this == primary;
  bool get isSecondary => this == secondary;
  bool get isText => this == text;
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    ButtonType type = ButtonType.primary,
    this.text,
    this.child,
    this.style,
    this.isRectangle = true,
    this.loading = false,
    required this.onTap,
    this.prefix,
    this.color,
    this.wrapWithFlexible = false,
    this.suffix,
    this.minHeight = 40,
    this.padding,
    this.mainAxisSize = MainAxisSize.max,
    this.textColor,
    this.gradient,
    // this.borderSide,
  }) : _type = type,
       assert(
         (text == null || child == null),
         AppStrings.mustProvideTextOrChild,
       );

  const AppButton.secondary({
    super.key,
    this.text,
    this.child,
    this.isRectangle = true,
    required this.onTap,
    this.prefix,
    this.suffix,
    this.color,
    this.loading = false,
    this.wrapWithFlexible = false,
    this.style,
    this.minHeight = 50,
    this.mainAxisSize = MainAxisSize.max,
    this.padding,
    this.textColor,
    this.gradient,
    // this.borderSide,
  }) : _type = ButtonType.secondary,
       assert(
         (text == null || child == null),
         AppStrings.mustProvideTextOrChild,
       );

  const AppButton.text({
    super.key,
    this.text,
    this.child,
    required this.onTap,
    this.isRectangle = true,
    this.wrapWithFlexible = false,
    this.prefix,
    this.suffix,
    this.color,
    this.padding,
    this.style,
    this.loading = false,
    this.minHeight = 10,
    this.textColor,
    this.gradient,
    // this.borderSide,
    this.mainAxisSize = MainAxisSize.max,
  }) : _type = ButtonType.text,
       assert(
         (text == null || child == null),
         AppStrings.mustProvideTextOrChild,
       );

  final ButtonType _type;
  final String? text;
  final bool isRectangle;
  final bool loading;
  final bool wrapWithFlexible;
  final VoidCallback onTap;
  final Widget? suffix;
  final Widget? prefix;
  final TextStyle? style;
  final Color? color;
  final Widget? child;
  final double minHeight;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final MainAxisSize mainAxisSize;
  final Gradient? gradient;
  // final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    if (_type.isText) {
      return InkWell(
        onTap: onTap,
        child: Row(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isNotNull(prefix)) prefix!,
            if (isNotNull(text))
              Text(
                text!,
                style:
                    style ??
                    Apptheme.text.copyWith(
                      color: textColor,
                      // color: textColor ?? Apptheme.mistyGray,
                    ),
              ),
            if (isNotNull(child)) child!,
          ],
        ),
      );
    }

    return wrapWithFlexible ? Flexible(child: _body()) : _body();
  }

  Widget _body() {
    Color bgColor = color ?? Apptheme.primaryColor;
    Color borderColor = color ?? Apptheme.primaryColor;
    Color? runTextColor = textColor;
    // Color runTextColor = textColor ?? Apptheme.whiteSmoke;

    if (_type.isSecondary) {
      bgColor = Apptheme.transparent;
      runTextColor = textColor ?? color;
      // runTextColor = textColor ?? color ?? Apptheme.darkSlateGray;
      // borderColor = Apptheme.silver;
    }
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            padding:
                padding ?? EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              gradient: gradient,
              color: isNotNull(gradient) ? null : bgColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: borderColor),
                borderRadius: BorderRadius.circular(isRectangle ? 8 : 50),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: mainAxisSize,
              spacing: 5,
              children: [
                if (isNotNull(prefix)) prefix!,
                if (isNotNull(text))
                  Flexible(
                    child: Text(
                      text!,
                      textAlign: TextAlign.center,
                      style:
                          style ??
                          Apptheme.text.copyWith(
                            color: runTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                if (isNotNull(child)) child!,
                if (isNotNull(suffix)) suffix!,
              ],
            ),
          ),
        ),
        if (loading)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(color: Apptheme.black.withAlpha(60)),
              child: Center(
                child: CircularProgressIndicator(color: Apptheme.white),
              ),
            ),
          ),
      ],
    );
  }
}
