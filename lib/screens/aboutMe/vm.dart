import 'package:flutter/material.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';

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

  void skipHandler() {
    goToDashboard();
  }

  void goToDashboard() {
    NavigationHelper.pushReplacement(Routes.dashboard);
  }

  void saveHandler() {
    goToDashboard();
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
