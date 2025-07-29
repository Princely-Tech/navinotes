import 'package:navinotes/packages.dart';

class NoteCompareContrastAiAnalysis extends StatelessWidget {
  const NoteCompareContrastAiAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
          addBorder: true,
          padding: EdgeInsets.all(15),
          child: Column(
            spacing: 15,
            children: [
              _header(),
              CustomGrid(
                children: [
                  _gridItem(
                    color: const Color(0xFFDC2626),
                    icon: Images.notEqual,
                    title: 'Key Differences',
                    items: [
                      RichTextProp([
                        RichTextPropItem(
                          text: 'Primary difference: ',
                          highlight: true,
                        ),
                        RichTextPropItem(
                          text:
                              'Presence of membrane-bound nucleus in eukaryotes',
                        ),
                      ]),
                      RichTextProp([
                        RichTextPropItem(
                          text: 'Complexity level: ',
                          highlight: true,
                        ),
                        RichTextPropItem(
                          text:
                              'Eukaryotic cells are significantly more complex',
                        ),
                      ]),
                      RichTextProp([
                        RichTextPropItem(
                          text: 'Size difference: ',
                          highlight: true,
                        ),
                        RichTextPropItem(
                          text: 'Eukaryotes are ~10x larger than prokaryotes',
                        ),
                      ]),
                      RichTextProp([
                        RichTextPropItem(
                          text: 'DNA organization: ',
                          highlight: true,
                        ),
                        RichTextPropItem(
                          text: 'Circular vs. linear chromosomes',
                        ),
                      ]),
                    ],
                  ),
                  _gridItem(
                    color: const Color(0xFF22C55E),
                    icon: Images.equal,
                    title: 'Similarities',
                    items: [
                      RichTextProp([
                        RichTextPropItem(
                          text:
                              'Both have cell membranes that regulate what enters and exits the cell',
                        ),
                      ]),
                      RichTextProp([
                        RichTextPropItem(
                          text:
                              'Both contain genetic material (DNA) that controls cell function',
                        ),
                      ]),
                      RichTextProp([
                        RichTextPropItem(
                          text: 'Both have ribosomes for protein synthesis',
                        ),
                      ]),
                      RichTextProp([
                        RichTextPropItem(
                          text:
                              'Both carry out metabolism and energy production',
                        ),
                      ]),
                    ],
                  ),
                  _gridItem(
                    color: const Color(0xFF3B82F6),
                    icon: Images.bulb,
                    title: 'Study Recommendations',
                    items: [
                      RichTextProp([
                        RichTextPropItem(text: 'Focus on: ', highlight: true),
                        RichTextPropItem(
                          text: 'Organelle differences and their functions',
                        ),
                      ]),
                      RichTextProp([
                        RichTextPropItem(
                          text: 'Create memory aid: ',
                          highlight: true,
                        ),
                        RichTextPropItem(
                          text: 'Size, complexity, and DNA organization',
                        ),
                      ]),
                      RichTextProp([
                        RichTextPropItem(text: 'Understand: ', highlight: true),
                        RichTextPropItem(
                          text: 'Evolutionary relationship between cell types',
                        ),
                      ]),
                      RichTextProp([
                        RichTextPropItem(text: 'Practice: ', highlight: true),
                        RichTextPropItem(
                          text: 'Drawing and labeling cell structures',
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gridItem({
    required String title,
    required Color color,
    required String icon,
    required List<RichTextProp> items,
  }) {
    return CustomCard(
      addBorder: true,
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 5,
            children: [
              OutlinedChild(
                size: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withAlpha(50),
                ),
                child: SVGImagePlaceHolder(
                  imagePath: icon,
                  color: color,
                  size: 20,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
          Column(
            spacing: 10,
            children:
                items
                    .map((item) => _gridRowItem(color: color, item: item))
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _gridRowItem({required Color color, required RichTextProp item}) {
    return Row(
      spacing: 12,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children:
                  item.items
                      .map(
                        (par) => TextSpan(
                          text: par.text,
                          style: TextStyle(
                            fontSize: 14.0,
                            height: 1.43,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight:
                                par.highlight
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Row(
      spacing: 15,
      children: [
        Expanded(
          child: Text(
            'AI Analysis & Insights',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.56,
            ),
          ),
        ),
        AppButton.secondary(
          mainAxisSize: MainAxisSize.min,
          text: 'Refresh Analysis',
          spacing: 10,
          prefix: SVGImagePlaceHolder(
            imagePath: Images.refresh2,
            color: const Color(0xFF0284C7),
            size: 14,
          ),
          onTap: () {},
          minHeight: 40,
          padding: EdgeInsets.all(10),
          color: const Color(0xFF0284C7),
        ),
      ],
    );
  }
}
