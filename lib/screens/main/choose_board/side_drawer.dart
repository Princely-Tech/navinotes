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
                  style: TextStyle(
                    color: const Color(0xFF1E3A8A),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
                Text(
                  'Choose a style that helps you focus. Different aesthetics can stimulate different types of thinking and creativity!',
                  style: TextStyle(
                    color: const Color(0xFF1D4ED8),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1,
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
      labelStyle: TextStyle(
        color: const Color(0xFF1D4ED8),
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _color(Color color, {double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color:
              color == Apptheme.white
                  ? Apptheme.coolGray
                  : Apptheme.transparent,
        ),
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
          style: TextStyle(
            color: const Color(0xFF1E3A8A),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text(
              'Accent Color',
              style: TextStyle(
                color: const Color(0xFF1D4ED8),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            ScrollableController(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 10,
                children: [
                  _color(Apptheme.vividBlue, size: 24),
                  _color(Apptheme.primaryColor, size: 24),
                  _color(Apptheme.lavenderPurple, size: 24),
                  _color(Apptheme.coralRed, size: 24),
                  _color(Apptheme.amber, size: 24),
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
          style: TextStyle(
            color: const Color(0xFF1D4ED8),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        Column(
          spacing: 7,
          children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 8.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
              ),
              child: Slider(
                value: vm.backgroundPatternOpacity,
                onChanged: vm.updateBackgroundPatternOpacity,
                activeColor: Apptheme.dodgerBlue,
                padding: EdgeInsets.zero,
                inactiveColor: Apptheme.gainsboro,
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
                            style: TextStyle(
                              color: const Color(0xFF2563EB),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1,
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
          style: TextStyle(
            color: const Color(0xFF1E3A8A),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        ScrollableController(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 10,
            children: [
              _color(Apptheme.white),
              _color(Apptheme.lightGray),
              _color(Apptheme.vividBlue),
              _color(Apptheme.mintyGreen),
              _color(Apptheme.defaultBlack),
            ],
          ),
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
          style: TextStyle(
            color: const Color(0xFF1E3A8A),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        Text(
          'A clean, distraction-free interface that keeps the focus on your ideas and connections. Perfect for academic study and professional planning.',
          style: TextStyle(
            color: const Color(0xFF1D4ED8),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1,
          ),
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
          style: TextStyle(
            color: const Color(0xFF1E40AF),
            fontSize: 18,
            fontFamily: 'Inter',
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
