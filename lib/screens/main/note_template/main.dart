import 'package:flutter/material.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class NoteTemplateMain extends StatelessWidget {
  const NoteTemplateMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultHorizontalPadding,
        vertical: 10,
      ),
      child: Column(
        spacing: 10,
        children: [
          Expanded(
            child: ScrollableController(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                spacing: 35,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section(
                    title: 'Basic Templates',
                    children: [
                      _template(
                        title: 'Blank Page',
                        description:
                            'Clean, empty canvas for unlimited possibilities',
                        image: Images.noteTemplateBlank,
                        isPopular: true,
                      ),
                      _template(
                        title: 'Cornell Notes',
                        description:
                            'Structured format with cues, notes, and summary',
                        image: Images.noteTemplateCornell,
                      ),
                      _template(
                        title: 'Lined Paper',
                        description: 'Traditional lined notebook style',
                        image: Images.noteTemplateLined,
                      ),
                      _template(
                        title: 'Squared Paper',
                        description: 'Grid pattern for diagrams or math',
                        image: Images.noteTemplateSquared,
                      ),
                      _template(
                        title: 'Dotted Paper',
                        description: 'Bullet journal style with dot grid',
                        image: Images.noteTemplateDotted,
                        isPopular: true,
                      ),
                      _template(
                        title: 'Legal Pad',
                        description: 'Yellow lined paper aesthetic',
                        image: Images.noteTemplateLegalPad,
                      ),
                    ],
                  ),
                  _section(
                    title: 'Study Templates',
                    children: [
                      _template(
                        title: 'Flashcards',
                        description: 'Manual creation template for study cards',
                        image: Images.noteTemplateFlashCards,
                      ),
                      _template(
                        title: 'AI Flashcards',
                        description: 'AI-generated from existing content',
                        image: Images.noteTemplateFlashCardsAI,
                        isPopular: true,
                      ),
                      _template(
                        title: 'Question & Answer',
                        description: 'Structured Q&A format for review',
                        image: Images.noteTemplateQuestionAnswer,
                      ),
                      _template(
                        title: 'Compare & Contrast',
                        description: 'Split view for comparing concepts',
                        image: Images.noteTemplateCompareContrast,
                      ),
                      _template(
                        title: 'Cause-Effect',
                        description: 'Diagram for causal relationships',
                        image: Images.noteTemplateCauseEffect,
                      ),
                      _template(
                        title: 'Concept Definition',
                        description: 'Structured concept exploration',
                        image: Images.noteTemplateConcept,
                      ),
                      _template(
                        title: 'Lecture Notes',
                        description: 'Structured for comprehensive class notes',
                        image: Images.noteTemplateLectures,
                        isPopular: true,
                      ),
                    ],
                  ),
                  _section(
                    title: 'Planning Templates',
                    children: [
                      _template(
                        title: 'Timeline',
                        description: 'Horizontal or vertical time organization',
                        image: Images.noteTemplateTimeline,
                      ),
                      _template(
                        title: 'Project Steps',
                        description: 'Task-based project structure',
                        image: Images.noteTemplateProjectSteps,
                      ),
                      _template(
                        title: 'Kanban Board',
                        description: 'Columns for workflow management',
                        image: Images.noteTemplateKanban,
                        isPopular: true,
                      ),
                      _template(
                        title: 'Mind Map',
                        description:
                            'Pre-structured starting point for brainstorming',
                        image: Images.noteTemplateBlank,
                      ),
                      _template(
                        title: 'Goal Setting',
                        description: 'Objectives and tasks organization',
                        image: Images.noteTemplateGoalSetting,
                      ),
                    ],
                  ),
                  //
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _template({
    required String title,
    required String description,
    required String image,
    bool isPopular = false,
  }) {
    EdgeInsetsGeometry padding = const EdgeInsets.all(10);
    return CustomCard(
      padding: EdgeInsets.zero,
      child: Column(
        // spacing: 10,
        children: [
          Padding(
            padding: padding,
            child: SVGImagePlaceHolder(imagePath: image),
          ),
          Divider(color: Apptheme.lightGray, height: 1),
          Padding(
            padding: padding,
            child: Row(
              spacing: 5,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: const Color(0xFF1F2937),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: getFontWeight(500),
                          height: 1,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          color: const Color(0xFF6B7280),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: getFontWeight(400),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isPopular)
                  CustomTag(
                    'Popular',
                    color: Apptheme.paleBlue,
                    textColor: Apptheme.electricIndigo,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF1F2937),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
        CustomGrid(children: children),
      ],
    );
  }
}
