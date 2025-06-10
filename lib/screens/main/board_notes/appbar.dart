import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/board_notes/shared.dart';
import 'package:navinotes/screens/main/board_notes/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class BoardNotesAppBar extends StatelessWidget {
  const BoardNotesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotesVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: ShapeDecoration(
            color: Apptheme.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Apptheme.lightGray),
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
                  child: Icon(Icons.menu, color: Apptheme.stormGray),
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
      prefixIcon: Icon(Icons.search, color: Apptheme.slateGray, size: 20),
      hintText: 'Search in this board',
      fillColor: Apptheme.lightAsh,
      side: BorderSide.none,
      hintStyle: Apptheme.text.copyWith(
        color: Apptheme.slateGray,
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
          child: Icon(Icons.arrow_back, size: 24, color: Apptheme.strongBlue),
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
                  decoration: BoxDecoration(color: Apptheme.paleBlue),
                  child: Text(
                    'N',
                    style: Apptheme.text.copyWith(
                      color: Apptheme.strongBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ), 
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppStrings.appName,
                          style: Apptheme.text.copyWith(
                            color: Apptheme.persianBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '  /  ',
                          style: Apptheme.text.copyWith(
                            color: Apptheme.blueGray,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: 'Physics 101',
                          style: Apptheme.text.copyWith(
                            color: Apptheme.darkSlateGray,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
