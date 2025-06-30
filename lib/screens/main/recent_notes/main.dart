import 'dart:math';

import 'package:navinotes/packages.dart';
import 'filter.dart';
import 'main_empty.dart';
import 'vm.dart';

class RecentNotesMain extends StatelessWidget {
  const RecentNotesMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentNotesVm>(
      builder: (_, vm, _) {
        return Column(
          spacing: 10,
          children: [
            SearchBarHeader(openDrawer: vm.openDrawer, borderBottom: true),
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.all(10),
                tabletPadding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding,
                  vertical: 10,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    spacing: 25,
                    children: [
                      RecentNotesFilter(),
                      if (vm.hasData)
                        Column(
                          spacing: 25,
                          children: [
                            Column(
                              spacing: 10,
                              children: [
                                _noteCard(
                                  image: SVGImagePlaceHolder(
                                    imagePath: Images.file,
                                    size: 16,
                                    color: AppTheme.tealStone,
                                  ),
                                  title: 'Quantum Mechanics Notes',
                                  body:
                                      'Schrödinger equation describes how the quantum state of a physical system changes over time. The equation is a mathematical formula for the description of...',
                                  subject: 'Physics 101',
                                  lastUpdated: 'Today, 10:23 AM',
                                ),
                                _noteCard(
                                  image: SVGImagePlaceHolder(
                                    imagePath: Images.share,
                                    size: 16,
                                    color: AppTheme.vitalGreen,
                                  ),
                                  title: 'App Development Mindmap',
                                  body:
                                      'UI/UX branch with 3 connected nodes: wireframing, prototyping, and user testing. Each node contains specific tasks and requirements for the app development...',
                                  subject: 'Project Ideas',
                                  lastUpdated: 'Yesterday, 4:15 PM',
                                ),
                                _noteCard(
                                  image: SVGImagePlaceHolder(
                                    imagePath: Images.pen,
                                    size: 16,
                                    color: AppTheme.electricViolet,
                                  ),
                                  title: 'Hamlet Character Analysis',
                                  body:
                                      '"To be, or not to be, that is the question..." - Hamlet\'s existential crisis is evident in his famous soliloquy, revealing his contemplation of life and death...',
                                  subject: 'Literature Notes',
                                  lastUpdated: 'April 30, 2025',
                                ),
                                _noteCard(
                                  image: SVGImagePlaceHolder(
                                    imagePath: Images.chart,
                                    size: 16,
                                    color: AppTheme.spicedAmber,
                                  ),
                                  title: 'Cell Division Process',
                                  subject: ' Biology 202',
                                  body:
                                      'Mitosis phases: Prophase, Metaphase, Anaphase, Telophase, and Cytokinesis. During prophase, chromatin condenses into chromosomes and nuclear membrane...',
                                  lastUpdated: 'April 29, 2025',
                                ),
                                _noteCard(
                                  image: SVGImagePlaceHolder(
                                    imagePath: Images.pdf,
                                    size: 16,
                                    color: AppTheme.bloodFire,
                                  ),
                                  title: 'Research Paper Annotations',
                                  body:
                                      'Key findings on page 23 highlight the correlation between quantum field theory and particle behavior. Author\'s methodology uses statistical analysis to...',
                                  subject: 'Physics 101',
                                  lastUpdated: 'April 28, 2025',
                                ),
                                _noteCard(
                                  image: SVGImagePlaceHolder(
                                    imagePath: Images.language,
                                    size: 16,
                                  ),
                                  title: 'Spanish Vocabulary: Food Items',
                                  body:
                                      'la manzana (apple), el plátano (banana), la naranja (orange), el tomate (tomato), la cebolla (onion), el ajo (garlic), la zanahoria (carrot)...',
                                  subject: 'Spanish Vocabulary',
                                  lastUpdated: 'April 27, 2025',
                                ),
                              ],
                            ),
                            _footer(),
                          ],
                        )
                      else
                        EmptyRecentNotesMain(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _footer() {
    return LayoutBuilder(
      builder: (_, constraints) {
        return ScrollableController(
          scrollDirection: Axis.horizontal,
          child: Container(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Row(
              spacing: 30,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton.text(
                  onTap: () {},
                  text: 'Clear All History',
                  prefix: SVGImagePlaceHolder(
                    imagePath: Images.trash,
                    size: 14,
                    color: AppTheme.tealStone,
                  ),
                  style: AppTheme.text.copyWith(color: AppTheme.tealStone),
                ),
                CustomPaination(),
                AppButton.text(
                  onTap: () {},
                  text: 'View All Notes',
                  suffix: Icon(
                    Icons.arrow_forward,
                    color: AppTheme.tealStone,
                    size: 18,
                  ),
                  style: AppTheme.text.copyWith(color: AppTheme.tealStone),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _noteCard({
    required String title,
    required String body,
    required String subject,
    required String lastUpdated,
    required Widget image,
  }) {
    bool isFav = Random().nextBool();
    return CustomCard(
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 7,
                      children: [
                        image,
                        Flexible(
                          child: Text(
                            title,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.charcoalBlue,
                              fontSize: 16.0,
                              fontWeight: getFontWeight(500),
                              height: 1.50,
                            ),
                          ),
                        ),
                        Icon(
                          isFav ? Icons.star : Icons.star_border,
                          color: isFav ? AppTheme.solarGold : AppTheme.blueGray,
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'From ',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.steelMist,
                              height: 1.43,
                            ),
                          ),
                          TextSpan(
                            text: subject,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.tealStone,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              VisibleController(
                mobile: false,
                tablet: true,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    lastUpdated,
                    style: AppTheme.text.copyWith(
                      color: AppTheme.steelMist,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            body,
            style: AppTheme.text.copyWith(
              color: AppTheme.darkSlateGray,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }
}
