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
    final board = ModalRoute.of(context)?.settings.arguments as Board?;
    
    if (board == null) {
      return Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Error: No board data provided',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => SellerUploadVm(
        scaffoldKey: _scaffoldKey,
        board: board,
      ),
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
