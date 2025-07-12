import 'package:navinotes/packages.dart';
import 'footer.dart';
import 'main.dart';
import 'appbar.dart';
import 'left.dart';
import 'right.dart';
import 'vm.dart';

class FlashCardsScreen extends StatelessWidget {
  FlashCardsScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = FlashCardsVm(scaffoldKey: _scaffoldKey);
        vm.initialize();
        return vm;
      },
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        drawer: CustomDrawer(child: FlashCardsLeft()),
        endDrawer: CustomDrawer(child: FlashcardsRight()),
        backgroundColor: AppTheme.whiteSmoke,
        body: Column(
          children: [
            FlashCardsAppBar(),
            Expanded(
              child: ResponsiveSection(
                mobile: FlashCardsMain(),
                laptop: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VisibleController(
                      mobile: false,
                      desktop: true,
                      child: WidthLimiter(mobile: 256, child: FlashCardsLeft()),
                    ),
                    Expanded(child: FlashCardsMain()),
                    WidthLimiter(mobile: 256, child: FlashcardsRight()),
                  ],
                ),
              ),
            ),
            FlashCardsFooter(),
          ],
        ),
      ),
    );
  }
}
