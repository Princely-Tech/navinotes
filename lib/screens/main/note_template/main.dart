import 'package:flutter/material.dart';
import 'util.dart';
import 'package:navinotes/packages.dart';
import 'header.dart';
import 'footer.dart';

class NoteTemplateMain extends StatelessWidget {
  const NoteTemplateMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NoteTemplateHeader(),
        Expanded(
          child: ScrollableController(
            mobilePadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            child: Column(
              spacing: 35,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _section(
                  title: 'Basic Templates',
                  icon: Images.file,
                  children: [
                    _template(noteTemplateBlank),
                    _template(noteTemplateCornell),
                    _template(noteTemplateLined),
                    _template(noteTemplateSquared),
                    _template(noteTemplateDotted),
                  ],
                ),
                _section(
                  icon: Images.book2,
                  title: 'Study Templates',
                  children: [
                    _template(noteTemplateFlashcards),
                    _template(noteTemplateAi),
                    _template(noteTemplateCompareContrast),
                    _template(noteTemplateTimeline),
                    _template(noteTemplateKanban),
                  ],
                ),
                _section(
                  icon: Images.pen2,
                  title: 'Essay Templates',
                  children: [
                    _template(noteTemplateLapReport),
                    _template(noteTemplateApa),
                    _template(noteTemplateResearch),
                    _template(noteTemplateComparative),
                    _template(noteTemplateCritical),
                    _template(noteTemplateThesis),
                  ],
                ),
                //
              ],
            ),
          ),
        ),
        NoteTemplateFooter(),
      ],
    );
  }

  Widget _template(BoardTemplate template) {
    return CustomCard(
      padding: EdgeInsets.zero,
      addCardShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: ImagePlaceHolder(
                  imagePath: template.image,
                  isCardHeader: true,
                ),
              ),
              if (template.isPopular)
                Positioned(
                  top: 10,
                  right: 10,
                  child: CustomTag(
                    'Popular',
                    color: AppTheme.vividBlue,
                    textColor: AppTheme.white,
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Text(
                  template.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
                Text(
                  template.body,
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required String icon,
    required List<Widget> children,
  }) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          children: [
            SVGImagePlaceHolder(
              imagePath: icon,
              size: 16,
              color: AppTheme.vividRose,
            ),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF00555A),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
          ],
        ),
        CustomGrid(
          mobile: 2,
          tablet: 3,
          laptop: 4,
          largeDesktop: 6,
          children: children,
        ),
      ],
    );
  }
}
