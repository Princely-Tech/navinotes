import 'package:navinotes/packages.dart';
import 'footer.dart';
import 'main.dart';
import 'appbar.dart';
import 'aside.dart';
import 'vm.dart';

class MarketPlaceScreen extends StatelessWidget {
  MarketPlaceScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MarketPlaceVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        drawer: CustomDrawer(child: MarketPlaceAside()),
        body: Column(
          children: [
            MarketplaceAppBar(),
            Expanded(
              child: ResponsiveSection(
                mobile: MarketplaceMain(),
                desktop: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidthLimiter(mobile: 256, child: MarketPlaceAside()),
                    Expanded(child: MarketplaceMain()),
                  ],
                ),
              ),
            ),
            MarketplaceFooter(),
          ],
        ),
      ),
    );
  }
}
