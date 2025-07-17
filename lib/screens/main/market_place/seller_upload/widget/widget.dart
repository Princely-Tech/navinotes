import 'package:navinotes/packages.dart';

Widget progressHeader(int step) {
  return Container(
    color: AppTheme.whiteSmoke,
    padding: EdgeInsets.symmetric(vertical: 15),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ResponsiveHorizontalPadding(
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Container(color: AppTheme.vividRose, height: 4),
            ),
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerItem(title: 'Content Selection', count: 1, check: step == 1),
                _headerItem(title: 'Details & Preview', count: 2, check: step == 2),
                _headerItem(title: 'Pricing & Terms', count: 3, check: step == 3),
                _headerItem(title: 'Review & Submit', count: 4, check: step == 4),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _headerItem({
  required String title,
  bool check = false,
  required int count,
}) {
  return Flexible(
    child: Column(
      spacing: 5,
      children: [
        OutlinedChild(
          size: 32,
          decoration: BoxDecoration(
            color: AppTheme.vividRose,
            shape: BoxShape.circle,
          ),
          child:
              check
                  ? Icon(Icons.check, color: AppTheme.white)
                  : Text(
                    '$count',
                    style: AppTheme.text.copyWith(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: getFontWeight(500),
                    ),
                  ),
        ),

        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.text.copyWith(
            color: AppTheme.vividRose,
            fontWeight: getFontWeight(500),
            height: 1.0,
          ),
        ),
      ],
    ),
  );
}
