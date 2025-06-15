import 'package:navinotes/packages.dart';

class DarkAcademiaVm extends ChangeNotifier {
  bool isPrivate = true;

  void updateIsPrivate(bool value) {
    isPrivate = value;
    notifyListeners();
  }
}
