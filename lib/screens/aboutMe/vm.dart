import 'package:flutter/material.dart';

class AboutMeVm extends ChangeNotifier {
  List<String> selectedApplicationReasons = [];

  void selectApplicationReason(String reason) {
    if (selectedApplicationReasons.contains(reason)) {
      selectedApplicationReasons.remove(reason);
    } else {
      selectedApplicationReasons.add(reason);
    }
    notifyListeners();
  }
}

List<String> applicationReasons = [
  'Studying for exams',
  'Project planning',
  'Research organization',
  'Creative brainstorming',
  'Course notes',
  'Other',
];
