import 'package:navinotes/packages.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteSmoke,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: AppTheme.vividRose,
            fontSize: 20.0,
            fontFamily: AppTheme.fontFamily,
            fontWeight: getFontWeight(600),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.vividRose),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ScrollableController(
        mobilePadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Notification Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.lightGray.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SVGImagePlaceHolder(
                    imagePath: Images.bell,
                    size: 40,
                    color: AppTheme.steelMist,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Empty State Message
              Text(
                'You do not have any notification now',
                style: TextStyle(
                  color: AppTheme.steelMist,
                  fontSize: 16.0,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: getFontWeight(400),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'When you receive notifications, they will appear here',
                style: TextStyle(
                  color: AppTheme.steelMist.withOpacity(0.7),
                  fontSize: 14.0,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: getFontWeight(400),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
