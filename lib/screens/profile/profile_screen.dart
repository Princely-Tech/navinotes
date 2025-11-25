import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/profile/vm.dart';
import 'package:navinotes/services/calendar_service.dart';
import 'package:navinotes/screens/main/dashboard/calendar_connect_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ApiServiceComponent(
      child: ChangeNotifierProvider(
        create: (context) {
          return ProfileVm(
            sessionManager: context.read<SessionManager>(),
            apiServiceProvider: context.read<ApiServiceProvider>(),
            context: context,
          );
        },
        child: const _ProfileScreenBody(),
      ),
    );
  }
}

class _ProfileScreenBody extends StatelessWidget {
  const _ProfileScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteSmoke,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Profile',
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
      body: Consumer<ProfileVm>(
        builder: (context, vm, child) {
          return ScrollableController(
            mobilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            child: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingIndicator(
                  loading: vm.isProfilePictureLoading,
                  child: _buildProfileHeader(context, vm),
                ),
                LoadingIndicator(
                  loading: vm.isStatsLoading,
                  child: _buildStatsSection(vm),
                ),
                LoadingIndicator(
                  loading: vm.isProfileDataLoading,
                  child: _buildPersonalInfoSection(context, vm),
                ),
                LoadingIndicator(
                  loading: vm.isEmailPrefsLoading,
                  child: _buildEmailPreferences(vm),
                ),
                LoadingIndicator(
                  loading: vm.isPushPrefsLoading,
                  child: _buildPushPreferences(vm),
                ),
                _buildCalendarSection(context),
                LoadingIndicator(
                  loading: vm.isAccountActionLoading,
                  child: _buildAccountSection(context, vm),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileVm vm) {
    return CustomCard(
      addCardShadow: true,
      child: Column(
        children: [
          // Profile Avatar
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: AppTheme.vividRose,
                  shape: BoxShape.circle,
                ),
                child:
                    vm.currentUser?.profilePicture == null
                        ? Center(
                          child: Text(
                            vm.userName.isNotEmpty
                                ? vm.userName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              color: AppTheme.white,
                              fontSize: 32.0,
                              fontFamily: AppTheme.fontFamily,
                              fontWeight: getFontWeight(600),
                            ),
                          ),
                        )
                        : Image.network(
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          getRemoteImgPath(vm.currentUser!.profilePicture!),
                        ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () => _showImagePicker(context, vm),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.vividRose, width: 1),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: AppTheme.vividRose,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User Name
          Text(
            vm.userName,
            style: TextStyle(
              color: AppTheme.defaultBlack,
              fontSize: 24.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(600),
            ),
          ),
          const SizedBox(height: 4),
          // User Email
          Text(
            vm.userEmail,
            style: TextStyle(
              color: AppTheme.steelMist,
              fontSize: 16.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(400),
            ),
          ),
          const SizedBox(height: 8),
          // Member Since
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.mintWhisper,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Member since ${vm.memberSince}',
              style: TextStyle(
                color: AppTheme.vitalGreen,
                fontSize: 12.0,
                fontFamily: AppTheme.fontFamily,
                fontWeight: getFontWeight(500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context, ProfileVm vm) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await vm.updateProfilePicture(File(image.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Widget _buildStatsSection(ProfileVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Row(
          spacing: 10,
          children: [
            SVGImagePlaceHolder(
              imagePath: Images.chart,
              size: 20,
              color: AppTheme.vividRose,
            ),
            Text(
              'Your Statistics',
              style: TextStyle(
                color: AppTheme.vividRose,
                fontSize: 18.0,
                fontFamily: AppTheme.fontFamily,
                fontWeight: getFontWeight(600),
              ),
            ),
          ],
        ),
        CustomGrid(
          mobile: 2,
          tablet: 4,
          laptop: 4,
          largeDesktop: 4,
          children: [
            _buildStatCard(
              'Boards',
              vm.totalBoards.toString(),
              Images.folder,
              AppTheme.vividBlue,
            ),
            _buildStatCard(
              'Notes',
              vm.totalNotes.toString(),
              Images.file,
              AppTheme.vitalGreen,
            ),
            _buildStatCard(
              'Mind Maps',
              vm.totalMindMaps.toString(),
              Images.brain,
              AppTheme.electricViolet,
            ),
            _buildStatCard(
              'Files',
              vm.totalFiles.toString(),
              Images.uploadFile,
              AppTheme.spicedAmber,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String icon, Color color) {
    return CustomCard(
      addCardShadow: true,
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 8,
        children: [
          SVGImagePlaceHolder(imagePath: icon, size: 24, color: color),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.defaultBlack,
              fontSize: 24.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(700),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.steelMist,
              fontSize: 12.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context, ProfileVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                SVGImagePlaceHolder(
                  imagePath: Images.person,
                  size: 20,
                  color: AppTheme.vividRose,
                ),
                Text(
                  'Personal Information',
                  style: TextStyle(
                    color: AppTheme.vividRose,
                    fontSize: 18.0,
                    fontFamily: AppTheme.fontFamily,
                    fontWeight: getFontWeight(600),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.edit, color: AppTheme.vividRose, size: 20),
              onPressed: () => _showEditProfileDialog(context, vm),
              tooltip: 'Edit Profile',
            ),
          ],
        ),
        CustomCard(
          addCardShadow: true,
          child: Column(
            spacing: 16,
            children: [
              _buildInfoRow('Name', vm.userName),
              _buildInfoRow('Email', vm.userEmail),
              _buildInfoRow('School', vm.userSchool),
              _buildInfoRow('Field of Study', vm.userField),
              _buildInfoRow('Level', vm.userLevel),
              _buildInfoRow('Country', vm.userCountry),
              if (vm.userAbout.isNotEmpty)
                _buildInfoRow('About', vm.userAbout, isMultiline: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailPreferences(ProfileVm vm) {
    if (vm.currentUser == null) return const SizedBox.shrink();

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
    if (vm.currentUser == null) return const SizedBox.shrink();

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

  void _showEditProfileDialog(BuildContext context, ProfileVm vm) {
    final nameController = TextEditingController(text: vm.userName);
    final countryController = TextEditingController(text: vm.userCountry);
    final schoolController = TextEditingController(text: vm.userSchool);
    final fieldController = TextEditingController(text: vm.userField);
    final levelController = TextEditingController(text: vm.userLevel);
    final aboutController = TextEditingController(text: vm.userAbout);
    final iamController = TextEditingController(
      text: vm.currentUser?.iam ?? '',
    );

    showDialog(
      context: context,
      // fullscreenDialog: true,
      builder:
          (context) => AlertDialog(
            // constraints: BoxConstraints(minWidth: screenWidth(context)),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                color: AppTheme.vividRose,
                fontWeight: getFontWeight(600),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  _buildTextField('Name', nameController),
                  _buildTextField('I am (Role)', iamController),
                  _buildTextField('Country', countryController),
                  _buildTextField('School Name', schoolController),
                  _buildTextField('Field of Study', fieldController),
                  _buildTextField('Level', levelController),
                  _buildTextField('About', aboutController, maxLines: 3),
                ],
              ),
            ),
            actions: [
              AppButton.secondary(
                text: 'Cancel',
                onTap: () => Navigator.pop(context),
                color: AppTheme.steelMist,
              ),
              const SizedBox(height: 10),
              AppButton(
                text: 'Save',
                onTap: () {
                  vm.updateProfileData(
                    name: nameController.text,
                    country: countryController.text,
                    schoolName: schoolController.text,
                    schoolField: fieldController.text,
                    schoolLevel: levelController.text,
                    about: aboutController.text,
                    iam: iamController.text,
                  );
                  Navigator.pop(context);
                },
                color: AppTheme.vividRose,
              ),
            ],
          ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.vividRose),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMultiline = false}) {
    return Row(
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.steelMist,
              fontSize: 14.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(500),
            ),
          ),
        ),
        Expanded(
          child: Text(
            stringOrNotSpecified(value),
            style: TextStyle(
              color: AppTheme.defaultBlack,
              fontSize: 14.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(400),
            ),
            maxLines: isMultiline ? null : 1,
            overflow: isMultiline ? null : TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    final calendarService = CalendarService();
    final isConnected = calendarService.isDeviceConnected || calendarService.isGoogleConnected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Row(
          spacing: 10,
          children: [
            Icon(Icons.calendar_today, color: AppTheme.vividRose, size: 20),
            Text(
              'Calendar Integration',
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
            spacing: 16,
            children: [
              Row(
                children: [
                  Icon(
                    isConnected ? Icons.check_circle : Icons.cancel,
                    color: isConnected ? AppTheme.vitalGreen : AppTheme.steelMist,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isConnected ? 'Calendar Connected' : 'No Calendar Connected',
                          style: TextStyle(
                            color: AppTheme.defaultBlack,
                            fontSize: 16.0,
                            fontFamily: AppTheme.fontFamily,
                            fontWeight: getFontWeight(600),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isConnected
                              ? 'Your calendar is synced with NaviNotes'
                              : 'Connect your calendar to sync study schedules',
                          style: TextStyle(
                            color: AppTheme.steelMist,
                            fontSize: 14.0,
                            fontFamily: AppTheme.fontFamily,
                            fontWeight: getFontWeight(400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!isConnected)
                AppButton(
                  text: 'Connect Calendar',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarConnectScreen(),
                      ),
                    );
                  },
                  color: AppTheme.vividRose,
                  mainAxisSize: MainAxisSize.min,
                ),
              if (isConnected)
                AppButton.secondary(
                  text: 'Manage Calendar',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarConnectScreen(),
                      ),
                    );
                  },
                  color: AppTheme.vividRose,
                  mainAxisSize: MainAxisSize.min,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context, ProfileVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Row(
          spacing: 10,
          children: [
            SVGImagePlaceHolder(
              imagePath: Images.settings,
              size: 20,
              color: AppTheme.vividRose,
            ),
            Text(
              'Account Settings',
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
            spacing: 20,
            children: [
              // Refresh Stats Button
              AppButton.secondary(
                text: 'Refresh Statistics',
                onTap: vm.refreshStats,
                prefix: Icon(
                  Icons.refresh,
                  color: AppTheme.vividRose,
                  size: 18,
                ),
                color: AppTheme.vividRose,
              ),

              // Logout Button
              AppButton.secondary(
                text: 'Logout',
                onTap: () => _showLogoutDialog(context, vm),
                prefix: Icon(Icons.logout, color: AppTheme.steelMist, size: 18),
                color: AppTheme.steelMist,
              ),
              AppButton.secondary(
                text: 'Export data',
                onTap: vm.exportUserData,
                prefix: Icon(
                  Icons.file_download,
                  color: AppTheme.vividBlue,
                  size: 18,
                ),
                color: AppTheme.vividBlue,
              ),
              // Delete Account Button
              AppButton.secondary(
                text: 'Delete Account',
                onTap: () => _showDeleteAccountDialog(context, vm),
                prefix: Icon(
                  Icons.delete_forever,
                  color: AppTheme.bloodFire,
                  size: 18,
                ),
                color: AppTheme.bloodFire,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileVm vm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(
              color: AppTheme.defaultBlack,
              fontSize: 18.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(600),
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: AppTheme.steelMist,
              fontSize: 14.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(400),
            ),
          ),
          actions: [
            // AppButton.text(
            //   text: 'Cancel',
            //   onTap: () => Navigator.of(context).pop(),
            //   color: AppTheme.steelMist,
            // ),
            AppButton.secondary(
              text: 'Cancel',
              onTap: () => Navigator.of(context).pop(),
              color: AppTheme.steelMist,
            ),
            SizedBox(height: 10),
            AppButton(
              text: 'Logout',
              onTap: () {
                Navigator.of(context).pop();
                vm.logout();
              },
              color: AppTheme.vividRose,
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context, ProfileVm vm) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: TextStyle(
              color: AppTheme.bloodFire,
              fontSize: 18.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(600),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This action cannot be undone. All your data will be permanently deleted.',
                style: TextStyle(
                  color: AppTheme.steelMist,
                  fontSize: 14.0,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: getFontWeight(400),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please tell us why you\'re leaving (optional):',
                style: TextStyle(
                  color: AppTheme.defaultBlack,
                  fontSize: 14.0,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: getFontWeight(500),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Your feedback helps us improve...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.lightGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.vividRose),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            AppButton.secondary(
              text: 'Cancel',
              onTap: () => Navigator.of(context).pop(),
              color: AppTheme.steelMist,
            ),
            SizedBox(height: 10),
            AppButton(
              text: 'Delete Account',
              onTap: () {
                Navigator.of(context).pop();
                _showFinalConfirmationDialog(
                  context,
                  vm,
                  reasonController.text,
                );
              },
              color: AppTheme.bloodFire,
            ),
          ],
        );
      },
    );
  }

  void _showFinalConfirmationDialog(
    BuildContext context,
    ProfileVm vm,
    String reason,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Final Confirmation',
            style: TextStyle(
              color: AppTheme.bloodFire,
              fontSize: 18.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(600),
            ),
          ),
          content: Text(
            'Are you absolutely sure you want to delete your account? This action is irreversible.',
            style: TextStyle(
              color: AppTheme.steelMist,
              fontSize: 14.0,
              fontFamily: AppTheme.fontFamily,
              fontWeight: getFontWeight(400),
            ),
          ),
          actions: [
            AppButton.text(
              text: 'Cancel',
              onTap: () => Navigator.of(context).pop(),
              color: AppTheme.steelMist,
            ),
            AppButton(
              text: 'Yes, Delete',
              onTap: () {
                Navigator.of(context).pop();
                vm.deleteAccount(reason);
              },
              color: AppTheme.bloodFire,
            ),
          ],
        );
      },
    );
  }
}
