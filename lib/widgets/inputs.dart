import 'package:navinotes/packages.dart';

InputDecoration _inputDecoration({
  required String hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  OutlineInputBorder? border,
  // bool isRectangle = true,
  // required bool isTextArea,
  Color? fillColor,
  BoxConstraints? constraints,
  BorderSide? side,
}) {
  OutlineInputBorder defaultBorder =
      border ??
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: side ?? BorderSide(color: Apptheme.coolGray, width: 1),
      );

  return InputDecoration(
    hintText: hintText,
    hintStyle: Apptheme.text.copyWith(
      // color: Apptheme.inputPlaceholderColor,
      fontSize: 16,
    ),
    border: defaultBorder,
    enabledBorder: defaultBorder,
    focusedBorder: defaultBorder.copyWith(
      borderSide: BorderSide(color: Apptheme.primaryColor, width: 2),
    ),
    fillColor: fillColor ?? Apptheme.white,
    filled: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    maintainHintHeight: true,
    constraints: constraints,
    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  );
}

class CustomInputField extends StatefulWidget {
  CustomInputField({
    super.key,
    this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.fillColor,
    TextEditingController? controller,
    this.validator,
    // this.footer,
    this.required = false,
    this.optional = false,
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.maxLines = 1,
    this.wrapWithExpanded = false,
    // this.isSearch = false,
    this.selectItems,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.labelRight,
    this.constraints,
    this.side,
  }) : controller = controller ?? TextEditingController();

  final String? label;
  final Widget? labelRight;
  // final bool isTextArea;
  // final bool isRectangle;
  final String hintText;
  final bool optional;
  final BorderSide? side;
  // final String? footer;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool wrapWithExpanded;
  // final bool isSearch;
  // final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool required;
  final OutlineInputBorder? border;
  final int maxLines;
  final List<String>? selectItems;
  final Color? fillColor;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final BoxConstraints? constraints;
  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return widget.wrapWithExpanded ? Expanded(child: _body()) : _body();
  }

  Widget _body() {
    TextStyle style = widget.style ?? Apptheme.text.copyWith(fontSize: 16);
    Widget? prefix;
    Widget? suffix;
    // bool isDate = widget.keyboardType == TextInputType.datetime;
    bool isPassword = widget.keyboardType == TextInputType.visiblePassword;
    double padding = 12;
    // if (widget.keyboardType) {
    //   // prefix = Icon(Icons.search, color: Apptheme.inputPlaceholderColor);
    // }
    String? prefixImg;
    // switch (widget.keyboardType) {
    //   case TextInputType.emailAddress:
    //     prefixImg = Images.email;
    //     break;
    //   case TextInputType.visiblePassword:
    //     prefixImg = Images.padlock;
    //     break;
    // }
    EdgeInsets prefPadding = EdgeInsets.only(left: padding);
    EdgeInsets suffixPadding = EdgeInsets.only(left: 5, right: padding);

    if (isNotNull(prefixImg)) {
      prefix = Padding(
        padding: prefPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [SVGImagePlaceHolder(imagePath: prefixImg!, size: 16)],
        ),
      );
    }
    if (widget.prefixIcon != null) {
      prefix = Padding(padding: prefPadding, child: widget.prefixIcon);
    }

    bool isSelect = isNotNull(widget.selectItems);
    if (isSelect) {
      suffix = Padding(
        padding: suffixPadding,
        child: Icon(
          Icons.keyboard_arrow_down,
          color: style.color ?? Apptheme.black,
          size: style.fontSize! + 5,
        ),
      );
    }

    // Color fillColor = isSelect ? Apptheme.transparent : Apptheme.polar;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (isNotNull(widget.label))
          Row(
            spacing: 15,
            children: [
              Expanded(
                child: Header6(
                  title: widget.label!,
                  required: widget.required,
                  optional: widget.optional,
                  style: widget.labelStyle,
                ),
              ),
              if (isNotNull(widget.labelRight)) widget.labelRight!,
            ],
          ),
        TextFormField(
          readOnly: isSelect,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          controller: widget.controller,
          maxLines: widget.maxLines,
          onTap: isSelect ? _showCenterDialog : null,
          decoration: _inputDecoration(
            hintText: widget.hintText,
            prefixIcon: prefix,
            suffixIcon: suffix,
            border: widget.border,
            constraints: widget.constraints,
            side: widget.side,
            fillColor: widget.fillColor,
          ).copyWith(
            hintStyle:
                widget.hintStyle ??
                Apptheme.text.copyWith(color: Apptheme.slateGray, fontSize: 16),
          ),
          keyboardType: widget.keyboardType,
          obscureText: isPassword ? true : false,
          style: style,
        ),
      ],
    );
  }

  void _showCenterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Select an item"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children:
                  widget.selectItems!
                      .map(
                        (item) => ListTile(
                          title: Text(item),
                          onTap: () {
                            widget.controller.text = item;
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
        );
      },
    );
  }

  // void _showBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (BuildContext context) {
  //       return ListView(
  //         shrinkWrap: true,
  //         children:
  //             widget.selectItems!
  //                 .map(
  //                   (item) => ListTile(
  //                     title: Text(item),
  //                     onTap: () {
  //                       widget.controller.text = item;
  //                       Navigator.pop(context);
  //                     },
  //                   ),
  //                 )
  //                 .toList(),
  //       );
  //     },
  //   );
  // }
}
