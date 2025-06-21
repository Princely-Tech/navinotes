import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/main/board_notes/shared.dart';
import 'package:navinotes/screens/main/board_notes/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class BoardNotesAside extends StatelessWidget {
  const BoardNotesAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (context, layoutVm, child) {
        return Consumer<BoardNotesVm>(
          builder: (context, vm, child) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Apptheme.white,
                border: Border(
                  right: BorderSide(width: 2, color: Apptheme.lightGray),
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
          onTap: () {},
          text: 'View Mind Map',
          minHeight: 40,
          prefix: SVGImagePlaceHolder(
            imagePath: Images.logo,
            size: 16,
            color: Apptheme.white,
          ),
        ),
        Text(
          'See how your notes are connected',
          textAlign: TextAlign.center,
          style: Apptheme.text.copyWith(
            color: Apptheme.steelMist,
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
          decoration: BoxDecoration(color: Apptheme.paleBlue),
          child: SVGImagePlaceHolder(imagePath: Images.file, size: 16),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(title, style: Apptheme.text),
              Text(
                lastEdited,
                style: Apptheme.text.copyWith(
                  color: Apptheme.steelMist,
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
        Text('Recently Viewed', style: Apptheme.text),
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
            Flexible(child: Text('Tags', style: Apptheme.text)),
            AppButton.text(
              onTap: () {},
              text: 'Edit',
              color: Apptheme.strongBlue,
            ),
          ],
        ),
        Wrap(
          runSpacing: 15,
          spacing: 10,
          children: [
            CustomTag(
              'Physics',
              color: Apptheme.paleBlue,
              textColor: Apptheme.electricIndigo,
            ),
            CustomTag(
              'Science',
              color: Apptheme.lightMintGreen,
              textColor: Apptheme.emeraldGreen,
            ),
            CustomTag(
              'Study',
              color: Apptheme.purple,
              textColor: Apptheme.royalViolet,
            ),
            CustomTag(
              'Exam Prep',
              color: Apptheme.yellow,
              textColor: Apptheme.burntSienna,
            ),
          ],
        ),
      ],
    );
  }

  Widget _divider() {
    return Divider(color: Apptheme.lightGray, height: 40);
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
                  style: Apptheme.text.copyWith(color: Apptheme.steelMist),
                ),
                TextSpan(
                  text: value,
                  style: Apptheme.text.copyWith(color: Apptheme.darkSlateGray),
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
        Text('Board Details', style: Apptheme.text.copyWith(fontSize: 18.0)),
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
