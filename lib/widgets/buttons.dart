import 'package:navinotes/packages.dart';

enum ButtonType {
  primary,
  secondary,
  text;

  // bool get isPrimary => this == primary;
  bool get isSecondary => this == secondary;
  bool get isText => this == text;
}

const defaultMinHeight = 50.0;

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    ButtonType type = ButtonType.primary,
    this.text,
    this.borderColor,
    this.child,
    this.style,
    // this.loading = false,
    this.loading = false,
    this.shape,
    required this.onTap,
    this.prefix,
    this.color = AppTheme.vividRose,
    this.wrapWithFlexible = false,
    this.suffix,
    this.minHeight = defaultMinHeight,
    this.padding,
    this.mainAxisSize = MainAxisSize.max,
    this.textColor,
    this.gradient,
    this.spacing,

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
    this.spacing,
    // this.isRectangle = true,
    required this.onTap,
    this.prefix,
    this.suffix,
    this.color = AppTheme.vividRose,
    this.loading = false,
    this.wrapWithFlexible = false,
    this.style,
    this.minHeight = defaultMinHeight,
    this.mainAxisSize = MainAxisSize.max,
    this.padding,
    this.textColor,
    this.gradient,
    this.shape,
    this.borderColor,
  }) : _type = ButtonType.secondary,
       assert(
         (text == null || child == null),
         AppStrings.mustProvideTextOrChild,
       );

  const AppButton.text({
    super.key,
    this.text,
    this.child,
    this.borderColor,
    required this.onTap,
    this.wrapWithFlexible = false,
    this.prefix,
    this.suffix,
    this.color = AppTheme.vividRose,
    this.padding,
    this.style,
    this.loading = false,
    this.minHeight = 10,
    this.textColor,
    this.gradient,
    this.mainAxisSize = MainAxisSize.min,
    this.shape,
    this.spacing,
  }) : _type = ButtonType.text,
       assert(
         (text == null || child == null),
         AppStrings.mustProvideTextOrChild,
       );

  final ButtonType _type;
  final double? spacing;
  final String? text;
  // final bool isRectangle;
  final bool loading;
  final bool wrapWithFlexible;
  final VoidCallback onTap;
  final Widget? suffix;
  final Widget? prefix;
  final TextStyle? style;
  final Color color;
  final Widget? child;
  final double minHeight;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final MainAxisSize mainAxisSize;
  final Gradient? gradient;
  final OutlinedBorder? shape;
  final Color? borderColor;
  // final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    if (_type.isText) {
      return wrapWithFlexible ? Flexible(child: _textBody()) : _textBody();
    }
    return wrapWithFlexible ? Flexible(child: _body()) : _body();
  }

  Widget _textBody() {
    return InkWell(
      onTap: onTap,
      child: Row(
        spacing: spacing ?? 5,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: mainAxisSize,
        children: [
          if (isNotNull(prefix)) prefix!,
          if (isNotNull(text))
            wrapWithFlexible ? Flexible(child: _text()) : _text(),
          if (isNotNull(child)) child!,
          if (isNotNull(suffix)) suffix!,
        ],
      ),
    );
  }

  Widget _text() {
    return Text(text!, style: style ?? AppTheme.text.copyWith(color: color));
  }

  Widget _body() {
    Color bgColor = color;
    Color runBorderColor = borderColor ?? color;
    BorderRadius radius = BorderRadius.circular(8);
    OutlinedBorder runShape =
        shape ??
        RoundedRectangleBorder(
          side: BorderSide(
            color: isNotNull(gradient) ? AppTheme.transparent : runBorderColor,
          ),
          borderRadius: radius,
        );
    return Stack(
      children: [
        if (_type.isSecondary)
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              shape: runShape,
              side: BorderSide(color: runBorderColor),
              padding: EdgeInsets.zero,
            ),
            child: _btnMain(),
          )
        else
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: bgColor,
              shape: runShape,
              elevation: 0,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: radius,
              ),
              child: _btnMain(),
            ),
          ),
        if (loading)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(color: AppTheme.black.withAlpha(60)),
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _btnMain() {
    Color? runTextColor = textColor ?? AppTheme.white;
    if (_type.isSecondary) {
      runTextColor = textColor ?? color;
    }
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: padding ?? EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      // padding: padding ?? EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: mainAxisSize,
        spacing: spacing ?? 5,
        children: [
          if (isNotNull(prefix)) prefix!,
          if (isNotNull(text))
            Flexible(
              child: Text(
                text!,
                textAlign: TextAlign.center,
                style:
                    style ??
                    AppTheme.text.copyWith(color: runTextColor, fontSize: 16.0),
              ),
            ),
          if (isNotNull(child)) child!,
          if (isNotNull(suffix)) suffix!,
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, required this.onPressed, this.decoration});
  final void Function()? onPressed;
  final BoxDecoration? decoration;
  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      onPressed: onPressed,
      icon: Icon(Icons.menu, color: decoration?.color ?? AppTheme.stormGray),
    );
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key, required this.onPressed, required this.icon});
  final void Function()? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed, icon: icon);
  }
}
