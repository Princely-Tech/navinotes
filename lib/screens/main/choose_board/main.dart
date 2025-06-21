import 'package:flutter/material.dart';
import 'package:navinotes/models/board.dart';
import 'package:navinotes/screens/main/choose_board/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class ChooseBoardMain extends StatelessWidget {
  const ChooseBoardMain({super.key});

  @override
  Widget build(BuildContext context) {
    BorderSide side = BorderSide(color: Apptheme.lightGray, width: 3);
    return Consumer<ChooseBoardVm>(
      builder: (context, vm, child) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border(top: side, right: side)),
          child: Column(
            spacing: 10,
            children: [
              Expanded(
                child: ScrollableController(
                  mobile: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      _searchInput(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 15,
                        children: [
                          Text(
                            'Select a style for your board',
                            style: Apptheme.text.copyWith(
                              color: Apptheme.vividRose,
                              fontSize: 18.0,
                              fontWeight: getFontWeight(600),
                            ),
                          ),
                          CustomGrid(
                            children: [
                              ...boardTypes.map(
                                (board) => _board(vm, board: board),
                              ),
                              _customCreateBoard(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _customCreateBoard() {
    return _cardFrame(
      title: 'Custom',
      header: SizedBox(
        height: 140,
        width: double.infinity,
        child: Column(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SVGImagePlaceHolder(imagePath: Images.draw, size: 36),
            Text(
              'Create your own',
              textAlign: TextAlign.center,
              style: Apptheme.text.copyWith(
                color: Apptheme.vividBlue,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      description: 'Personalize your own style',
    );
  }

  Widget _cardFrame({
    required String title,
    required Widget header,
    required String description,
    bool selected = false,
    void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          CustomCard(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: selected ? Apptheme.vividRose : Apptheme.pastelBloom,
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 25,
              children: [
                Expanded(child: header),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      title,
                      style: Apptheme.text.copyWith(
                        color: Apptheme.abyssTeal,
                        fontSize: 16.0,
                        fontWeight: getFontWeight(500),
                      ),
                    ),
                    Text(
                      description,
                      style: Apptheme.text.copyWith(
                        color: Apptheme.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (selected)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(Icons.check_circle, color: Apptheme.vividRose),
              ),
            ),
        ],
      ),
    );
  }

  Widget _board(ChooseBoardVm vm, {required BoardType board}) {
    return _cardFrame(
      selected: vm.selectedBoard.name == board.name,
      onTap: () => vm.updateSelectedBoard(board),
      title: board.name,
      header: AspectRatio(
        aspectRatio: 5 / 2,
        child: ImagePlaceHolder(
          imagePath: board.image,
          isCardHeader: true,
          borderRadius: BorderRadius.circular(8),
          fit: BoxFit.fill,
        ),
      ),
      description: board.description,
    );
  }

  Widget _searchInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: CustomInputField(
        label: 'Board Name',
        hintText: 'Enter Board Title...',
        labelStyle: Apptheme.text.copyWith(
          color: Apptheme.abyssTeal,
          fontWeight: getFontWeight(500),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Apptheme.pastelBlue, width: 1),
        ),
        hintStyle: Apptheme.text.copyWith(
          color: Apptheme.slateGray,
          height: 1.50,
        ),
      ),
    );
  }
}
