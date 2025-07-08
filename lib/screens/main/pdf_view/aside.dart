import 'package:flutter/material.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class PdfViewAside extends StatelessWidget {
  const PdfViewAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: AppTheme.whiteSmoke,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppTheme.lightGray),
        ),
      ),

      child: Column(
        children: [
          Expanded(
            child: ScrollableController(
              mobilePadding: EdgeInsets.all(15),
              child: Column(
                spacing: 20,
                children: [
                  _minMapConnections(),
                  _connectedHighLights(),
                  _aiSuggestion(),
                ],
              ),
            ),
          ),
          _tip(),
        ],
      ),
    );
  }

  Widget _tip() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.iceBlue,
        border: Border(top: BorderSide(color: AppTheme.pastelBlue)),
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          SVGImagePlaceHolder(imagePath: Images.logoRounded2, size: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(
                  'Brainiac Tip',
                  style: AppTheme.text.copyWith(
                    color: AppTheme.electricIndigo,
                    fontWeight: getFontWeight(500),
                  ),
                ),
                Text(
                  'Try highlighting key terms and connecting them to create a comprehensive study structure. Connected ideas are easier to remember!',
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

  Widget _aiSuggestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'AI Connection Suggestions',
          style: AppTheme.text.copyWith(fontWeight: getFontWeight(500)),
        ),
        CustomCard(
          padding: EdgeInsets.all(10),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'These concepts might connect well to your mind map:',
                style: AppTheme.text.copyWith(
                  color: AppTheme.darkSlateGray,
                  fontSize: 12.0,
                ),
              ),
              ...[
                'Cell signaling pathways',
                'Membrane fluidity',
                'Osmosis regulation',
              ].map(
                (str) => Row(
                  spacing: 7,
                  children: [
                    OutlinedChild(
                      size: 20,
                      decoration: BoxDecoration(color: AppTheme.paleBlue),
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: AppTheme.strongBlue,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        str,
                        style: AppTheme.text.copyWith(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _highlightCard({
    required String title,
    required String body,
    required Color color,
  }) {
    return CustomCard(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Row(
        spacing: 5,
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Expanded(
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.text.copyWith(
                    color: const Color(0xFF1F2937),
                    fontSize: 12.0,
                    fontFamily: 'Inter',
                    fontWeight: getFontWeight(500),
                  ),
                ),
                Text(
                  body,
                  style: AppTheme.text.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: 12.0,
                    fontFamily: 'Inter',
                    fontWeight: getFontWeight(400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectedHighLights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Connected Highlights',
                style: AppTheme.text.copyWith(
                  color: const Color(0xFF1F2937),
                  fontSize: 14.0,
                  fontFamily: 'Inter',
                  fontWeight: getFontWeight(500),
                ),
              ),
            ),
            Text(
              '3 items',
              style: AppTheme.text.copyWith(
                color: const Color(0xFF6B7280),
                fontSize: 12.0,
                fontFamily: 'Inter',
                fontWeight: getFontWeight(400),
                height: 1.0,
              ),
            ),
          ],
        ),
        _highlightCard(
          title: 'Membrane proteins',
          body: 'Added to Mind Map',
          color: AppTheme.vividBlue,
        ),
        _highlightCard(
          title: 'Phospholipid bilayer',
          body: 'Flashcard created',
          color: AppTheme.primaryColor,
        ),
        _highlightCard(
          title: 'Passive transport',
          body: 'Note created',
          color: AppTheme.lavenderPurple,
        ),
      ],
    );
  }

  Widget _minMapConnections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          'Mind Map Connections',
          style: AppTheme.text.copyWith(
            color: const Color(0xFF1F2937),
            fontSize: 16.0,
            fontFamily: 'Inter',
            fontWeight: getFontWeight(500),
            height: 1.0,
          ),
        ),
        CustomCard(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                'Preview',
                style: AppTheme.text.copyWith(
                  color: const Color(0xFF1F2937),
                  fontSize: 14.0,
                  fontFamily: 'Inter',
                  fontWeight: getFontWeight(500),
                ),
              ),
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              AppButton.text(
                onTap: () {},
                text: 'Open full mind map',
                prefix: SVGImagePlaceHolder(imagePath: Images.scan, size: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
