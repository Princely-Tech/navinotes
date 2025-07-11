import 'package:navinotes/packages.dart';

class MyPurchasesAside extends StatelessWidget {
  const MyPurchasesAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(right: BorderSide(color: AppTheme.lightGray)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 30,
          children: [_collection(), _usageStat(), _studyTime()],
        ),
      ),
    );
  }

  Widget _studyTimeItem({
    required String title,
    required String time,
    required double percentage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTheme.text.copyWith(
                  color: AppTheme.stormGray,
                  fontSize: 12.0,
                  height: 1.0,
                ),
              ),
            ),
            Text(
              time,
              style: AppTheme.text.copyWith(
                color: AppTheme.royalViolet,
                fontSize: 12.0,
                fontWeight: getFontWeight(500),
                height: 1.0,
              ),
            ),
          ],
        ),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: AppTheme.pastelPurple,
          borderRadius: BorderRadius.circular(100),
          minHeight: 8,
          color: AppTheme.electricPurple,
        ),
      ],
    );
  }

  Widget _studyTime() {
    return CustomCard(
      decoration: BoxDecoration(color: AppTheme.iceBlue),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            'Study Time',
            style: AppTheme.text.copyWith(
              color: const Color(0xFF5B21B6),
              fontSize: 16.0,
              fontWeight: getFontWeight(500),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              _studyTimeItem(
                percentage: 70,
                time: '12h 30m',
                title: 'This week',
              ),
              _studyTimeItem(
                percentage: 60,
                title: 'Total with purchased content',
                time: '86h 45m',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _usageStatItem({
    required String title,
    required Widget icon,
    required int useCount,
  }) {
    return Row(
      spacing: 10,
      children: [
        icon,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                title,
                style: AppTheme.text.copyWith(
                  fontWeight: getFontWeight(500),
                  height: 1.0,
                ),
              ),
              Text(
                'Used $useCount times',
                style: AppTheme.text.copyWith(
                  color: AppTheme.steelMist,
                  fontSize: 12.0,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _usageStat() {
    return _section(
      title: 'Usage Statistics',
      child: CustomCard(
        decoration: BoxDecoration(color: AppTheme.iceBlue),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              'Most Used Content',
              style: AppTheme.text.copyWith(
                color: AppTheme.vividRose,
                fontSize: 16.0,
                fontWeight: getFontWeight(500),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                _usageStatItem(
                  icon: OutlinedChild(
                    decoration: BoxDecoration(color: AppTheme.paleBlue),
                    child: SVGImagePlaceHolder(
                      imagePath: Images.connection2,
                      size: 18,
                      color: AppTheme.vividRose,
                    ),
                  ),
                  title: 'Biology Concepts',
                  useCount: 24,
                ),
                _usageStatItem(
                  icon: OutlinedChild(
                    decoration: BoxDecoration(color: AppTheme.lightMintGreen),
                    child: SVGImagePlaceHolder(
                      imagePath: Images.stack,
                      size: 18,
                      color: AppTheme.jungleGreen,
                    ),
                  ),
                  title: 'Chemistry Flashcards',
                  useCount: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _collectionItem({
    required String title,
    required Widget icon,
    bool isActive = false,
    bool showArrowIcon = true,
  }) {
    final color = isActive ? AppTheme.vividRose : AppTheme.darkSlateGray;
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: icon,
        selected: isActive,
        selectedTileColor: AppTheme.iceBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        trailing:
            showArrowIcon
                ? Icon(Icons.keyboard_arrow_right, color: AppTheme.blueGray)
                : null,
        contentPadding: const EdgeInsets.only(left: 15, right: 10),
        title: Text(
          title,
          style: AppTheme.text.copyWith(
            color: color,
            fontSize: 16.0,
            fontWeight: isActive ? getFontWeight(500) : null,
            height: 1.0,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _collection() {
    return _section(
      title: 'Collections',
      child: Column(
        spacing: 10,
        children: [
          _collectionItem(
            icon: SVGImagePlaceHolder(
              imagePath: Images.refresh,
              size: 16,
              color: AppTheme.vividRose,
            ),
            title: 'Recently Purchased',
            isActive: true,
            showArrowIcon: false,
          ),
          _collectionItem(
            icon: SVGImagePlaceHolder(
              imagePath: Images.star2,
              size: 16,
              color: AppTheme.amber,
            ),
            title: 'Favorites',
            showArrowIcon: false,
          ),
          _collectionItem(
            icon: SVGImagePlaceHolder(
              imagePath: Images.book,
              size: 16,
              color: AppTheme.vividBlue,
            ),
            title: 'By Subject',
          ),
          _collectionItem(
            icon: SVGImagePlaceHolder(
              imagePath: Images.cap,
              size: 16,
              color: AppTheme.lavenderPurple,
            ),
            title: 'By Test/Exam',
          ),
          _collectionItem(
            icon: SVGImagePlaceHolder(
              imagePath: Images.folder2,
              size: 16,
              color: AppTheme.primaryColor,
            ),
            title: 'Custom Collections',
          ),
        ],
      ),
    );
  }

  Widget _section({required Widget child, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.steelMist,
            fontWeight: getFontWeight(600),
            height: 1.0,
            letterSpacing: 0.70,
          ),
        ),
        child,
      ],
    );
  }
}
