import 'package:navinotes/packages.dart';

class CustomInputField extends StatefulWidget {
  CustomInputField({
    super.key,
    this.label,
    this.hintText,
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
    this.onChanged,
    this.contentPadding,
    this.focusNode,
  }) : controller = controller ?? TextEditingController();

  final String? label;
  final Widget? labelRight;
  // final bool isTextArea;
  // final bool isRectangle;
  final String? hintText;
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
  final void Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return widget.wrapWithExpanded ? Expanded(child: _body()) : _body();
  }

  Widget _body() {
    TextStyle style = widget.style ?? AppTheme.text.copyWith(fontSize: 16.0);
    bool isPassword = widget.keyboardType == TextInputType.visiblePassword;
    double padding = 12;
    Widget? prefix;
    Widget? suffix;
    if (isNotNull(widget.prefixIcon)) {
      prefix = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: padding),
            child: widget.prefixIcon!,
          ),
        ],
      );
    }

    if (isNotNull(widget.suffixIcon)) {
      suffix = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: padding),
            child: widget.suffixIcon!,
          ),
        ],
      );
    }

    bool isSelect = isNotNull(widget.selectItems);
    if (isSelect) {
      suffix = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.keyboard_arrow_down,
            color: style.color ?? AppTheme.black,
            size: style.fontSize! + 5,
          ),
        ],
      );
      // suffix = Padding(
      //   padding: suffixPadding,
      // child: Icon(
      //   Icons.keyboard_arrow_down,
      //   color: style.color ?? AppTheme.black,
      //   size: style.fontSize! + 5,
      // ),
      // );
    }

    // Color fillColor = isSelect ? AppTheme.transparent : AppTheme.polar;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 8,
      children: [
        if (isNotNull(widget.label) || isNotNull(widget.labelRight))
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              spacing: 15,
              children: [
                if (isNotNull(widget.label))
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
          ),
        TextFormField(
          onChanged: widget.onChanged,
          readOnly: isSelect,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          controller: widget.controller,
          maxLines: widget.maxLines,
          onTap: isSelect ? _showCenterDialog : null,
          focusNode: widget.focusNode,
          decoration: _inputDecoration(
            // hintText: widget.hintText,
            prefixIcon: prefix,
            suffixIcon: suffix,
            // border: widget.border,
            // constraints: widget.constraints,
            // side: widget.side,
            // fillColor: widget.fillColor,
          ).copyWith(
            hintStyle:
                widget.hintStyle ??
                AppTheme.text.copyWith(
                  color: AppTheme.slateGray,
                  fontSize: 16.0,
                ),
          ),
          keyboardType: widget.keyboardType,
          obscureText: isPassword ? true : false,
          style: style,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    // String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    // OutlineInputBorder? border,
    // Color? fillColor,
    // BoxConstraints? constraints,
    // BorderSide? side,
  }) {
    OutlineInputBorder defaultBorder =
        widget.border ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              widget.side ?? BorderSide(color: AppTheme.coolGray, width: 1),
        );

    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: AppTheme.text.copyWith(
        // color: AppTheme.inputPlaceholderColor,
        fontSize: 16.0,
      ),
      isDense: true,
      border: defaultBorder,
      enabledBorder: defaultBorder,
      focusedBorder: defaultBorder.copyWith(
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      fillColor: widget.fillColor ?? AppTheme.white,
      filled: true,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      maintainHintHeight: true,
      constraints: widget.constraints,
      contentPadding:
          widget.contentPadding ??
          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
