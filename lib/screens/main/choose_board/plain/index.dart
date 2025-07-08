import 'vm.dart';
import 'package:navinotes/packages.dart';

class BoardPlainScreen extends StatelessWidget {
  const BoardPlainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardPlainVm(),
      child: Consumer<BoardPlainVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: AppTheme.white,
            body: Column(
              children: [
                _header(),
                Expanded(
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
                                spacing: 30,
                                children: [
                                  CustomGrid(
                                    wrapWithIntrinsicHeight: false,
                                    laptop: 1,
                                    desktop: 2,
                                    largeDesktop: 2,
                                    spacing: 30,
                                    children: [
                                      Column(children: [_form(vm)]),
                                      Column(children: [_boardPreview()]),
                                    ],
                                  ),
                                  _whatNext(),
                                  Column(
                                    spacing: 15,
                                    children: [
                                      Consumer<BoardPlainVm>(
                                        builder: (context, vm, _) {
                                          return AppButton(
                                            mainAxisSize: MainAxisSize.min,
                                            text:
                                                vm.isLoading
                                                    ? 'Creating...'
                                                    : 'Create My Academic Board',
                                            onTap: () {
                                              if (!vm.isLoading) {
                                                vm.createBoard();
                                                return;
                                              }
                                            },
                                            color: AppTheme.vividBlue,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 25,
                                            ),
                                          );
                                        },
                                      ),

                                      Text(
                                        'Don\'t worry - you can always change these details later.',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.text.copyWith(
                                          color: AppTheme.steelMist,
                                          height: 1.43,
                                        ),
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
      addBorder: true,
      child: Column(
        spacing: 10,
        children: [
          SVGImagePlaceHolder(
            imagePath: img,
            size: 20,
            color: AppTheme.vividBlue,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.text.copyWith(
              fontSize: 16.0,
              fontWeight: getFontWeight(600),
            ),
          ),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTheme.text.copyWith(color: AppTheme.steelMist),
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
            fontSize: 20.0,
            fontWeight: getFontWeight(600),
            height: 1.40,
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
              img: Images.org,
              title: 'Smart Organization',
              body: 'Automatic material categorization',
            ),
          ],
        ),
      ],
    );
  }

  Widget _boardPreview() {
    return _grayCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            'Your Board Preview',
            style: AppTheme.text.copyWith(
              fontSize: 16.0,
              fontWeight: getFontWeight(600),
            ),
          ),
          CustomCard(
            addBorder: true,
            child: Center(
              child: WidthLimiter(
                mobile: 200,
                child: ClipRRect(
                  child: ResponsiveAspectRatio(
                    mobile: 1,
                    child: ImagePlaceHolder(
                      imagePath: Images.boardPlainPreview,
                      borderRadius: BorderRadius.circular(4),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This preview shows how your academic board will look with the BoardPlain aesthetic.',
                style: AppTheme.text.copyWith(
                  color: AppTheme.steelMist,
                  height: 1.43,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      [
                            'Clean, distraction-free interface',
                            'Organized content sections',
                            'Focus on your academic materials',
                          ]
                          .map(
                            (str) => Text(
                              str,
                              style: AppTheme.text.copyWith(
                                color: AppTheme.steelMist,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _grayCard({required Widget child}) {
    return CustomCard(
      decoration: BoxDecoration(color: AppTheme.almostWhite),
      child: child,
    );
  }

  Widget _form(BoardPlainVm vm) {
    final hintStyle = AppTheme.text.copyWith(
      color: AppTheme.slateGray,
      fontSize: 16.0,
      height: 1.50,
    );
    final labelStyle = AppTheme.text.copyWith(
      fontSize: 16.0,
      fontWeight: getFontWeight(500),
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppTheme.ghostWhite),
    );
    return _grayCard(
      child: Form(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: vm.titleController,
              hintText: 'e.g., History 1302 - Semester 2',
              label: 'What will you be studying?',
              labelStyle: labelStyle,
              border: border,
              hintStyle: hintStyle,
            ),
            CustomGrid(
              largeDesktop: 2,
              children: [
                CustomInputField(
                  controller: vm.subjectController,
                  label: 'Subject',
                  labelStyle: labelStyle,
                  border: border,
                  hintStyle: hintStyle,
                ),
                CustomInputField(
                  controller: vm.levelController,
                  label: 'Level',
                  labelStyle: labelStyle,
                  border: border,
                  hintStyle: hintStyle,
                ),
              ],
            ),
            CustomInputField(
              controller: vm.termController,
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
                  Row(
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
    BoardPlainVm vm, {
    required bool isChecked,
    required String body,
    required VoidCallback onTap,
  }) {
    return AppButton.text(
      onTap: onTap,
      text: body,
      prefix: Container(
        width: 16,
        height: 16,
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(
              color: isChecked ? AppTheme.dodgerBlue : AppTheme.black,
            ),
          ),
          color: isChecked ? AppTheme.dodgerBlue : null,
        ),
      ),
      style: AppTheme.text.copyWith(fontSize: 16.0, height: 1.50),
    );
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
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
                      decoration: BoxDecoration(color: AppTheme.vividRose),
                    ),
                  ),
                  AppButton.text(
                    wrapWithFlexible: true,
                    mainAxisSize: MainAxisSize.min,
                    prefix: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF6B7280),
                      size: 18,
                    ),
                    onTap: NavigationHelper.pop,
                    text: 'Choose Different Style',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.steelMist,
                      fontSize: 16.0,
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
        return SizedBox(
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
                      spacing: 5,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Create Your Academic Board',
                          textAlign: TextAlign.center,
                          style: AppTheme.text.copyWith(
                            fontWeight: getFontWeight(600),
                            fontSize: getDeviceResponsiveValue(
                              deviceType: layoutVm.deviceType,
                              mobile: 24.0,
                              tablet: 28.0,
                              laptop: 30.0,
                            ),
                            height: 1.20,
                          ),
                        ),
                        Text(
                          'Step 1 of 2 • Set up your scholarly workspace',
                          textAlign: TextAlign.center,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.steelMist,
                            fontSize: 16.0,
                            height: 1.50,
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
