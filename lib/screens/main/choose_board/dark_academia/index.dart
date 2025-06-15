import 'vm.dart';
import 'package:navinotes/packages.dart';

class DarkAcademiaScreen extends StatelessWidget {
  const DarkAcademiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DarkAcademiaVm(),
      child: Consumer<DarkAcademiaVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: Apptheme.deepRoast,
            body: ScrollableController(
              mobilePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              tabletPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VisibleController(
                      mobile: false,
                      laptop: true,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: MenuButton(
                          onPressed: () {},
                          decoration: BoxDecoration(color: Apptheme.oatCream),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          spacing: 30,
                          children: [
                            _header(),
                            CustomGrid(
                              laptop: 1,
                              desktop: 2,
                              largeDesktop: 2,
                              children: [
                                _form(vm),
                                Column(children: [_boardPreview()]),
                              ],
                            ),
                            _features(),
                            AppButton(
                              mainAxisSize: MainAxisSize.min,
                              color: Apptheme.royalGold,
                              text: 'Create My Academic Board',
                              onTap: () {},
                              style: Apptheme.text.copyWith(
                                color: Apptheme.deepRoast,
                                fontSize: 16.0,
                                fontFamily: Apptheme.fontPlayfairDisplay,
                              ),
                            ),
                            WidthLimiter(
                              mobile: 370,
                              child: Text(
                                'Don\'t worry - you can always change these details later.',
                                textAlign: TextAlign.center,
                                style: Apptheme.text.copyWith(
                                  color: Apptheme.velvetCream,
                                  fontSize: 16.0,
                                  fontFamily: Apptheme.fontPlayfairDisplay,
                                  height: 1.50,
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _featureCard({
    required String title,
    required String body,
    required String img,
  }) {
    return _oatCreamCard(
      tabletPadding: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          SVGImagePlaceHolder(
            imagePath: img,
            color: Apptheme.royalGold,
            size: 27,
          ),
          Text(
            title,
            style: Apptheme.text.copyWith(
              color: Apptheme.deepRoast,
              fontSize: 20.0,
              fontFamily: Apptheme.fontPlayfairDisplay,
            ),
          ),
          Text(
            body,
            style: Apptheme.text.copyWith(
              color: const Color(0xCC3C2A1E),
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _features() {
    return CustomGrid(
      tablet: 2,
      desktop: 3,
      children: [
        _featureCard(
          body: 'Auto-extract course timeline & details',
          img: Images.book2,
          title: 'Upload Syllabus',
        ),
        _featureCard(
          body: 'Get study recommendations & insights',
          img: Images.book2,
          title: 'AI Course Analysis',
        ),
        _featureCard(
          body: 'Automatic material categorization',
          img: Images.org,
          title: 'Smart Organization',
        ),
      ],
    );
  }

  Widget _boardPreview() {
    return _oatCreamCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            'Your Board Preview',
            style: Apptheme.text.copyWith(
              color: Apptheme.deepRoast,
              fontSize: 24.0,
              fontFamily: Apptheme.fontPlayfairDisplay,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: ShapeDecoration(
              color: Apptheme.shadowBark,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Apptheme.lightGray),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            padding: EdgeInsets.all(15),
            child: ResponsiveAspectRatio(
              mobile: 3 / 1,
              laptop: 2 / 1,
              desktop: 3 / 1,
              child: ImagePlaceHolder(
                imagePath: Images.boardDarkAcadpreview,
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _oatCreamCard({required Widget child, double tabletPadding = 30}) {
    return CustomCard(
      decoration: BoxDecoration(color: Apptheme.oatCream),
      padding: EdgeInsets.zero,
      child: ResponsivePadding(
        mobile: EdgeInsets.all(20),
        tablet: EdgeInsets.all(tabletPadding),
        child: child,
      ),
    );
  }

  Widget _form(DarkAcademiaVm vm) {
    TextStyle labelStyle = Apptheme.text.copyWith(
      color: Apptheme.deepRoast,
      fontSize: 20.0,
      fontFamily: Apptheme.fontPlayfairDisplay,
    );
    return _oatCreamCard(
      child: Form(
        child: Column(
          spacing: 15,
          children: [
            CustomInputField(
              hintText: 'e.g., History 1302 - Semester 2',
              label: 'What will you be studying?',
              labelStyle: labelStyle,
            ),
            Row(
              spacing: 15,
              children: [
                CustomInputField(
                  wrapWithExpanded: true,
                  label: 'Subject',
                  labelStyle: labelStyle,
                ),
                CustomInputField(
                  wrapWithExpanded: true,
                  label: 'Level',
                  hintText: 'Undergraduate',
                  controller: TextEditingController(text: 'Undergraduate'),
                  selectItems: ['Undergraduate', 'Postgraduate'],
                  labelStyle: labelStyle,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  Text(
                    'Privacy Setting',
                    style: Apptheme.text.copyWith(
                      color: Apptheme.deepRoast,
                      fontSize: 16.0,
                      fontFamily: Apptheme.fontPlayfairDisplay,
                    ),
                  ),
                  Column(
                    spacing: 7,
                    children: [
                      _privacySettingItem(
                        vm,
                        body: 'Only visible to you',
                        icon: '🏛️',
                        isChecked: vm.isPrivate,
                        title: 'Private Study',
                        onTap: () => vm.updateIsPrivate(true),
                      ),
                      _privacySettingItem(
                        vm,
                        body: 'Can be shared via link',
                        icon: '📚',
                        isChecked: !vm.isPrivate,
                        title: 'Academic Circle',
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
    DarkAcademiaVm vm, {
    required bool isChecked,
    required String title,
    required String body,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: CustomCard(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Apptheme.cocoaVeil, width: 2),
          color: Apptheme.transparent,
        ),
        child: Row(
          spacing: 15,
          children: [
            Container(
              decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(
                    color: isChecked ? Apptheme.dodgerBlue : Apptheme.black,
                  ),
                ),
              ),
              padding: EdgeInsets.all(3),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: isChecked ? Apptheme.dodgerBlue : null,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                spacing: 6,
                children: [
                  Text(
                    icon, //TODO download icons
                    style: Apptheme.text.copyWith(
                      color: Apptheme.black,
                      fontSize: 16.0,
                      height: 1.50,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          title,
                          style: Apptheme.text.copyWith(
                            color: Apptheme.deepRoast,
                            fontSize: 16.0,
                            fontWeight: getFontWeight(500),
                          ),
                        ),
                        Text(
                          body,
                          style: Apptheme.text.copyWith(
                            color: Apptheme.espressoShadow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              AppButton.text(
                mainAxisSize: MainAxisSize.min,
                prefix: Icon(
                  Icons.arrow_back,
                  color: Apptheme.oatCream,
                  size: 18,
                ),
                onTap: NavigationHelper.pop,
                color: Apptheme.oatCream,
                text: 'Choose Different Style',
              ),
              Text(
                'Create Your Academic Board',
                style: Apptheme.text.copyWith(
                  color: Apptheme.oatCream,
                  fontSize: getDeviceResponsiveValue(
                    deviceType: layoutVm.deviceType,
                    mobile: 24.0,
                    tablet: 28.0,
                    laptop: 32.0,
                    desktop: 36.0,
                  ),
                  fontFamily: Apptheme.fontPlayfairDisplay,
                ),
              ),
              Text(
                'Step 1 of 2 • Set up your scholarly workspace',
                style: Apptheme.text.copyWith(
                  color: Apptheme.velvetCream,
                  fontSize: 16.0,
                  height: 1.50,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
