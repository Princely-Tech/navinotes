import 'package:navinotes/packages.dart';
import 'shared.dart';

class BoardPlainNotePageAppBar extends StatelessWidget {
  const BoardPlainNotePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        final board = vm.board;
        return Container(
          decoration: ShapeDecoration(
            color: AppTheme.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppTheme.lightGray),
            ),
          ),
          padding: EdgeInsets.all(15),
          child: Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ResponsiveSection(
                mobile: _leading(board),
                desktop: Flexible(child: _leading(board)),
              ),
              ResponsiveSection(
                mobile: Expanded(child: _searchField()),
                desktop: WidthLimiter(mobile: 512, child: _searchField()),
              ),
              ResponsiveSection(
                mobile: InkWell(
                  onTap: vm.openDrawer,
                  child: Icon(Icons.menu, color: AppTheme.stormGray),
                ),
                desktop: NotesAppBarActions(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _searchField() {
    return NotePageSearchDropdown(
      input: CustomInputField(
        prefixIcon: Icon(Icons.search, color: AppTheme.slateGray, size: 20),
        hintText: 'Search in this board',
        fillColor: AppTheme.lightAsh,
        side: BorderSide.none,
        hintStyle: AppTheme.text.copyWith(
          color: AppTheme.slateGray,
          height: 1.43,
        ),
      ),
    );
  }

  Widget _leading(Board board) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        InkWell(
          onTap: NavigationHelper.pop,
          child: Icon(Icons.arrow_back, size: 24, color: AppTheme.strongBlue),
        ),

        VisibleController(
          mobile: false,
          tablet: true,
          child: Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                SVGImagePlaceHolder(imagePath: Images.logo, size: 32),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppStrings.appName,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.vividRose,
                            fontSize: 18.0,
                            fontWeight: getFontWeight(500),
                          ),
                        ),
                        TextSpan(
                          text: '  /  ',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.blueGray,
                            fontSize: 16.0,
                          ),
                        ),
                        TextSpan(
                          text: getSlicedBoardName(board),
                          style: AppTheme.text.copyWith(
                            color: AppTheme.darkSlateGray,
                            fontSize: 16.0,
                            fontWeight: getFontWeight(500),
                          ),
                        ),
                      ],
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
}
