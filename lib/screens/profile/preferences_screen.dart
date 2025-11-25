import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/profile/vm.dart';

class PreferencesScreen extends StatelessWidget {
  final ProfileVm vm;
  
  const PreferencesScreen({
    super.key,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteSmoke,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Preferences',
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
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadingIndicator(
              loading: vm.isEmailPrefsLoading,
              child: _buildEmailPreferences(vm),
            ),
            LoadingIndicator(
              loading: vm.isPushPrefsLoading,
              child: _buildPushPreferences(vm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailPreferences(ProfileVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Row(
          spacing: 10,
          children: [
            Icon(Icons.email, color: AppTheme.vividRose, size: 20),
            Text(
              'Email Preferences',
              style: TextStyle(
                color: AppTheme.vividRose,
                fontSize: 18.0,
                fontFamily: AppTheme.fontFamily,
                fontWeight: getFontWeight(600),
              ),
            ),
          ],
        ),
        CustomCard(
          addCardShadow: true,
          child: Column(
            spacing: 12,
            children: [
              _buildSwitchTile(
                'Marketing Emails',
                'Receive marketing and promotional content',
                vm.currentUser!.emailMarketing,
                (val) => vm.updateEmailPreferences(emailMarketing: val),
              ),
              _buildSwitchTile(
                'Product Updates',
                'Receive updates about new features',
                vm.currentUser!.emailProductUpdates,
                (val) => vm.updateEmailPreferences(emailProductUpdates: val),
              ),
              _buildSwitchTile(
                'Marketplace Notifications',
                'Receive notifications about marketplace activity',
                vm.currentUser!.emailMarketplaceNotifications,
                (val) => vm.updateEmailPreferences(
                  emailMarketplaceNotifications: val,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPushPreferences(ProfileVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Row(
          spacing: 10,
          children: [
            Icon(Icons.notifications, color: AppTheme.vividRose, size: 20),
            Text(
              'Push Notifications',
              style: TextStyle(
                color: AppTheme.vividRose,
                fontSize: 18.0,
                fontFamily: AppTheme.fontFamily,
                fontWeight: getFontWeight(600),
              ),
            ),
          ],
        ),
        CustomCard(
          addCardShadow: true,
          child: Column(
            spacing: 12,
            children: [
              _buildSwitchTile(
                'Pomodoro Alerts',
                'Get notified when timer ends',
                vm.currentUser!.pushPomodoroAlerts,
                (val) => vm.updatePushPreferences(pushPomodoroAlerts: val),
              ),
              _buildSwitchTile(
                'Flashcard Reminders',
                'Reminders to review flashcards',
                vm.currentUser!.pushFlashcardReminders,
                (val) => vm.updatePushPreferences(pushFlashcardReminders: val),
              ),
              _buildSwitchTile(
                'Marketplace Purchases',
                'Confirmations for your purchases',
                vm.currentUser!.pushMarketplacePurchaseConfirmations,
                (val) => vm.updatePushPreferences(
                  pushMarketplacePurchaseConfirmations: val,
                ),
              ),
              _buildSwitchTile(
                'Marketplace Sales',
                'Notifications when you make a sale',
                vm.currentUser!.pushMarketplaceSaleNotifications,
                (val) => vm.updatePushPreferences(
                  pushMarketplaceSaleNotifications: val,
                ),
              ),
              _buildSwitchTile(
                'Feature Announcements',
                'Be the first to know about new features',
                vm.currentUser!.pushFeatureAnnouncements,
                (val) =>
                    vm.updatePushPreferences(pushFeatureAnnouncements: val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppTheme.defaultBlack,
                  fontSize: 14.0,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: getFontWeight(500),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppTheme.steelMist,
                  fontSize: 12.0,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: getFontWeight(400),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.vividRose,
        ),
      ],
    );
  }
}
