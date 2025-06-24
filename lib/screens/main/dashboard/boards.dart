import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';
import 'package:navinotes/screens/main/dashboard/widgets.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class YourBoards extends StatelessWidget {
  const YourBoards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(
      builder: (context, vm, child) {
        return Column(
          spacing: 20,
          children: [DashFilterSection(title: 'Your Boards'), _boards(vm)],
        );
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
                    style: AppTheme.text.copyWith(
                      fontSize: 16.0,
                      fontWeight: getFontWeight(500),
                    ),
                  ),
                  Text(
                    'Last edited: $lastEdited',
                    style: AppTheme.text.copyWith(color: AppTheme.steelMist),
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Flexible(
                        child: CustomTag(
                          '$notes notes',
                          color: AppTheme.paleBlue,
                          textColor: AppTheme.electricIndigo,
                        ),
                      ),
                      Flexible(
                        child: CustomTag(
                          '$mindmaps mindmaps',
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
        DashboardCreateCard(),
      ],
    );
  }
}
