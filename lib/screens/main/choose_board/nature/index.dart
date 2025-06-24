import 'vm.dart';
import 'package:navinotes/packages.dart';

class BoardNatureScreen extends StatelessWidget {
  const BoardNatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardNatureVm(),
      child: Consumer<BoardNatureVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: AppTheme.softLinen,
            body: ScrollableController(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VisibleController(
                      mobile: false,
                      laptop: true,
                      child: ResponsivePadding(
                        mobile: EdgeInsets.only(left: mobilePadding, top: 5),
                        tablet: EdgeInsets.only(left: tabletPadding, top: 5),
                        child: MenuButton(
                          onPressed: () {},
                          decoration: BoxDecoration(color: AppTheme.vividRose),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        spacing: 30,
                        children: [
                          _header(),
                          ResponsivePadding(
                            mobile: EdgeInsets.symmetric(
                              horizontal: mobilePadding,
                            ),
                            tablet: EdgeInsets.symmetric(
                              horizontal: tabletPadding,
                            ),
                            child: WidthLimiter(
                              mobile: largeDesktopSize,
                              child: Column(
                                spacing: 30,
                                children: [
                                  CustomGrid(
                                    laptop: 1,
                                    desktop: 2,
                                    largeDesktop: 2,
                                    spacing: 30,
                                    children: [
                                      _form(vm),
                                      Column(children: [_boardPreview()]),
                                    ],
                                  ),
                                  _whatGrowsNext(),
                                  Column(
                                    spacing: 10,
                                    children: [
                                      AppButton(
                                        mainAxisSize: MainAxisSize.min,
                                        text: 'Cultivate My Academic Sanctuary',
                                        onTap: vm.createHandler,
                                        gradient: LinearGradient(
                                          begin: Alignment(0.00, 0.50),
                                          end: Alignment(1.00, 0.50),
                                          colors: [
                                            AppTheme.sageMist,
                                            AppTheme.mossGreen,
                                          ],
                                        ),
                                        style: AppTheme.text.copyWith(
                                          fontSize: 18.0,
                                          fontWeight: getFontWeight(500),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 10,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Don\'t worry - you can always change these details later.',
                                              textAlign: TextAlign.center,
                                              style: AppTheme.text.copyWith(
                                                color: AppTheme.walnutBronze,
                                                height: 1.43,
                                              ),
                                            ),
                                          ),
                                          _leafSvg(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _whatGrowsItem({
    required String title,
    required String body,
    required String image,
    required Color color,
  }) {
    Color shadowColor = AppTheme.black.withAlpha(0x19);
    return CustomCard(
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        spacing: 10,
        children: [
          SVGImagePlaceHolder(
            imagePath: image,
            size: 30,
            color: AppTheme.mossGreen,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.text.copyWith(
              fontSize: 20.0,
              fontFamily: AppTheme.fontCrimsonText,
            ),
          ),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTheme.text.copyWith(
              color: AppTheme.walnutBronze,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _whatGrowsNext() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.walnutBronze.withAlpha(0x19),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ResponsivePadding(
        mobile: EdgeInsets.all(15),
        tablet: EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          children: [
            Text(
              'What Grows Next',
              textAlign: TextAlign.center,
              style: AppTheme.text.copyWith(
                color: AppTheme.mossGreen,
                fontSize: 24.0,
                fontFamily: AppTheme.fontCrimsonText,
              ),
            ),
            CustomGrid(
              children: [
                _whatGrowsItem(
                  color: AppTheme.sageMist.withAlpha(0x33),
                  title: 'Plant Your Syllabus',
                  body: 'Cultivate course timeline & growth plan',
                  image: Images.plant,
                ),
                _whatGrowsItem(
                  color: AppTheme.walnutBronze.withAlpha(0x33),
                  title: 'AI Growth Analysis',
                  body: 'Nurture study habits & learning insights',
                  image: Images.brain,
                ),
                _whatGrowsItem(
                  color: AppTheme.sageMist.withAlpha(0x33),
                  title: 'Organic Organization',
                  body: 'Natural material categorization & flow',
                  image: Images.stack,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _boardPreview() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            'Your Sanctuary Preview',
            style: AppTheme.text.copyWith(
              color: AppTheme.mossGreen,
              fontSize: 24.0,
              fontFamily: AppTheme.fontCrimsonText,
            ),
          ),
          ClipRRect(
            child: ResponsiveAspectRatio(
              mobile: 3 / 1,
              laptop: 2 / 1,
              desktop: 3 / 1,
              child: ImagePlaceHolder(
                imagePath: Images.boardNaturePreview,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Text(
            'This preview shows how your academic sanctuary will flourish with the Nature aesthetic.',
            style: AppTheme.text.copyWith(
              color: AppTheme.walnutBronze,
              fontSize: 16.0,
              height: 1.50,
            ),
          ),
          Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                [
                      '🌿 Organic, calming interface',
                      '🌳 Nature-inspired organization',
                      '🍃 Focus on natural learning flow',
                    ]
                    .map(
                      (str) => Text(
                        str,
                        style: AppTheme.text.copyWith(
                          fontSize: 16.0,
                          height: 1.50,
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    Color shadowColor = AppTheme.black.withAlpha(0x19);
    return CustomCard(
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _form(BoardNatureVm vm) {
    final labelStyle = AppTheme.text.copyWith(
      color: AppTheme.mossGreen,
      fontSize: 18.0,
      fontFamily: AppTheme.fontCrimsonText,
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 2, color: AppTheme.sageMist),
    );
    return _whiteCard(
      child: Form(
        child: Column(
          spacing: 15,
          children: [
            CustomInputField(
              hintText: 'e.g., Environmental Science 101 - Spring Semester',
              label: 'What will you be studying?',
              labelStyle: labelStyle,
              border: border,
            ),
            CustomInputField(
              label: 'Field of Study',
              labelStyle: labelStyle,
              suffixIcon: _leafSvg(),
              border: border,
            ),
            CustomInputField(
              label: 'Academic Level',
              labelStyle: labelStyle,
              suffixIcon: _leafSvg(),
              border: border,
            ),
            CustomInputField(
              label: 'Growing Season',
              labelStyle: labelStyle,
              suffixIcon: _leafSvg(),
              border: border,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Text('Sanctuary Privacy', style: labelStyle),
                  Column(
                    spacing: 10,
                    children: [
                      _privacySettingItem(
                        vm,
                        body: 'Only visible to you',
                        icon: Images.tree,
                        isChecked: vm.isPrivate,
                        title: 'Private Grove',
                        onTap: () => vm.updateIsPrivate(true),
                      ),
                      _privacySettingItem(
                        vm,
                        body: 'Can be shared via link',
                        icon: Images.plant,
                        isChecked: !vm.isPrivate,
                        title: 'Shared Garden',
                        onTap: () => vm.updateIsPrivate(false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _privacySettingItem(
    BoardNatureVm vm, {
    required bool isChecked,
    required String title,
    required String body,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        spacing: 15,
        children: [
          Container(
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  color: isChecked ? AppTheme.dodgerBlue : AppTheme.black,
                ),
              ),
            ),
            padding: EdgeInsets.all(3),
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: isChecked ? AppTheme.dodgerBlue : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              spacing: 6,
              children: [
                SVGImagePlaceHolder(
                  imagePath: icon,
                  color: AppTheme.mossGreen,
                  size: 16,
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$title ',
                          style: AppTheme.text.copyWith(
                            fontSize: 16.0,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: body,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.walnutBronze,
                            height: 1.43,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _leafSvg() {
    return SVGImagePlaceHolder(
      imagePath: Images.leaf,
      size: 12,
      color: AppTheme.sageMist,
    );
  }

  Widget _header() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [AppTheme.softLinen, AppTheme.paleSage],
            ),
          ),
          padding: EdgeInsets.only(bottom: 30),
          child: ResponsivePadding(
            mobile: EdgeInsets.all(mobilePadding),
            tablet: EdgeInsets.symmetric(
              horizontal: tabletPadding,
              vertical: mobilePadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: WidthLimiter(
                    mobile: largeDesktopSize,
                    child: Column(
                      spacing: 5,
                      children: [
                        Row(
                          spacing: 15,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppButton.text(
                              wrapWithFlexible: true,
                              mainAxisSize: MainAxisSize.min,
                              prefix: Icon(
                                Icons.arrow_back,
                                color: AppTheme.mossGreen,
                                size: 18,
                              ),
                              onTap: NavigationHelper.pop,
                              color: AppTheme.mossGreen,
                              suffix: _leafSvg(),
                              text: 'Choose Different Style',
                            ),
                            ProfilePic(),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Create Your Academic Sanctuary',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.mossGreen,
                            fontSize: getDeviceResponsiveValue(
                              deviceType: layoutVm.deviceType,
                              mobile: 24.0,
                              tablet: 28.0,
                              laptop: 32.0,
                              desktop: 36.0,
                            ),
                            fontFamily: AppTheme.fontCrimsonText,
                          ),
                        ),
                        Text(
                          'Step 1 of 2 • Set up your scholarly workspace',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.walnutBronze,
                            fontSize: 18.0,
                            height: 1.56,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
