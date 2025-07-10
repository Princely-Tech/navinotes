import 'package:navinotes/packages.dart';
import 'footer.dart';
import 'main.dart';
import 'appbar.dart';
import 'aside.dart';
import 'vm.dart';

class SellerUploadScreen extends StatelessWidget {
  SellerUploadScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SellerUploadVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        endDrawer: CustomDrawer(child: SellerUploadAside()),
        backgroundColor: AppTheme.white,
        body: Column(
          children: [
            SellerUploadAppBar(),
            Expanded(child: SellerUploadMain()),
            SellerUploadFooter(),
          ],
        ),
      ),
    );
  }
}
