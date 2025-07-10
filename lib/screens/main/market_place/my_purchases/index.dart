import 'package:navinotes/packages.dart';
import 'footer.dart';
import 'main.dart';
import 'appbar.dart';
import 'aside.dart';
import 'vm.dart';

class MyPurchasesScreen extends StatelessWidget {
  MyPurchasesScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyPurchasesVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        drawer: CustomDrawer(child: MyPurchasesAside()),
        backgroundColor: AppTheme.whiteSmoke,
        body: Column(
          children: [
            MyPurchasesAppBar(),
            Expanded(
              child: ResponsiveSection(
                mobile: WidthLimiter(
                  mobile: 256,
                  largeDesktop: 300,
                  child: MyPurchasesAside(),
                ),
                // mobile: MyPurchasesMain(),
                desktop: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidthLimiter(
                      mobile: 256,
                      largeDesktop: 300,
                      child: MyPurchasesAside(),
                    ),
                    Expanded(child: MyPurchasesMain()),
                  ],
                ),
              ),
            ),
            MyPurchasesFooter(),
          ],
        ),
      ),
    );
  }
}
