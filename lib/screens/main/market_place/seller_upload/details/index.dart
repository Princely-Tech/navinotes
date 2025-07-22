import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/details/preview.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/details/price.dart';
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

    return 
    
    
    ApiServiceComponent(
      child: Consumer<ApiServiceProvider>(
        builder: (_, apiServiceProvider, _) {
          return ChangeNotifierProvider(
            create:
                (context) => SellerUploadVm(scaffoldKey: _scaffoldKey, board: board, apiServiceProvider: apiServiceProvider),
            child: Consumer<SellerUploadVm>(
              builder: (_, vm, _) {
                return ScaffoldFrame(
                  scaffoldKey: _scaffoldKey,
                  endDrawer: CustomDrawer(child: SellerUploadAside()),
                  backgroundColor: AppTheme.white,
                  body: Column(
                    children: [
                      SellerUploadAppBar(),
          
                      Expanded(child: showScreen(vm)),
                      SellerUploadFooter(),
                    ],
                  ),
                );
              },
            ),
          );
        }
      ),
    );


    
  }

  showScreen(SellerUploadVm vm) {
    if (vm.currentScreen == Screen.details) {
      return SellerUploadMain(vm: vm);
    } else if (vm.currentScreen == Screen.price) {
      return SellerUploadPrice(vm: vm);
    } else if (vm.currentScreen == Screen.preview) {
      return SellerUploadPreview(vm: vm);
    }
  }
}
