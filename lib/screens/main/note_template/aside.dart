import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class NoteTemplateAside extends StatelessWidget {
  const NoteTemplateAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteTemplateVm>(
      builder: (_, vm, _) {
        return Container(
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
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 25,
                    children: [
                      _btns(vm),
                      Text(
                        'Template Preview',
                        style: Apptheme.text.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _templateReview(),
                      Text(
                        'A versatile bullet journal style template with dot grid pattern. Perfect for creative note-taking, sketching, and planning.',
                        style: Apptheme.text.copyWith(
                          color: Apptheme.stormGray,
                        ),
                      ),
                      _bestFor(),
                      _customization(vm),
                      _brainsTip(),
                      _recentlyUsed(),
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

  Widget _recentCard({required String title, String? imagePath}) {
    return CustomCard(
      decoration: BoxDecoration(
        color: Apptheme.whiteSmoke,
        border: Border.all(color: Apptheme.transparent),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        spacing: 10,
        children: [
          OutlinedChild(
            size: 32,
            decoration: BoxDecoration(color: Apptheme.white),
            child: Center(
              child:
                  isNotNull(imagePath)
                      ? SVGImagePlaceHolder(imagePath: imagePath!, size: 16)
                      : Container(
                        width: 24,
                        height: 24,
                        decoration: ShapeDecoration(
                          color: Apptheme.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: Apptheme.text.copyWith(color: Apptheme.darkSlateGray),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentlyUsed() {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Used',
          style: Apptheme.text.copyWith(
            color: Apptheme.darkSlateGray,
            fontSize: 16,
            fontWeight: getFontWeight(500),
          ),
        ),
        _recentCard(title: 'Legal Pad'),
        _recentCard(title: 'Cornell Notes', imagePath: Images.copy3),
        _recentCard(title: 'AI Flashcards', imagePath: Images.flash),
      ],
    );
  }

  Widget _brainsTip() {
    return CustomCard(
      decoration: BoxDecoration(color: Apptheme.iceBlue),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          SVGImagePlaceHolder(imagePath: Images.logoRounded, size: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Text(
                  'Brain\'s Tip',
                  style: Apptheme.text.copyWith(
                    color: Apptheme.electricIndigo,
                    fontWeight: getFontWeight(500),
                  ),
                ),
                Text(
                  'Dotted paper works great with our pen tools! Try using different colors to organize related ideas visually.',
                  style: Apptheme.text.copyWith(
                    color: Apptheme.strongBlue,
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

  Widget _section({required Widget child, required String title}) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Apptheme.text.copyWith(
            color: Apptheme.stormGray,
            fontSize: 12,
          ),
        ),
        child,
      ],
    );
  }

  Widget _customization(NoteTemplateVm vm) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customization',
          style: Apptheme.text.copyWith(
            color: Apptheme.darkSlateGray,
            fontSize: 16,
            fontWeight: getFontWeight(500),
          ),
        ),
        _section(
          title: 'Dot Size',
          child: Row(
            spacing: 10,
            children: [
              Text(
                'Small',
                style: Apptheme.text.copyWith(
                  color: Apptheme.steelMist,
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: CustomSlider(
                  slider: Slider(
                    value: vm.dotSize,
                    onChanged: vm.updateDotSize,
                    padding: EdgeInsets.only(left: 10),
                  ),
                ),
              ),
              Text(
                'Large',
                style: Apptheme.text.copyWith(
                  color: Apptheme.steelMist,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        _section(
          title: 'Dot Color',
          child: ScrollableRow(
            children: [
              ColorWidget(Apptheme.blueGray),
              ColorWidget(Apptheme.lightBlue),
              ColorWidget(Apptheme.mintyGreen),
              ColorWidget(Apptheme.violet),
              ColorWidget(Apptheme.softCoral),
            ],
          ),
        ),
        _section(
          title: 'Background Color',
          child: ScrollableRow(
            children: [
              ColorWidget(Apptheme.white, addBorder: true),
              ColorWidget(Apptheme.ivory, addBorder: true),
              ColorWidget(Apptheme.iceBlue, addBorder: true),
              ColorWidget(Apptheme.honeyDew, addBorder: true),
              ColorWidget(Apptheme.pastelViolet, addBorder: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bestFor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'Best For:',
          style: Apptheme.text.copyWith(
            color: Apptheme.darkSlateGray,
            fontSize: 16,
            fontWeight: getFontWeight(500),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children:
              [
                    'Creative brainstorming',
                    'Bullet journaling',
                    'Hand-drawn diagrams',
                    'Mind mapping',
                  ]
                  .map(
                    (str) => Row(
                      spacing: 5,
                      children: [
                        Icon(Icons.check, color: Apptheme.primaryColor),
                        Expanded(
                          child: Text(
                            str,
                            style: Apptheme.text.copyWith(
                              color: Apptheme.stormGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _templateReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        CustomCard(
          decoration: BoxDecoration(color: Apptheme.whiteSmoke),
          child: SVGImagePlaceHolder(
            imagePath: Images.noteTemplateDottedWhite,
            center: true,
            width: 160,
            height: 208,
          ),
        ),
        Text(
          'Dotted Paper',
          style: Apptheme.text.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _btns(NoteTemplateVm vm) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton.secondary(
          onTap: vm.goToUploadPdf,
          text: 'Upload pdf',
          mainAxisSize: MainAxisSize.min,
          minHeight: 42,
          color: Apptheme.coolGray,
          textColor: Apptheme.darkSlateGray,
          prefix: SVGImagePlaceHolder(imagePath: Images.upload, size: 16),
        ),
        AppButton.text(
          wrapWithFlexible: true,
          onTap: vm.goToImportNotes,
          text: 'Import Notes',
          color: Apptheme.strongBlue,
        ),
      ],
    );
  }
}
