import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/board_notes/shared.dart';
import 'package:navinotes/screens/main/board_notes/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class BoardNotesMain extends StatelessWidget {
  const BoardNotesMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotesVm>(
      builder: (context, vm, child) {
        return Column(
          children: [
            _header(),
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.all(defaultHorizontalPadding),
                child: CustomGrid(
                  children: [
                    _noteCard(
                      lastEdited: 'Apr 28, 2025',
                      title: 'Wave Properties',
                      image: Images.noteWave,
                      outLines: _outlineRow(
                        outline1: _outline(),
                        outline2: _outline(
                          image: Images.img,
                          color: Apptheme.paleJade,
                        ),
                      ),
                    ),
                    _noteCard(
                      lastEdited: 'Apr 25, 2025',
                      title: 'Newton\'s Laws',
                      image: Images.noteNewton,
                      outLines: _outlineRow(
                        outline1: _outline(),
                        outline2: _outline(
                          image: Images.video,
                          color: Apptheme.pastelPurple,
                        ),
                      ),
                    ),
                    _noteCard(
                      lastEdited: 'Apr 22, 2025',
                      title: 'Thermodynamics',
                      image: Images.noteThermodynamics,
                      outLines: _outlineRow(
                        outline1: _outline(),
                        outline2: _outline(
                          image: Images.copy2,
                          color: Apptheme.softGold,
                        ),
                      ),
                    ),
                    _noteCard(
                      lastEdited: 'Apr 20, 2025',
                      title: 'Electromagnetism',
                      image: Images.noteElectromagnetism,
                      outLines: _outlineRow(
                        outline1: _outline(),
                        outline2: _outline(
                          image: Images.chart,
                          color: Apptheme.blushPink,
                        ),
                      ),
                    ),
                    _noteCard(
                      lastEdited: 'Apr 18, 2025',
                      title: 'Quantum Mechanics',
                      image: Images.noteMechanics,
                      outLines: _outlineRow(
                        outline1: _outline(),
                        outline2: _outline(
                          image: Images.calculator,
                          color: Apptheme.periwinkle,
                        ),
                      ),
                    ),
                    _noteCard(
                      lastEdited: 'Apr 28, 2025',
                      title: 'Optics & Light',
                      image: Images.noteOptics,
                      outLines: _outlineRow(
                        outline1: _outline(),
                        outline2: _outline(
                          image: Images.img,
                          color: Apptheme.paleJade,
                        ),
                      ),
                    ),
                    CreateCard(
                      onTap: vm.gotToCreateNotePage,
                      text: 'Create New Note Page',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _outline({
    String image = Images.hook,
    Color color = Apptheme.pastelBlue,
  }) {
    return OutlinedChild(
      size: 20,
      decoration: BoxDecoration(
        color: color,
        border: Border(),
        shape: BoxShape.circle,
      ),
      child: SVGImagePlaceHolder(imagePath: image, size: 12),
    );
  }

  Widget _outlineRow({required Widget outline1, required Widget outline2}) {
    return Stack(
      children: [
        SizedBox(width: 35, height: 20),
        Positioned(left: 0, bottom: 0, child: outline1),
        Positioned(right: 0, bottom: 0, child: outline2),
      ],
    );
  }

  Widget _noteCard({
    required String image,
    required String title,
    required String lastEdited,
    required Widget outLines,
  }) {
    Radius radius = Radius.circular(12);
    return CustomCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Apptheme.iceBlue,
              borderRadius: BorderRadius.only(
                topLeft: radius,
                topRight: radius,
              ),
            ),
            padding: EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: 5 / 2,
              child: ImagePlaceHolder(
                imagePath: image,
                isCardHeader: true,
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Apptheme.text.copyWith(
                    color: Apptheme.charcoalBlue,
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'Last edited: $lastEdited',
                        style: Apptheme.text.copyWith(
                          color: Apptheme.steelMist,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    outLines,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      constraints: BoxConstraints(minHeight: 60),
      decoration: ShapeDecoration(
        color: Apptheme.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Apptheme.lightGray),
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        spacing: 20,
        children: [
          Text('8 Note Pages', style: Apptheme.text.copyWith(fontSize: 16.0)),
          VisibleController(
            mobile: false,
            tablet: true,
            child: Expanded(
              child: ResponsiveSection(
                mobile: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [_sortBy()],
                ),
                desktop: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Apptheme.lightAsh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          spacing: 5,
                          children: [
                            OutlinedChild(
                              size: 32,
                              decoration: BoxDecoration(color: Apptheme.white),
                              child: SVGImagePlaceHolder(
                                imagePath: Images.ques2,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: SVGImagePlaceHolder(
                                imagePath: Images.menu,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _sortBy(),
                    NewNotesButton(isAside: false),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortBy() {
    return WidthLimiter(
      mobile: 210,
      child: CustomInputField(
        fillColor: Apptheme.lightAsh,
        side: BorderSide.none,
        hintText: 'Last Modified',
        controller: TextEditingController(text: 'Last modified'),
        selectItems: ['Last modified', 'Date Created'],
        style: Apptheme.text.copyWith(color: Apptheme.strongBlue),
        constraints: BoxConstraints(maxHeight: 40),
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sort by:',
              textAlign: TextAlign.center,
              style: Apptheme.text.copyWith(color: Apptheme.darkSlateGray),
            ),
          ],
        ),
      ),
    );
  }
}
