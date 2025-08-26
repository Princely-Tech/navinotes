import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/create_vm.dart';
import 'footer.dart';
import 'main.dart';
import 'appbar.dart';
import 'left.dart';
import 'right.dart';

class FlashCardsManualCreationScreen extends StatelessWidget {
  FlashCardsManualCreationScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final props = ModalRoute.of(context)?.settings.arguments as ManualFlashCardProps;
    return ChangeNotifierProvider(
      create: (context) {
        final vm = FlashCardCreationVm(
          scaffoldKey: _scaffoldKey,
          context: context,
          props: props,
        );
        vm.initialize();
        return vm;
      },
      child: Consumer<FlashCardCreationVm>(
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
