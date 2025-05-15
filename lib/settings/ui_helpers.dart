import 'package:flutter/material.dart';

double defaultHorizontalPadding = 20;

class UiHelpers {
  UiHelpers._();
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

Size deviceSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
