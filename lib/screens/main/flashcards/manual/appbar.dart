import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/create_vm.dart';

class FlashCardsManualCreationAppBar extends StatelessWidget {
  const FlashCardsManualCreationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: WidthLimiter(
              mobile: largeDesktopSize,
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return Consumer<FlashCardCreationVm>(
                    builder: (_, vm, _) {
                      return ScrollableController(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: ResponsivePadding(
                            mobile: EdgeInsets.all(10),
                            tablet: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 20,
                              children: [
                                Row(
                                  children: [
                                    VisibleController(
                                      mobile: true,
                                      desktop: false,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 5,
                                        ),
                                        child: MenuButton(
                                          onPressed: vm.openDrawer,
                                        ),
                                      ),
                                    ),
                                    RichTextHeader(
                                      title: vm.props.deck.title,
                                      showLogo: true,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
