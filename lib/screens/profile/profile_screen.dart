import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/profile/vm.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        // Try to get ApiServiceProvider, but provide a fallback if not available
        ApiServiceProvider? apiServiceProvider;
        try {
          apiServiceProvider = context.read<ApiServiceProvider>();
        } catch (e) {
          // ApiServiceProvider not available in context
          debugPrint('ApiServiceProvider not found in context: $e');
        }
        
        return ProfileVm(
          sessionManager: context.read<SessionManager>(),
          apiServiceProvider: apiServiceProvider,
          context: context,
        );
      },
      child: const _ProfileScreenBody(),
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
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.vividRose),
            );
          }

          return ScrollableController(
            mobilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            child: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(vm),
                _buildStatsSection(vm),
                _buildPersonalInfoSection(vm),
                _buildAccountSection(context, vm),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(ProfileVm vm) {
    return CustomCard(
      addCardShadow: true,
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.vividRose,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                vm.userName.isNotEmpty ? vm.userName[0].toUpperCase() : 'U',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 32.0,
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: getFontWeight(600),
                ),
              ),
            ),
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
          SVGImagePlaceHolder(
            imagePath: icon,
            size: 24,
            color: color,
          ),
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

  Widget _buildPersonalInfoSection(ProfileVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
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
        CustomCard(
          addCardShadow: true,
          child: Column(
            spacing: 16,
            children: [
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

  Widget _buildInfoRow(String label, String value, {bool isMultiline = false}) {
    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
            value,
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
            spacing: 12,
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
              const SizedBox(height: 8),
              // Logout Button
              AppButton.secondary(
                text: 'Logout',
                onTap: () => _showLogoutDialog(context, vm),
                prefix: Icon(
                  Icons.logout,
                  color: AppTheme.steelMist,
                  size: 18,
                ),
                color: AppTheme.steelMist,
              ),
              const SizedBox(height: 8),
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
            AppButton.text(
              text: 'Cancel',
              onTap: () => Navigator.of(context).pop(),
              color: AppTheme.steelMist,
            ),
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
            AppButton.text(
              text: 'Cancel',
              onTap: () => Navigator.of(context).pop(),
              color: AppTheme.steelMist,
            ),
            AppButton(
              text: 'Delete Account',
              onTap: () {
                Navigator.of(context).pop();
                _showFinalConfirmationDialog(context, vm, reasonController.text);
              },
              color: AppTheme.bloodFire,
            ),
          ],
        );
      },
    );
  }

  void _showFinalConfirmationDialog(BuildContext context, ProfileVm vm, String reason) {
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
