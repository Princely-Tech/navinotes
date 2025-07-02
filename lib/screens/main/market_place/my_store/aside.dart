import 'package:navinotes/packages.dart';

class MyStoreAside extends StatelessWidget {
  const MyStoreAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VisibleController(
                    mobile: true,
                    laptop: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: _searchField(),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 25,
                    children: [_profile(), _notifications(), _tips()],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          'Tips to Increase Sales',
          style: AppTheme.text.copyWith(
            fontSize: 16.0,
            fontWeight: getFontWeight(500),
          ),
        ),
        CustomCard(
          decoration: BoxDecoration(color: AppTheme.iceBlue),
          child: Column(
            spacing: 20,
            children: [
              ...[
                'Add detailed descriptions to your mind maps',
                'Include preview images showing map details',
                'Respond to customer questions within 24 hours',
                'Bundle related maps for higher value offerings',
                'Create seasonal promotions for study periods',
              ].map(
                (str) => Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppTheme.vividRose,
                      size: 16,
                    ),
                    Expanded(
                      child: Text(
                        str,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.darkSlateGray,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                onTap: () {},
                text: 'View More Tips',
                textColor: AppTheme.vividRose,
                color: AppTheme.white,
                borderColor: AppTheme.softSkyBlue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _notifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: Text(
                'Notifications',
                style: AppTheme.text.copyWith(
                  fontSize: 16.0,
                  fontWeight: getFontWeight(500),
                ),
              ),
            ),
            AppButton.text(
              onTap: () {},
              text: 'View all',
              color: AppTheme.vividRose,
            ),
          ],
        ),
        _notificationItem(1),
        _notificationItem(2),
        _notificationItem(3),
      ],
    );
  }

  Widget _notificationItem(int index) {
    bool addBorder = index > 1;
    String text = 'New sale:';
    String text2 = 'Chemistry Mind Maps';
    String time = '2 minutes ago';
    Color outlinedBg = AppTheme.paleBlue;
    Color outlinedIconColor = AppTheme.vividRose;
    String icon = Images.shoppingCart;
    if (index == 2) {
      outlinedBg = AppTheme.yellow;
      outlinedIconColor = AppTheme.spicedAmber;
      icon = Images.star2;
      text = 'New 5-star review on';
      text2 = 'Biology Maps';
      time = '1 hour ago';
    }
    return CustomCard(
      addBorder: addBorder,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: addBorder ? AppTheme.transparent : AppTheme.iceBlue,
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedChild(
            size: 24,
            decoration: BoxDecoration(
              color: outlinedBg,
              shape: BoxShape.circle,
            ),
            child: SVGImagePlaceHolder(
              imagePath: icon,
              size: 12,
              color: outlinedIconColor,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: text,
                        style: AppTheme.text.copyWith(height: 1.0),
                      ),
                      TextSpan(
                        text: ' $text2',
                        style: AppTheme.text.copyWith(
                          fontWeight: getFontWeight(500),
                          height: 1.0,
                        ),
                      ),
                      if (index == 3)
                        TextSpan(
                          text: ' processed',
                          style: AppTheme.text.copyWith(height: 1.0),
                        ),
                    ],
                  ),
                ),
                Text(
                  time,
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
      ),
    );
  }

  Widget _profile() {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImagePlaceHolder.network(
              size: 48,
              imagePath:
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D',
            ),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'David Chen',
                    style: AppTheme.text.copyWith(
                      fontSize: 16.0,
                      fontWeight: getFontWeight(500),
                      height: 1.0,
                    ),
                  ),
                  Text(
                    'Premium Seller',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.steelMist,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Text(
                    'Profile Completeness',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.steelMist,
                      fontSize: 12.0,
                      height: 1.0,
                    ),
                  ),
                ),
                Text(
                  '85%',
                  style: AppTheme.text.copyWith(
                    fontSize: 12.0,
                    fontWeight: getFontWeight(500),
                    height: 1.0,
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              value: 85 / 100,
              backgroundColor: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(100),
              minHeight: 8,
              color: AppTheme.vividRose,
            ),
          ],
        ),

        Row(
          spacing: 10,
          children: [
            _profileItem(title: '4.7', value: 'Seller Rating'),
            _profileItem(title: '98%', value: 'Response Rate'),
            _profileItem(title: 'Active', value: 'Account Status'),
          ],
        ),
        AppButton(
          onTap: () {},
          text: 'Edit Profile',
          color: AppTheme.lightAsh,
          textColor: AppTheme.defaultBlack,
        ),
      ],
    );
  }

  Widget _profileItem({required String title, required String value}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            title,
            style: AppTheme.text.copyWith(
              color:
                  title == 'Active'
                      ? AppTheme.jungleGreen
                      : const Color(0xFF1F2937),
              fontWeight: getFontWeight(500),
              height: 1.0,
            ),
          ),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.text.copyWith(
              color: AppTheme.steelMist,
              fontSize: 12.0,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return CustomInputField(
      prefixIcon: Icon(Icons.search, color: AppTheme.blueGray, size: 20),
      hintText: 'Search store',
      hintStyle: AppTheme.text.copyWith(
        color: AppTheme.slateGray,
        height: 1.43,
      ),
    );
  }
}
