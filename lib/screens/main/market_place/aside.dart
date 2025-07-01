import 'package:navinotes/packages.dart';

class MarketPlaceAside extends StatelessWidget {
  const MarketPlaceAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(right: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 25,
                children: [
                  Text(
                    'Filters',
                    style: AppTheme.text.copyWith(
                      fontSize: 18.0,
                      fontWeight: getFontWeight(500),
                    ),
                  ),
                  _sections(
                    title: 'Categories',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCheckBoxItem(title: 'Test Prep'),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomCheckBoxItem(title: 'MCAT'),
                              CustomCheckBoxItem(title: 'LSAT'),
                              CustomCheckBoxItem(title: 'DAT'),
                            ],
                          ),
                        ),
                        CustomCheckBoxItem(title: 'Academic Subjects'),
                        CustomCheckBoxItem(
                          title: 'Professional Certifications',
                        ),
                        CustomCheckBoxItem(title: 'Language Learning'),
                      ],
                    ),
                  ),
                  _sections(
                    title: 'Price Range',
                    child: Column(
                      children: [
                        CustomSlider(
                          slider: Slider(value: 0.6, onChanged: (value) {}),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                              ['\$0', '\$100']
                                  .map(
                                    (str) => Text(
                                      str,
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.stormGray,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  ),
                  _sections(
                    title: 'Rating',
                    child: Column(
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            Flexible(
                              child: CustomCheckBoxItem(
                                child: StarRows(fullStars: 4, emptyStars: 1),
                              ),
                            ),
                            Text(
                              '& up',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.darkSlateGray,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Flexible(
                              child: CustomCheckBoxItem(
                                child: StarRows(fullStars: 3, emptyStars: 2),
                              ),
                            ),
                            Text(
                              '& up',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.darkSlateGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _sections(
                    title: 'Content Type',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCheckBoxItem(title: 'Mind Maps'),
                        CustomCheckBoxItem(title: 'Flashcards'),
                        CustomCheckBoxItem(title: 'Study Guides'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sections({required Widget child, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.steelMist,
            fontWeight: getFontWeight(500),
          ),
        ),
        child,
      ],
    );
  }
}
