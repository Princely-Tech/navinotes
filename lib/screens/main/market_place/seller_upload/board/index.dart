import 'main.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class SellerSelectContentScreen extends StatelessWidget {
  SellerSelectContentScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionManager>(
      builder: (_, sessionVm, _) {
        return ChangeNotifierProvider(
          create:
              (_) =>
                  SellerSelectContentVm(scaffoldKey: _scaffoldKey, sessionVm: sessionVm),
          child: Consumer<SellerSelectContentVm>(
            builder: (_, vm, _) {
              bool hasData = sessionVm.userBoards.isNotEmpty;
              String activeRoute = Routes.dashboard;
              return ScaffoldFrame(
                backgroundColor: hasData ? AppTheme.lightGray : AppTheme.white,
                scaffoldKey: _scaffoldKey,
                body: ResponsiveSection(
                  mobile: SellerSelectMain(),
                  desktop: Row(
                    children: [
                      WidthLimiter(
                        mobile: 255,
                        child: NavigationSideBar(activeRoute: activeRoute),
                      ),
                      Expanded(child: SellerSelectMain()),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
