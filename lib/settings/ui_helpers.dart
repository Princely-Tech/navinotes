import 'package:flutter/material.dart';

class UiHelpers {
  UiHelpers._();
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
