import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/widgets/components.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(color: Apptheme.lightGray, height: 40);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            color: const Color(0xFF1F2937),
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        CustomCard(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              _activityCard(
                body: 'You added new equations to the Schrödinger section',
                image: _imgCard(
                  imagePath: Images.note,
                  color: Apptheme.paleBlue,
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
                  color: Apptheme.lightMintGreen,
                ),
                lastUpdated: 'Yesterday, 4:15 PM',
                subject: 'Project Ideas',
                title: 'App Development Mindmap',
              ),
              divider,
              _activityCard(
                body: 'You highlighted 5 quotes and added commentary',
                image: _imgCard(imagePath: Images.pen, color: Apptheme.purple),
                lastUpdated: 'April 30, 2025',
                subject: 'Literature Notes',
                title: 'Hamlet Character Analysis',
              ),
              divider,
              _activityCard(
                body: 'You created a new diagram of mitosis phases',
                image: _imgCard(
                  imagePath: Images.flask,
                  color: Apptheme.yellow,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
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
                        style: Apptheme.text.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            body,
                            style: Apptheme.text.copyWith(
                              color: Apptheme.stormGray,
                            ),
                          ),
                          Text(
                            subject,
                            style: Apptheme.text.copyWith(
                              color: Apptheme.strongBlue,
                              fontSize: 12,
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
          Text(
            lastUpdated,
            style: Apptheme.text.copyWith(
              color: Apptheme.steelMist,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
