import 'package:navinotes/packages.dart';

class BoardNatureEditVm extends ChangeNotifier {
  bool isPrivate = true;

  void updateIsPrivate(bool value) {
    isPrivate = value;
    notifyListeners();
  }

  void createHandler() {
    NavigationHelper.push(Routes.boardNatureEdit);
  }
}
