import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/board_notes/shared.dart';
import 'package:navinotes/screens/main/board_notes/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class BoardNotesAppBar extends StatelessWidget {
  const BoardNotesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotesVm>(
      builder: (_, vm, _) {
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
                mobile: _leading(),
                desktop: Flexible(child: _leading()),
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
    return CustomInputField(
      prefixIcon: Icon(Icons.search, color: AppTheme.slateGray, size: 20),
      hintText: 'Search in this board',
      fillColor: AppTheme.lightAsh,
      side: BorderSide.none,
      hintStyle: AppTheme.text.copyWith(
        color: AppTheme.slateGray,
        height: 1.43,
      ),
    );
  }

  Widget _leading() {
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
                OutlinedChild(
                  decoration: BoxDecoration(color: AppTheme.paleBlue),
                  child: Text(
                    'N',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.strongBlue,
                      fontSize: 16.0,
                      fontWeight: getFontWeight(600),
                    ),
                  ),
                ),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppStrings.appName,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.persianBlue,
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
                          text: 'Physics 101',
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
