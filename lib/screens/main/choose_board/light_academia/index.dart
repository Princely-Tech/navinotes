import 'vm.dart';
import 'package:navinotes/packages.dart';

class BoardLightAcademiaScreen extends StatelessWidget {
  const BoardLightAcademiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardLightAcadVm(),
      child: Consumer<BoardLightAcadVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: AppTheme.white,
            body: Column(
              children: [
                _header(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, 0.50),
                        end: Alignment(1.00, 0.50),
                        colors: [AppTheme.pearl, AppTheme.eggShell],
                      ),
                    ),
                    child: ScrollableController(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          spacing: 10,
                          children: [
                            _titleHeader(),
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
                                  spacing: 50,
                                  children: [
                                    CustomGrid(
                                      wrapWithIntrinsicHeight: false,
                                      laptop: 1,
                                      desktop: 2,
                                      largeDesktop: 2,
                                      spacing: 30,
                                      children: [_form(vm), _boardPreview()],
                                    ),
                                    _whatNext(),
                                    Column(
                                      spacing: 10,
                                      children: [
                                        AppButton(
                                          mainAxisSize: MainAxisSize.min,
                                          text: 'Create My Academic Board',
                                          onTap: vm.createHandler,
                                          color: AppTheme.goldenTan,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 25,
                                          ),
                                          style: AppTheme.text.copyWith(
                                            color: AppTheme.ivoryCream,
                                            fontSize: 18.0,
                                            fontFamily: AppTheme.fontEBGaramond,
                                          ),
                                        ),
                                        Text(
                                          'Don\'t worry - you can always change these details later.',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.text.copyWith(
                                            color: AppTheme.steelMist,
                                            fontFamily: AppTheme.fontOpenSans,
                                            height: 1.43,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _centeredIcon(Images.book),
                                    BoardPageFooter(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _whatGrowsItem({
    required String title,
    required String body,
    required String img,
  }) {
    return CustomCard(
      addCardShadow: true,
      decoration: BoxDecoration(
        color: AppTheme.almondCream,
        border: Border.all(color: AppTheme.yellowishOrange),
      ),
      child: Column(
        spacing: 10,
        children: [
          OutlinedChild(
            size: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.eggShell.withAlpha(0xFF),
            ),
            child: SVGImagePlaceHolder(
              imagePath: img,
              size: 27,
              color: AppTheme.yellowishOrange.withAlpha(0xFF),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.text.copyWith(
              color: AppTheme.burntLeather.withAlpha(0xFF),
              fontSize: 20.0,
              fontFamily: AppTheme.fontEBGaramond,
            ),
          ),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTheme.text.copyWith(
              color: AppTheme.sepiaBrown,
              fontSize: 16.0,
              fontFamily: AppTheme.fontEBGaramond,
            ),
          ),
        ],
      ),
    );
  }

  Widget _whatNext() {
    return Column(
      spacing: 20,
      children: [
        Text(
          'What\'s Next After Setup',
          textAlign: TextAlign.center,
          style: AppTheme.text.copyWith(
            color: AppTheme.burntLeather.withAlpha(0xFF),
            fontSize: 24.0,
            fontFamily: AppTheme.fontEBGaramond,
            height: 1.33,
          ),
        ),
        CustomGrid(
          children: [
            _whatGrowsItem(
              img: Images.uploadFile,
              title: 'Upload Syllabus',
              body: 'Auto-extract course timeline & details',
            ),
            _whatGrowsItem(
              img: Images.bulb,
              title: 'AI Course Analysis',
              body: 'Get study recommendations & insights',
            ),
            _whatGrowsItem(
              img: Images.folder,
              title: 'Smart Organization',
              body: 'Automatic material categorization',
            ),
          ],
        ),
      ],
    );
  }

  Widget _boardPreview() {
    return _ivoryCreamCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            'Your Board Preview',
            style: AppTheme.text.copyWith(
              color: AppTheme.burntLeather.withAlpha(0xFF),
              fontSize: 24.0,
              fontFamily: AppTheme.fontEBGaramond,
            ),
          ),
          Column(
            children: [
              ClipRRect(
                child: ResponsiveAspectRatio(
                  mobile: 1.3,
                  laptop: 1.5,
                  desktop: 1.3,
                  largeDesktop: 1.5,
                  child: ImagePlaceHolder(
                    imagePath: Images.boardLightAcadPreview,
                    borderRadius: BorderRadius.circular(4),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This preview shows how your academic board will look with the BoardPlain aesthetic.',
                style: AppTheme.text.copyWith(
                  color: AppTheme.sepiaBrown,
                  fontSize: 16.0,
                  fontFamily: AppTheme.fontEBGaramond,
                  height: 1.50,
                ),
              ),
              Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    [
                          'Clean, distraction-free interface',
                          'Organized content sections',
                          'Focus on your academic materials',
                        ]
                        .map(
                          (str) => Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '❦   ',
                                  style: AppTheme.text.copyWith(
                                    color: AppTheme.royalGold,
                                    fontSize: 16.0,
                                    fontFamily: AppTheme.fontEBGaramond,
                                    height: 1.50,
                                  ),
                                ),
                                TextSpan(
                                  text: str,
                                  style: AppTheme.text.copyWith(
                                    color: AppTheme.sepiaBrown,
                                    fontSize: 16.0,
                                    fontFamily: AppTheme.fontEBGaramond,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ivoryCreamCard({required Widget child}) {
    return CustomCard(
      addCardShadow: true,
      decoration: BoxDecoration(
        color: AppTheme.ivoryCream,
        border: Border.all(color: AppTheme.yellowishOrange),
      ),
      child: child,
    );
  }

  Widget _form(BoardLightAcadVm vm) {
    final hintStyle = AppTheme.text.copyWith(
      color: AppTheme.slateGray,
      fontSize: 16.0,
      fontFamily: AppTheme.fontEBGaramond,
      height: 1.50,
    );
    Color fillColor = AppTheme.eggShell.withAlpha(0xFF);
    final labelStyle = AppTheme.text.copyWith(
      color: AppTheme.sepiaBrown,
      fontSize: 16.0,
      fontFamily: AppTheme.fontEBGaramond,
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppTheme.burntLeather.withAlpha(0x4C)),
    );
    return _ivoryCreamCard(
      child: Form(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              fillColor: fillColor,
              hintText: 'e.g., History 1302 - Semester 2',
              label: 'What will you be studying?',
              labelStyle: labelStyle,
              border: border,
              hintStyle: hintStyle,
            ),
            CustomInputField(
              fillColor: fillColor,
              label: 'Subject',
              labelStyle: labelStyle,
              border: border,
              hintStyle: hintStyle,
            ),
            CustomInputField(
              fillColor: fillColor,
              label: 'Level',
              labelStyle: labelStyle,
              border: border,
              hintStyle: hintStyle,
            ),
            CustomInputField(
              fillColor: fillColor,
              label: 'Academic Term',
              labelStyle: labelStyle,
              border: border,
              hintStyle: hintStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Text('Board Privacy', style: labelStyle),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      _privacySettingItem(
                        vm,
                        body: 'Private',
                        isChecked: vm.isPrivate,
                        onTap: () => vm.updateIsPrivate(true),
                      ),
                      _privacySettingItem(
                        vm,
                        body: 'Shareable',
                        isChecked: !vm.isPrivate,
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
    BoardLightAcadVm vm, {
    required bool isChecked,
    required String body,
    required VoidCallback onTap,
  }) {
    return AppButton.text(
      onTap: onTap,
      text: body,
      prefix: Container(
        width: 20,
        height: 20,
        decoration: ShapeDecoration(
          shape: CircleBorder(side: BorderSide(color: AppTheme.royalGold)),
        ),
      ),
      style: AppTheme.text.copyWith(
        color: isChecked ? AppTheme.goldenTan : AppTheme.jetCharcoal,
        fontSize: 16.0,
        fontFamily: AppTheme.fontEBGaramond,
      ),
    );
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [AppTheme.eggShell.withAlpha(0xFF), AppTheme.ivoryCream],
        ),
        border: Border(bottom: BorderSide(color: AppTheme.yellowishOrange)),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ResponsivePadding(
        mobile: EdgeInsets.symmetric(horizontal: mobilePadding),
        tablet: EdgeInsets.symmetric(horizontal: tabletPadding),
        child: Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: MenuButton(
                      onPressed: () {},
                      decoration: BoxDecoration(color: AppTheme.burntLeather),
                    ),
                  ),
                  AppButton.text(
                    wrapWithFlexible: true,
                    mainAxisSize: MainAxisSize.min,
                    prefix: Icon(
                      Icons.arrow_back,
                      color: AppTheme.burntLeather,
                      size: 18,
                    ),
                    onTap: NavigationHelper.pop,
                    text: 'Choose Different Style',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.sepiaBrown,
                      fontSize: 16.0,
                      fontFamily: AppTheme.fontEBGaramond,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
            ProfilePic(),
          ],
        ),
      ),
    );
  }

  Widget _titleHeader() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          padding: EdgeInsets.only(bottom: 20, top: 40),
          width: double.infinity,
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
                      spacing: 25,
                      children: [
                        Text(
                          'Create Your Academic Board',
                          textAlign: TextAlign.center,
                          style: AppTheme.text.copyWith(
                            fontSize: getDeviceResponsiveValue(
                              deviceType: layoutVm.deviceType,
                              mobile: 24.0,
                              tablet: 28.0,
                              laptop: 30.0,
                              desktop: 35.0,
                              largeDesktop: 48.0,
                            ),
                            color: AppTheme.jetCharcoal,
                            fontFamily: AppTheme.fontEBGaramond,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          'Step 1 of 2 • Set up your scholarly workspace',
                          textAlign: TextAlign.center,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.sepiaBrown,
                            fontSize: 18.0,
                            fontFamily: AppTheme.fontEBGaramond,
                            height: 1.56,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: _centeredIcon(Images.leaf2),
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

  Widget _centeredIcon(String icon) {
    return WidthLimiter(
      mobile: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 25,
        children: [
          _divider(),
          SVGImagePlaceHolder(
            imagePath: icon,
            size: 24,
            color: AppTheme.royalGold,
          ),
          _divider(),
        ],
      ),
    );
  }

  Widget _divider() {
    return Expanded(
      child: Divider(
        color: AppTheme.yellowishOrange.withAlpha(0x66),
        height: 1.0,
      ),
    );
  }
}
