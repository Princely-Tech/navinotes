import 'package:navinotes/packages.dart';
import 'package:navinotes/widgets/flashcard_study_widget.dart';
import 'footer.dart';
import 'aside.dart';
import 'header.dart';
import 'vm.dart';

class FlashCardStudyScreen extends StatelessWidget {
  FlashCardStudyScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final deck = ModalRoute.of(context)?.settings.arguments as Content;
    return ChangeNotifierProvider(
      create: (context) {
        final vm = FlashCardStudyVm(
          scaffoldKey: _scaffoldKey,
          context: context,
          deck: deck,
        );
        vm.initialize();
        return vm;
      },
      child: ScaffoldFrame(
        backgroundColor: const Color(0xFFF9FAFB),
        scaffoldKey: _scaffoldKey,
        endDrawer: CustomDrawer(child: const FlashCardStudyAside()),
        body: Column(
          children: [
            const FlashCardStudyHeader(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _main()),
                  VisibleController(
                    mobile: false,
                    desktop: true,
                    child: WidthLimiter(
                      mobile: 288,
                      child: const FlashCardStudyAside(),
                    ),
                  ),
                ],
              ),
            ),
            const FlashCardStudyFooter(),
          ],
        ),
      ),
    );
  }

  Widget _main() {
    return Consumer<FlashCardStudyVm>(
      builder: (_, vm, _) {
        return FlashcardStudyWidget(
          vm: vm,
          showProgressIndicator: true,
          showActions: true,
        );
      },
    );
  }
}
