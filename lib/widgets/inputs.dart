import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/settings/util_functions.dart';
import 'package:navinotes/widgets/components.dart';

InputDecoration _inputDecoration({
  required String hintText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  OutlineInputBorder? border,
  // bool isRectangle = true,
  // required bool isTextArea,
  Color? fillColor,
}) {
  OutlineInputBorder defaultBorder =
      border ??
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Apptheme.coolGray, width: 1),
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
    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
  }) : controller = controller ?? TextEditingController();

  final String? label;
  // final bool isTextArea;
  // final bool isRectangle;
  final String hintText;
  final bool optional;
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
  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return widget.wrapWithExpanded ? Expanded(child: _body()) : _body();
  }

  Widget _body() {
    Widget? prefix;
    Widget? suffix;
    // bool isDate = widget.keyboardType == TextInputType.datetime;
    bool isPassword = widget.keyboardType == TextInputType.visiblePassword;
    double padding = 12;
    // if (widget.keyboardType) {
    //   // prefix = Icon(Icons.search, color: Apptheme.inputPlaceholderColor);
    // }
    String? prefixImg;
    switch (widget.keyboardType) {
      case TextInputType.emailAddress:
        prefixImg = Images.email;
        break;
      case TextInputType.visiblePassword:
        prefixImg = Images.padlock;
        break;
    }
    if (isNotNull(prefixImg)) {
      prefix = Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: SvgPicture.asset(prefixImg!, width: 16, height: 16),
      );
    }
    if (widget.prefixIcon != null) {
      prefix = Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: widget.prefixIcon,
      );
    }

    bool isSelect = isNotNull(widget.selectItems);
    if (isSelect) {
      suffix = Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Icon(Icons.keyboard_arrow_down, color: Apptheme.black),
      );
    }

    // Color fillColor = isSelect ? Apptheme.transparent : Apptheme.polar;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (isNotNull(widget.label))
          Header6(
            title: widget.label!,
            required: widget.required,
            optional: widget.optional,
            style: widget.labelStyle,
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
            // isTextArea: widget.isTextArea,
            fillColor: widget.fillColor,
          ).copyWith(
            hintStyle: widget.hintStyle ?? Apptheme.text.copyWith(fontSize: 16),
          ),
          keyboardType: widget.keyboardType,
          obscureText: isPassword ? true : false,
          style: widget.style ?? Apptheme.text.copyWith(fontSize: 16),
        ),
        // if (isNotNull(widget.footer))
        //   Text(
        //     widget.footer!,
        //     style: Apptheme.text.copyWith(
        //       color: Apptheme.charcoal,
        //       fontSize: 12,
        //     ),
        //   ),
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
