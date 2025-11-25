import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/profile/vm.dart';
import 'package:navinotes/services/calendar_service.dart';
import 'package:navinotes/screens/main/dashboard/calendar_connect_screen.dart';
import 'package:navinotes/screens/profile/preferences_screen.dart';

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
                _buildPreferencesSection(context, vm),
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

  Widget _buildPreferencesSection(BuildContext context, ProfileVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Row(
          spacing: 10,
          children: [
            Icon(Icons.tune, color: AppTheme.vividRose, size: 20),
            Text(
              'Preferences',
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
            children: [
              _buildMenuTile(
                context,
                icon: Icons.email_outlined,
                iconColor: AppTheme.vividBlue,
                iconBgColor: AppTheme.paleBlue,
                title: 'Email Preferences',
                subtitle: 'Marketing, updates, and notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreferencesScreen(vm: vm),
                    ),
                  );
                },
              ),
              Divider(height: 1, color: AppTheme.lightGray),
              _buildMenuTile(
                context,
                icon: Icons.notifications_outlined,
                iconColor: AppTheme.spicedAmber,
                iconBgColor: Color(0xFFFFF8E1),
                title: 'Push Notifications',
                subtitle: 'Pomodoro, flashcards, and reminders',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreferencesScreen(vm: vm),
                    ),
                  );
                },
              ),
            ],
          ),
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
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarConnectScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isConnected 
                          ? AppTheme.mintWhisper 
                          : AppTheme.lavenderBlush,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isConnected ? Icons.check_circle : Icons.calendar_month,
                      color: isConnected ? AppTheme.vitalGreen : AppTheme.vividRose,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isConnected ? 'Calendar Connected' : 'Connect Calendar',
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
                              ? 'Tap to manage calendar settings'
                              : 'Sync study schedules and assignments',
                          style: TextStyle(
                            color: AppTheme.steelMist,
                            fontSize: 13.0,
                            fontFamily: AppTheme.fontFamily,
                            fontWeight: getFontWeight(400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.steelMist,
                    size: 16,
                  ),
                ],
              ),
            ),
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
              'Account',
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
            children: [
              _buildMenuTile(
                context,
                icon: Icons.refresh,
                iconColor: AppTheme.vividRose,
                iconBgColor: AppTheme.lavenderBlush,
                title: 'Refresh Statistics',
                subtitle: 'Update your boards and notes count',
                onTap: vm.refreshStats,
              ),
              Divider(height: 1, color: AppTheme.lightGray),
              _buildMenuTile(
                context,
                icon: Icons.file_download_outlined,
                iconColor: AppTheme.vividBlue,
                iconBgColor: AppTheme.paleBlue,
                title: 'Export Data',
                subtitle: 'Download your account information',
                onTap: vm.exportUserData,
              ),
              Divider(height: 1, color: AppTheme.lightGray),
              _buildMenuTile(
                context,
                icon: Icons.logout,
                iconColor: AppTheme.steelMist,
                iconBgColor: AppTheme.whiteSmoke,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: () => _showLogoutDialog(context, vm),
              ),
              Divider(height: 1, color: AppTheme.lightGray),
              _buildMenuTile(
                context,
                icon: Icons.delete_forever_outlined,
                iconColor: AppTheme.bloodFire,
                iconBgColor: Color(0xFFFFEBEE),
                title: 'Delete Account',
                subtitle: 'Permanently remove your account',
                onTap: () => _showDeleteAccountDialog(context, vm),
                showArrow: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.defaultBlack,
                      fontSize: 15.0,
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
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.steelMist,
                size: 14,
              ),
          ],
        ),
      ),
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
           Row(children:[
             Expanded(
               child: AppButton.secondary(
                text: 'Cancel',
                onTap: () => Navigator.of(context).pop(),
                color: AppTheme.steelMist,
                           ),
             ),
            SizedBox(width: 10),
            Expanded(
              child: AppButton(
              text: 'Logout',
              onTap: () {
                Navigator.of(context).pop();
                vm.logout();
              },
              color: AppTheme.vividRose,
            ),
            ),
           ]),
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
                'This action cannot be undone. All your data will be permanently deleted.\nnsure you have exported your data before deleting your account.',
                style: TextStyle(
                  color: AppTheme.steelMist,
                  fontSize: 14.0,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: getFontWeight(400),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please tell us why you\'re leaving:',
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
                maxLines: 2,
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
            Row(
            
              children: [
             Expanded(
               child: AppButton.secondary(
                text: 'Cancel',
                onTap: () => Navigator.of(context).pop(),
                color: AppTheme.steelMist,
                           ),
             ),
            SizedBox(width: 10),
            Expanded(
              child: AppButton(
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
            ),),
            ]),
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
