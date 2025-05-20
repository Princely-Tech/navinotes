import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/widgets/buttons.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/custom_grid.dart';
import 'package:provider/provider.dart';

class YourBoards extends StatelessWidget {
  const YourBoards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (context, vm, child) {
        return Column(spacing: 20, children: [_header(), _boards(vm)]);
      },
    );
  }

  Widget _boardCard(
    DashboardVm vm, {
    required String title,
    required String lastEdited,
    required String image,
    required int notes,
    required int mindmaps,
  }) {
    return InkWell(
      onTap: vm.goToBoardNotes,
      child: CustomCard(
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
      ),
    );
  }

  Widget _boards(DashboardVm vm) {
    return CustomGrid(
      children: [
        _boardCard(
          vm,
          title: 'Physics 101',
          lastEdited: 'May 1, 2025',
          image: Images.board1,
          notes: 12,
          mindmaps: 4,
        ),
        _boardCard(
          vm,
          title: 'Project Ideas',
          lastEdited: 'April 29, 2025',
          image: Images.board2,
          notes: 8,
          mindmaps: 3,
        ),
        _boardCard(
          vm,
          title: 'Literature Notes',
          lastEdited: 'April 27, 2025',
          image: Images.board3,
          notes: 15,
          mindmaps: 2,
        ),
        _boardCard(
          vm,
          title: 'Biology 202',
          lastEdited: 'April 25, 2025',
          image: Images.board4,
          notes: 10,
          mindmaps: 5,
        ),
        _boardCard(
          vm,
          title: 'Spanish Vocabulary',
          lastEdited: 'April 22, 2025',
          image: Images.board5,
          notes: 18,
          mindmaps: 1,
        ),
        CreateCard(onTap: vm.goToCreateBoard, text: 'Create New Board'),
      ],
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
