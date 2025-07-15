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
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2, color: AppTheme.lightGray),
                  ),
                ),
                child: Text(
                  'Template Preview',
                  style: TextStyle(
                    color: const Color(0xFF00555A),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.56,
                  ),
                ),
              ),
              Expanded(
                child: ScrollableController(
                  mobilePadding: const EdgeInsets.fromLTRB(15, 15, 15, 30),
                  child: CustomCard(
                    padding: EdgeInsets.zero,
                    addBorder: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      children: [
                        _templateReview(vm),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 15,
                            children: [
                              _bestFor(),
                              _customization(vm),
                              _brainsTip(),
                              // _recentlyUsed(),
                            ],
                          ),
                        ),
                      ],
                    ),
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
      decoration: BoxDecoration(
        color: AppTheme.iceBlue,
        border: Border.all(color: AppTheme.pastelBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
              SVGImagePlaceHolder(imagePath: Images.logo, size: 14),
              Text(
                'Brain\'s Tip',
                style: TextStyle(
                  color: const Color(0xFF1E40AF),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                ),
              ),
            ],
          ),
          Text(
            'For biology notes, use the left column to write key terms and concepts, the main area for detailed explanations, and the bottom for summarizing the relationships between systems.',
            style: TextStyle(
              color: const Color(0xFF1D4ED8),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
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
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        child,
      ],
    );
  }

  Widget _customization(NoteTemplateVm vm) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customization',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.43,
          ),
        ),
        _section(
          title: 'Dot Size',
          child: CustomSlider(
            slider: Slider(
              value: vm.dotSize,
              onChanged: vm.updateDotSize,
              padding: EdgeInsets.only(left: 10),
            ),
          ),
        ),
        _section(
          title: 'Color Palette',
          child: ScrollableRow(
            children: [
              ColorWidget(AppTheme.vividBlue),
              ColorWidget(AppTheme.emerald),
              ColorWidget(AppTheme.mediumOrchid),
              ColorWidget(AppTheme.coralRed),
              ColorWidget(AppTheme.steelMist),
            ],
          ),
        ),
        _section(
          title: 'Background',
          child: ScrollableRow(
            children: [
              ColorWidget(
                AppTheme.white,
                addBorder: true,
                borderRadius: BorderRadius.circular(4),
              ),
              ColorWidget(
                AppTheme.ivory,
                addBorder: true,
                borderRadius: BorderRadius.circular(4),
              ),
              ColorWidget(
                AppTheme.iceBlue,
                addBorder: true,
                borderRadius: BorderRadius.circular(4),
              ),
              ColorWidget(
                AppTheme.whiteSmoke,
                addBorder: true,
                borderRadius: BorderRadius.circular(4),
              ),
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
                    'Lecture notes and classroom learning',
                    'Active recall and study preparation',
                    'Organizing complex information',
                    'Creating effective study guides',
                  ]
                  .map(
                    (str) => Row(
                      spacing: 5,
                      children: [
                        Icon(Icons.check, color: AppTheme.primaryColor),
                        Expanded(
                          child: Text(
                            str,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
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

  Widget _templateReview(NoteTemplateVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.steelBlue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: SVGImagePlaceHolder(
            imagePath: vm.selectedTemplate.image,
            center: true,
            height: 200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                vm.selectedTemplate.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.56,
                ),
              ),
              Text(
                vm.selectedTemplate.description,
                style: TextStyle(
                  color: const Color(0xFF4B5563),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
            ],
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
