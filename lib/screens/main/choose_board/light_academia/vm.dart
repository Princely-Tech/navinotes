import 'package:navinotes/packages.dart';

class BoardLightAcadVm extends ChangeNotifier {
  bool isPrivate = true;

  void updateIsPrivate(bool value) {
    isPrivate = value;
    notifyListeners();
  }
  void createHandler(){
    NavigationHelper.push(Routes.boardPlainEdit);
  }
}
