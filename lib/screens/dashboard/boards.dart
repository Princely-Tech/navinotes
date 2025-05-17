import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/widgets/buttons.dart';
import 'package:navinotes/widgets/components.dart';

double defaultSpacing = 30;

class YourBoards extends StatelessWidget {
  const YourBoards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 20, children: [_header(), _boards()]);
  }

  Widget _boardCard({
    required String title,
    required String lastEdited,
    required String image,
    required int notes,
    required int mindmaps,
  }) {
    return CustomCard(
      // edgeClipRadius: 12,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 6 / 2,
            child: ImagePlaceHolder(imagePath: image, isCardHeader: true),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Text(
                  title,
                  style: Apptheme.text.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Last edited: $lastEdited',
                  style: Apptheme.text.copyWith(color: Apptheme.steelMist),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Flexible(
                      child: CustomTag(
                        '$notes notes',
                        color: Apptheme.paleBlue,
                        textColor: Apptheme.electricIndigo,
                      ),
                    ),
                    Flexible(
                      child: CustomTag(
                        '$mindmaps mindmaps',
                        color: Apptheme.lightMintGreen,
                        textColor: Apptheme.emeraldGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createBoard() {
    return CustomCard(
      child: Column(
        spacing: 15,
        children: [
          CustomCard(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Apptheme.paleBlue,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.zero,
            child: Icon(Icons.add, color: Apptheme.vividBlue),
          ),
          Column(
            spacing: 5,
            children: [
              Text(
                'Create New Board',
                style: Apptheme.text.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Start organizing your ideas',
                style: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _boards() {
    Widget board1 = _boardCard(
      title: 'Physics 101',
      lastEdited: 'May 1, 2025',
      image: Images.board1,
      notes: 12,
      mindmaps: 4,
    );
    Widget board2 = _boardCard(
      title: 'Project Ideas',
      lastEdited: 'April 29, 2025',
      image: Images.board2,
      notes: 8,
      mindmaps: 3,
    );
    Widget board3 = _boardCard(
      title: 'Literature Notes',
      lastEdited: 'April 27, 2025',
      image: Images.board3,
      notes: 15,
      mindmaps: 2,
    );
    Widget board4 = _boardCard(
      title: 'Biology 202',
      lastEdited: 'April 25, 2025',
      image: Images.board4,
      notes: 10,
      mindmaps: 5,
    );
    Widget board5 = _boardCard(
      title: 'Spanish Vocabulary',
      lastEdited: 'April 22, 2025',
      image: Images.board5,
      notes: 18,
      mindmaps: 1,
    );

    return ResponsiveSection(
      mobile: Column(
        spacing: defaultSpacing,
        children: [board1, board2, board3, board4, board5, _createBoard()],
      ),
      laptops: Column(
        spacing: defaultSpacing,
        children: [
          _customRow(
            children: [Expanded(child: board1), Expanded(child: board2)],
          ),
          _customRow(
            children: [Expanded(child: board3), Expanded(child: board4)],
          ),
          _customRow(
            children: [
              Expanded(child: board5),
              Expanded(child: _createBoard()),
            ],
          ),
        ],
      ),
      largeDesktops: Column(
        spacing: defaultSpacing,
        children: [
          _customRow(
            children: [
              Expanded(child: board1),
              Expanded(child: board2),
              Expanded(child: board3),
            ],
          ),
          _customRow(
            children: [
              Expanded(child: board4),
              Expanded(child: board5),
              Expanded(child: _createBoard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _customRow({required List<Widget> children}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: defaultSpacing,
      children: children,
    );
  }

  Widget _header() {
    return Row(
      spacing: 30,
      children: [
        Expanded(
          child: Text(
            'Your Boards',
            style: Apptheme.text.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            AppButton(
              wrapWithFlexible: true,
              mainAxisSize: MainAxisSize.min,
              prefix: SVGImagePlaceHolder(imagePath: Images.arrowVer),
              onTap: () {},
              color: Apptheme.white,
              style: Apptheme.text.copyWith(color: Apptheme.stormGray),
              minHeight: 29,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              text: 'Sort',
            ),
            AppButton(
              wrapWithFlexible: true,
              mainAxisSize: MainAxisSize.min,
              prefix: SVGImagePlaceHolder(imagePath: Images.filter),
              onTap: () {},
              color: Apptheme.white,
              style: Apptheme.text.copyWith(color: Apptheme.stormGray),
              minHeight: 29,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              text: 'Filter',
            ),
          ],
        ),
      ],
    );
  }
}
