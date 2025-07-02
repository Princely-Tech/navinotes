import 'package:navinotes/packages.dart';
import 'main.dart';
import 'appbar.dart';
import 'aside.dart';
import 'vm.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetailVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        endDrawer: CustomDrawer(
          bgColor: AppTheme.whiteSmoke,
          child: ProductDetailAside(),
        ),
        backgroundColor: AppTheme.whiteSmoke,
        body: Column(
          children: [
            ProductDetailAppBar(),
            Expanded(
              child: ResponsiveSection(
                mobile: ProductDetailMain(),
                desktop: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: ProductDetailMain()),
                    WidthLimiter(mobile: 400, child: ProductDetailAside()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
