import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/choose_board/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
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
                              color: Apptheme.persianBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CustomGrid(
                            children: [
                              _board(
                                vm,
                                title: 'Plain',
                                image: Images.boardPlain,
                                description:
                                    'Clean, distraction-free interface',
                              ),
                              _board(
                                vm,
                                title: 'Minimalist',
                                image: Images.boardMinimalist,
                                description:
                                    'Simplified, essential elements only',
                              ),
                              _board(
                                vm,
                                title: 'Dark Academia',
                                image: Images.boardAcademiaDark,
                                description: 'Vintage scholarly, darker tones',
                              ),
                              _board(
                                vm,
                                title: 'Light Academia',
                                image: Images.boardAcademiaLight,
                                description: 'Bright scholarly, cream tones',
                              ),
                              _board(
                                vm,
                                title: 'Nature',
                                image: Images.boardNature,
                                description: 'Organic patterns, natural colors',
                              ),
                              _board(
                                vm,
                                title: 'Pastel',
                                image: Images.boardPastel,
                                description: 'Soft, muted color palette',
                              ),
                              _board(
                                vm,
                                title: 'Tech/Neon',
                                image: Images.boardNeon,
                                description: 'Digital, vibrant highlights',
                              ),
                              _board(
                                vm,
                                title: 'Vintage',
                                image: Images.boardVintage,
                                description: 'Retro design, warm tones',
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
                fontSize: 16,
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
                color: selected ? Apptheme.mintyGreen : Apptheme.lightGray,
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
                        color: Apptheme.royalBlue,
                        fontSize: 16,
                        fontWeight: getFontWeight(500),
                      ),
                    ),
                    Text(
                      description,
                      style: Apptheme.text.copyWith(
                        color: Apptheme.strongBlue,
                        fontSize: 12,
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
                child: Icon(Icons.check_circle, color: Apptheme.mintyGreen),
              ),
            ),
        ],
      ),
    );
  }

  Widget _board(
    ChooseBoardVm vm, {
    required String title,
    required String image,
    required String description,
  }) {
    return _cardFrame(
      selected: vm.selectedBoard == title,
      onTap: () => vm.updateSelectedBoard(title),
      title: title,
      header: AspectRatio(
        aspectRatio: 5 / 2,
        child: ImagePlaceHolder(
          imagePath: image,
          isCardHeader: true,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      description: description,
    );
  }

  Widget _searchInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: CustomInputField(
        label: 'Board Name',
        hintText: 'Enter Board Title...',
        labelStyle: Apptheme.text.copyWith(
          color: Apptheme.electricIndigo,
          fontWeight: getFontWeight(500),
        ),
        hintStyle: Apptheme.text.copyWith(
          color: Apptheme.slateGray,
          fontSize: 16,
          height: 1.50,
        ),
      ),
    );
  }
}
