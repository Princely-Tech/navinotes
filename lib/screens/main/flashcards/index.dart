import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/header.dart';
import 'vm.dart';

class FlashCardScreen extends StatelessWidget {
  const FlashCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionManager>(
      builder: (_, sessionVm, _) {
        final boards = sessionVm.userBoards;
        return ChangeNotifierProvider(
          create:
              (context) => FlashCardVm(sessionVm: sessionVm, context: context),
          child: Consumer<FlashCardVm>(
            builder: (_, vm, _) {
              return ScaffoldFrame(
                body: LoadingIndicator(
                  loading: vm.creatingDeck,
                  child: Column(
                    spacing: 15,
                    children: [
                      FlashCardsAppBar(),
                      Expanded(
                        child: ScrollableController(
                          child: ResponsivePadding(
                            mobile: EdgeInsets.all(10),
                            tablet: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: CustomGrid(
                              children: [
                                ...boards.map(
                                  (board) => BoardCard(
                                    board: board,
                                    onTap: () => vm.showBoardDecks(board),
                                  ),
                                ),
                                CreateCard(
                                  onTap: vm.goToCreateBoard,
                                  text: 'Create New Board',
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
