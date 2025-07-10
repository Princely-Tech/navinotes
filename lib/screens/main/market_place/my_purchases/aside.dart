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
          children: [
            _collection(), _usageStat(),
            //
          ],
        ),
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
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
              Text(
                'Used $useCount times',
                style: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1,
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
              style: TextStyle(
                color: const Color(0xFF00555A),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
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
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: isActive ? getFontWeight(500) : null,
            height: 1,
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
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1,
            letterSpacing: 0.70,
          ),
        ),
        child,
      ],
    );
  }
}
