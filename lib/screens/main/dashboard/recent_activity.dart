import 'package:flutter/material.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(color: AppTheme.lightGray, height: 40);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text(
          'Recent Activity',
          style: AppTheme.text.copyWith(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        CustomCard(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              _activityCard(
                body: 'You added new equations to the Schrödinger section',
                image: _imgCard(
                  imagePath: Images.file,
                  color: AppTheme.paleBlue,
                ),
                lastUpdated: 'Today, 10:23 AM',
                subject: 'Physics 101',
                title: 'Quantum Mechanics Notes',
              ),
              divider,
              _activityCard(
                body: 'You connected 3 new nodes to the UI/UX branch',
                image: _imgCard(
                  imagePath: Images.share,
                  color: AppTheme.lightMintGreen,
                ),
                lastUpdated: 'Yesterday, 4:15 PM',
                subject: 'Project Ideas',
                title: 'App Development Mindmap',
              ),
              divider,
              _activityCard(
                body: 'You highlighted 5 quotes and added commentary',
                image: _imgCard(imagePath: Images.pen, color: AppTheme.purple),
                lastUpdated: 'April 30, 2025',
                subject: 'Literature Notes',
                title: 'Hamlet Character Analysis',
              ),
              divider,
              _activityCard(
                body: 'You created a new diagram of mitosis phases',
                image: _imgCard(
                  imagePath: Images.flask,
                  color: AppTheme.yellow,
                ),
                lastUpdated: 'April 29, 2025',
                subject: 'Biology 202',
                title: 'Cell Division Process',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imgCard({required String imagePath, required Color color}) {
    return SVGImagePlaceHolder(
      imagePath: imagePath,
      containerSize: 40,
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _activityCard({
    required String title,
    required String body,
    required String subject,
    required String lastUpdated,
    required Widget image,
  }) {
    return InkWell(
      onTap: () {
        NavigationHelper.push(Routes.pdf);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  image,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          title,
                          style: AppTheme.text.copyWith(
                            fontSize: 16.0,
                            fontWeight: getFontWeight(500),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(
                              body,
                              style: AppTheme.text.copyWith(
                                color: AppTheme.stormGray,
                              ),
                            ),
                            Text(
                              subject,
                              style: AppTheme.text.copyWith(
                                color: AppTheme.vividRose,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
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
                padding: const EdgeInsets.only(left: 30),
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
      ),
    );
  }
}
