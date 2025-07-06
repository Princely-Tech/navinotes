import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/main/choose_board/plain/note_page/shared.dart';
import 'package:navinotes/screens/main/choose_board/plain/note_page/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class BoardPlainNotePageAside extends StatelessWidget {
  const BoardPlainNotePageAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (context, layoutVm, child) {
        return Consumer<BoardPlainNotePageVm>(
          builder: (context, vm, child) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.white,
                border: Border(
                  right: BorderSide(width: 2, color: AppTheme.lightGray),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ScrollableController(
                      mobilePadding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VisibleController(
                            mobile: getMenuVisible(layoutVm.deviceType),
                            child: Column(children: [_actionRow(), _divider()]),
                          ),
                          _boardDetails(),
                          _divider(),
                          _tags(),
                          _divider(),
                          _recentlyViewed(),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20), child: _footer()),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _actionRow() {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [NewNotesButton(isAside: true), NotesAppBarActions()],
    );
  }

  Widget _footer() {
    return Column(
      spacing: 10,
      children: [
        AppButton(
          onTap: () => NavigationHelper.push(Routes.boardPlainMindMap),
          text: 'View Mind Map',
          minHeight: 40,
          prefix: SVGImagePlaceHolder(
            imagePath: Images.logo,
            size: 16,
            color: AppTheme.white,
          ),
        ),
        Text(
          'See how your notes are connected',
          textAlign: TextAlign.center,
          style: AppTheme.text.copyWith(
            color: AppTheme.steelMist,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _recentItem({required String title, required String lastEdited}) {
    return Row(
      spacing: 15,
      children: [
        OutlinedChild(
          size: 32,
          decoration: BoxDecoration(color: AppTheme.paleBlue),
          child: SVGImagePlaceHolder(imagePath: Images.file, size: 16),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(title, style: AppTheme.text),
              Text(
                lastEdited,
                style: AppTheme.text.copyWith(
                  color: AppTheme.steelMist,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recentlyViewed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 30,
      children: [
        Text('Recently Viewed', style: AppTheme.text),
        _recentItem(title: 'Wave Properties', lastEdited: '2 hours ago'),
        _recentItem(title: 'Newton\'s Laws', lastEdited: 'Yesterday'),
        _recentItem(title: 'Thermodynamics', lastEdited: '3 days ago'),
      ],
    );
  }

  Widget _tags() {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20,
          children: [
            Flexible(child: Text('Tags', style: AppTheme.text)),
            AppButton.text(
              onTap: () {},
              text: 'Edit',
              color: AppTheme.strongBlue,
            ),
          ],
        ),
        Wrap(
          runSpacing: 15,
          spacing: 10,
          children: [
            CustomTag(
              'Physics',
              color: AppTheme.paleBlue,
              textColor: AppTheme.electricIndigo,
            ),
            CustomTag(
              'Science',
              color: AppTheme.lightMintGreen,
              textColor: AppTheme.emeraldGreen,
            ),
            CustomTag(
              'Study',
              color: AppTheme.purple,
              textColor: AppTheme.royalViolet,
            ),
            CustomTag(
              'Exam Prep',
              color: AppTheme.yellow,
              textColor: AppTheme.burntSienna,
            ),
          ],
        ),
      ],
    );
  }

  Widget _divider() {
    return Divider(color: AppTheme.lightGray, height: 40);
  }

  Widget _detailItem({
    required String title,
    required String value,
    required String icon,
  }) {
    return Row(
      spacing: 8,
      children: [
        SVGImagePlaceHolder(imagePath: icon, size: 14),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title:  ',
                  style: AppTheme.text.copyWith(color: AppTheme.steelMist),
                ),
                TextSpan(
                  text: value,
                  style: AppTheme.text.copyWith(color: AppTheme.darkSlateGray),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _boardDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text('Board Details', style: AppTheme.text.copyWith(fontSize: 18.0)),
        _detailItem(
          title: 'Created',
          value: 'April 10, 2025',
          icon: Images.calender,
        ),
        _detailItem(title: 'Pages', value: '8 note pages', icon: Images.file),
        _detailItem(title: 'Owner', value: 'John Doe', icon: Images.person),
      ],
    );
  }
}
