import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/board/vm.dart';

class SellerSelectBoards extends StatelessWidget {
  const SellerSelectBoards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerSelectContentVm>(
      builder: (context, vm, child) {
        return Column(
          spacing: 20,
          children: [
            _boards(vm),
          ],
        );
      },
    );
  }

  Widget _boardCard(SellerSelectContentVm vm, {required Board board}) {
    // Get the appropriate image based on board type
    String boardImage = board.getImage();
    
    return InkWell(
      onTap: () => NavigationHelper.push(Routes.sellerUpload, arguments: board),
      child: CustomCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 6 / 2,
              child: ImagePlaceHolder(imagePath: boardImage, isCardHeader: true),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Text(
                    board.name,
                    style: AppTheme.text.copyWith(
                      fontSize: 18.0,
                      fontWeight: getFontWeight(600),
                    ),
                  ),
                  Text(
                    'Last edited ${_formatDate(DateTime.fromMillisecondsSinceEpoch(board.updatedAt * 1000))}',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.steelMist,
                      fontSize: 12.0,
                    ),
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Flexible(
                        child: CustomTag(
                          '0 notes', // TODO: Get actual note count
                          color: AppTheme.paleBlue,
                          textColor: AppTheme.electricIndigo,
                        ),
                      ),
                      Flexible(
                        child: CustomTag(
                          '0 mindmaps', // TODO: Get actual mindmap count
                          color: AppTheme.lightMintGreen,
                          textColor: AppTheme.emeraldGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boards(SellerSelectContentVm vm) {
    final boards = vm.sessionVm.userBoards;
    
    return CustomGrid(
      children: [...boards.map((board) => _boardCard(vm, board: board))],
    );
  }
  
  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }
  
  String _getMonthName(int month) {
    return [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ][month - 1];
  }
}
