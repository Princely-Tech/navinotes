import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/choose_board/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/inputs.dart';
import 'package:provider/provider.dart';

class ChooseBoardAside extends StatelessWidget {
  const ChooseBoardAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChooseBoardVm>(
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
                  padding: EdgeInsets.all(20),
                  child: Column(
                    spacing: 30,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _preview(),
                      _description(),
                      _colorPalette(),
                      _customization(vm),
                      _fontStyle(),
                      _brainyTip(),
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

  Widget _brainyTip() {
    return CustomCard(
      decoration: BoxDecoration(
        color: Apptheme.iceBlue,
        // border: Border.all(color: Apptheme.paleBlue),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          SVGImagePlaceHolder(imagePath: Images.logoRounded2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Text(
                  'Brainy Tip',
                  style: Apptheme.text.copyWith(
                    color: Apptheme.royalBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Choose a style that helps you focus. Different aesthetics can stimulate different types of thinking and creativity!',
                  style: Apptheme.text.copyWith(
                    color: Apptheme.electricIndigo,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fontStyle() {
    return CustomInputField(
      hintText: '',
      label: 'Font Style',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Apptheme.pastelBlue),
      ),
      selectItems: ['Sans Serif', 'Serif', 'Monospace'],
      controller: TextEditingController(text: 'Sans Serif'),
      labelStyle: Apptheme.text.copyWith(
        color: Apptheme.electricIndigo,
        fontSize: 12,
      ),
    );
  }

  Widget _customization(ChooseBoardVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          'Customization',
          style: Apptheme.text.copyWith(
            color: Apptheme.royalBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text(
              'Accent Color',
              style: Apptheme.text.copyWith(
                color: Apptheme.electricIndigo,
                fontSize: 12,
              ),
            ),
            ScrollableController(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  ColorWidget(Apptheme.vividBlue),
                  ColorWidget(Apptheme.primaryColor),
                  ColorWidget(Apptheme.lavenderPurple),
                  ColorWidget(Apptheme.coralRed),
                  ColorWidget(Apptheme.amber),
                ],
              ),
            ),
          ],
        ),
        _backgroundPattern(vm),
      ],
    );
  }

  Widget _backgroundPattern(ChooseBoardVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          'Background Pattern',
          style: Apptheme.text.copyWith(
            color: Apptheme.electricIndigo,
            fontSize: 12,
          ),
        ),
        Column(
          spacing: 7,
          children: [
            CustomSlider(
              slider: Slider(
                value: vm.backgroundPatternOpacity,
                onChanged: vm.updateBackgroundPatternOpacity,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children:
                  ['None', 'Subtle', 'Strong']
                      .map(
                        (str) => Flexible(
                          child: Text(
                            str,
                            style: Apptheme.text.copyWith(
                              color: Apptheme.electricIndigo,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          'Color Palette',
          style: Apptheme.text.copyWith(
            color: Apptheme.royalBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
        ScrollableRow(
          children: [
            ColorWidget(Apptheme.white, size: 32),
            ColorWidget(Apptheme.lightGray, size: 32),
            ColorWidget(Apptheme.vividBlue, size: 32),
            ColorWidget(Apptheme.mintyGreen, size: 32),
            ColorWidget(Apptheme.defaultBlack, size: 32),
          ],
        ),
      ],
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          'Plain',
          style: Apptheme.text.copyWith(
            color: Apptheme.royalBlue,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'A clean, distraction-free interface that keeps the focus on your ideas and connections. Perfect for academic study and professional planning.',
          style: Apptheme.text.copyWith(color: Apptheme.electricIndigo),
        ),
      ],
    );
  }

  Widget _preview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'Preview',
          style: Apptheme.text.copyWith(
            color: Apptheme.persianBlue,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        CustomCard(
          decoration: BoxDecoration(
            border: Border.all(color: Apptheme.paleBlue),
          ),
          child: ImagePlaceHolder(imagePath: Images.boardPreview),
        ),
      ],
    );
  }
}
