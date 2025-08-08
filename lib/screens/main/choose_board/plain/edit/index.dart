import 'overview.dart';
import 'package:navinotes/packages.dart';

class BoardPlainEditScreen extends StatelessWidget {
  const BoardPlainEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Board board = ModalRoute.of(context)?.settings.arguments as Board;
    return ChangeNotifierProvider(
      create: (context) {
        final vm = BoardEditVm(board: board);
        vm.initialize();
        return vm;
      },
      child: Consumer<BoardEditVm>(
        builder: (_, vm, __) {
          return ChooseBoardWrapper(
            //Essential; add loading until ready!!
            child: ScaffoldFrame(
              backgroundColor: AppTheme.white,
              body: _buildContent(vm),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BoardEditVm vm) {
    final board = vm.board;
    return Column(
      children: [
        _header(board),
        _selectRows(),
        Expanded(
          child: ScrollableController(
            mobilePadding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ResponsivePadding(
                    mobile: EdgeInsets.symmetric(horizontal: tabletPadding),
                    child: WidthLimiter(
                      mobile: largeDesktopSize,
                      child: _returnTabItem(vm),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _returnTabItem(BoardEditVm vm) {
    switch (vm.selectedTab) {
      case EditBoardTab.overview:
        return BoardPlainEditOverview(vm);
      case EditBoardTab.uploads:
        return BoardEditUploads(vm);
      case EditBoardTab.assignments:
        return const SizedBox.shrink();
    }
  }

  Widget _header(Board board) {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: AppTheme.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 10),
              Text(
                board.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Add more header actions here
            ],
          ),
        );
      },
    );
  }

  Widget _selectRows() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, __) {
        return TextRowSelect(
          items: EditBoardTab.values.map((item) => item.toString()).toList(),
          borderColor: AppTheme.strongBlue,
          inActiveBorderColor: AppTheme.lightGray,
          padding: const EdgeInsets.symmetric(vertical: 10),
          onSelected: (value) {
            vm.updateSelectedTab(
              stringToEnum<EditBoardTab>(value, EditBoardTab.values),
            );
          },
          selectedTextStyle: AppTheme.text.copyWith(
            color: const Color(0xFF3B82F6),
            fontSize: 16.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 16.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}
