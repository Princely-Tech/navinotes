import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class NoteTemplateAside extends StatelessWidget {
  const NoteTemplateAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteTemplateVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            border: Border(
              right: BorderSide(width: 2, color: AppTheme.lightGray),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ScrollableController(
                  mobilePadding: const EdgeInsets.fromLTRB(15, 15, 15, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 25,
                    children: [
                      _btns(vm),
                      Text(
                        'Template Preview',
                        style: AppTheme.text.copyWith(
                          fontSize: 18.0,
                          fontWeight: getFontWeight(600),
                        ),
                      ),
                      _templateReview(),
                      Text(
                        'A versatile bullet journal style template with dot grid pattern. Perfect for creative note-taking, sketching, and planning.',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.stormGray,
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
        color: AppTheme.whiteSmoke,
        border: Border.all(color: AppTheme.transparent),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        spacing: 10,
        children: [
          OutlinedChild(
            size: 32,
            decoration: BoxDecoration(color: AppTheme.white),
            child: Center(
              child:
                  isNotNull(imagePath)
                      ? SVGImagePlaceHolder(imagePath: imagePath!, size: 16)
                      : Container(
                        width: 24,
                        height: 24,
                        decoration: ShapeDecoration(
                          color: AppTheme.yellow,
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
              style: AppTheme.text.copyWith(color: AppTheme.darkSlateGray),
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
          style: AppTheme.text.copyWith(
            color: AppTheme.darkSlateGray,
            fontSize: 16.0,
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
      decoration: BoxDecoration(color: AppTheme.iceBlue),
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
                  style: AppTheme.text.copyWith(
                    color: AppTheme.electricIndigo,
                    fontWeight: getFontWeight(500),
                  ),
                ),
                Text(
                  'Dotted paper works great with our pen tools! Try using different colors to organize related ideas visually.',
                  style: AppTheme.text.copyWith(
                    color: AppTheme.strongBlue,
                    fontSize: 12.0,
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
          style: AppTheme.text.copyWith(
            color: AppTheme.stormGray,
            fontSize: 12.0,
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
          style: AppTheme.text.copyWith(
            color: AppTheme.darkSlateGray,
            fontSize: 16.0,
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
                style: AppTheme.text.copyWith(
                  color: AppTheme.steelMist,
                  fontSize: 12.0,
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
                style: AppTheme.text.copyWith(
                  color: AppTheme.steelMist,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        _section(
          title: 'Dot Color',
          child: ScrollableRow(
            children: [
              ColorWidget(AppTheme.blueGray),
              ColorWidget(AppTheme.lightBlue),
              ColorWidget(AppTheme.mintyGreen),
              ColorWidget(AppTheme.violet),
              ColorWidget(AppTheme.softCoral),
            ],
          ),
        ),
        _section(
          title: 'Background Color',
          child: ScrollableRow(
            children: [
              ColorWidget(AppTheme.white, addBorder: true),
              ColorWidget(AppTheme.ivory, addBorder: true),
              ColorWidget(AppTheme.iceBlue, addBorder: true),
              ColorWidget(AppTheme.honeyDew, addBorder: true),
              ColorWidget(AppTheme.pastelViolet, addBorder: true),
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
          style: AppTheme.text.copyWith(
            color: AppTheme.darkSlateGray,
            fontSize: 16.0,
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
                        Icon(Icons.check, color: AppTheme.primaryColor),
                        Expanded(
                          child: Text(
                            str,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.stormGray,
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
          decoration: BoxDecoration(color: AppTheme.whiteSmoke),
          child: SVGImagePlaceHolder(
            imagePath: Images.noteTemplateDottedWhite,
            center: true,
            width: 160,
            height: 208,
          ),
        ),
        Text(
          'Dotted Paper',
          style: AppTheme.text.copyWith(
            fontSize: 16.0,
            fontWeight: getFontWeight(600),
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
          color: AppTheme.coolGray,
          textColor: AppTheme.darkSlateGray,
          prefix: SVGImagePlaceHolder(imagePath: Images.upload, size: 16),
        ),
        AppButton.text(
          wrapWithFlexible: true,
          onTap: vm.goToImportNotes,
          text: 'Import Notes',
          color: AppTheme.strongBlue,
        ),
      ],
    );
  }
}
