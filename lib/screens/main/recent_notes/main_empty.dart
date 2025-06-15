import 'package:navinotes/packages.dart';

class EmptyRecentNotesMain extends StatelessWidget {
  const EmptyRecentNotesMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        spacing: 20,
        children: [
          OutlinedChild(
            decoration: BoxDecoration(
              color: Apptheme.lightAsh,
              shape: BoxShape.circle,
            ),
            size: 96,
            child: SVGImagePlaceHolder(
              imagePath: Images.copy3,
              size: 40,
              color: Apptheme.jungleTeal,
            ),
          ),
          Text(
            'No Recent Notes Yet',
            textAlign: TextAlign.center,
            style: Apptheme.text.copyWith(
              fontSize: 24.0,
              fontWeight: getFontWeight(600),
              height: 1.33,
            ),
          ),
          WidthLimiter(
            mobile: 500,
            child: Text(
              'Your recently accessed notes will appear here once you start writing and reviewing.',
              textAlign: TextAlign.center,
              style: Apptheme.text.copyWith(
                color: Apptheme.stormGray,
                fontSize: 16.0,
                height: 1.50,
              ),
            ),
          ),
          AppButton(
            mainAxisSize: MainAxisSize.min,
            onTap: () {},
            text: 'Create Your First Note',
            color: Apptheme.jungleTeal,
          ),
          Row(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton.text(
                wrapWithFlexible: true,
                mainAxisSize: MainAxisSize.min,
                prefix: SVGImagePlaceHolder(imagePath: Images.folder, size: 18),
                onTap: () {},
                text: 'Browse Your Boards',
                color: Apptheme.jungleTeal,
              ),
              AppButton.text(
                wrapWithFlexible: true,
                mainAxisSize: MainAxisSize.min,
                prefix: SVGImagePlaceHolder(imagePath: Images.import, size: 16),
                onTap: () {},
                text: 'Import from PDF',
                color: Apptheme.jungleTeal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
