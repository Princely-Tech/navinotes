import 'package:flutter/material.dart';

bool isNotNull(dynamic value) => value != null;

bool isNull(dynamic value) => value == null;

void logError(String message) {
  debugPrint(message);
}
