import 'package:navinotes/packages.dart';
import 'footer.dart';
import 'main.dart';
import 'appbar.dart';
import 'left.dart';
import 'right.dart';
import 'vm.dart';

class FlashCardsManualCreationScreen extends StatelessWidget {
  FlashCardsManualCreationScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final deck = ModalRoute.of(context)?.settings.arguments as FlashCardDeck;
    return ChangeNotifierProvider(
      create: (context) {
        final vm = FlashCardsManualCreationVm(
          scaffoldKey: _scaffoldKey,
          context: context,
          deck: deck,
        );
        vm.initialize();
        return vm;
      },
      child: Consumer<FlashCardsManualCreationVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            drawer: CustomDrawer(child: FlashCardsManualCreationLeft()),
            endDrawer: CustomDrawer(child: FlashCardsManualCreationRight()),
            backgroundColor: AppTheme.whiteSmoke,
            body: LoadingIndicator(
              loading: vm.loading,
              child: Column(
                children: [
                  FlashCardsManualCreationAppBar(),
                  Expanded(
                    child: ResponsiveSection(
                      mobile: FlashCardsManualCreationMain(),
                      laptop: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VisibleController(
                            mobile: false,
                            desktop: true,
                            child: WidthLimiter(
                              mobile: 256,
                              child: FlashCardsManualCreationLeft(),
                            ),
                          ),
                          Expanded(child: FlashCardsManualCreationMain()),
                          WidthLimiter(
                            mobile: 256,
                            child: FlashCardsManualCreationRight(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlashCardsManualCreationFooter(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
