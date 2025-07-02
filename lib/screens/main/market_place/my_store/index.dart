import 'package:navinotes/packages.dart';
import 'main.dart';
import 'appbar.dart';
import 'aside.dart';
import 'vm.dart';

class MyStoreScreen extends StatelessWidget {
  MyStoreScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyStoreVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        endDrawer: CustomDrawer(child: MyStoreAside()),
        backgroundColor: AppTheme.whiteSmoke,
        body: Column(
          children: [
            MyStoreAppBar(),
            Expanded(
              child: ResponsiveSection(
                mobile: MyStoreMain(),
                desktop: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: MyStoreMain()),
                    WidthLimiter(mobile: 256, child: MyStoreAside()),
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
