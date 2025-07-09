import 'package:navinotes/screens/main/choose_board/common/create_vm.dart';
import 'package:navinotes/packages.dart';

class MinimalistScreen extends StatelessWidget {
  const MinimalistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardCreateVm(boardType: BoardTypeCodes.minimalist),
      child: Consumer<BoardCreateVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: AppTheme.white,
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
                          decoration: BoxDecoration(color: AppTheme.midGray),
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
                                      Column(children: [_form(vm)]),
                                      Column(children: [_boardPreview()]),
                                    ],
                                  ),
                                  _whatNext(),
                                  Column(
                                    spacing: 20,
                                    children: [
                                      AppButton.secondary(
                                        mainAxisSize: MainAxisSize.min,
                                        text:
                                            vm.isLoading
                                                ? 'Creating...'
                                                : 'Create My Academic Board',
                                        onTap: vm.createBoard,
                                        style: AppTheme.text.copyWith(
                                          color: AppTheme.vividRose,
                                          fontWeight: getFontWeight(300),
                                          letterSpacing: 0.35,
                                        ),
                                      ),
                                      Text(
                                        'Don\'t worry - you can always change these details later.',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.text.copyWith(
                                          color: AppTheme.midGray,
                                          fontSize: 12.0,
                                          fontWeight: getFontWeight(300),
                                          height: 1.33,
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _whatGrowsItem({required String title, required String body}) {
    return CustomCard(
      addBorder: true,
      child: Column(
        spacing: 5,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: SVGImagePlaceHolder(
              imagePath: Images.ques2,
              size: 20,
              color: AppTheme.vividRose,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.text.copyWith(
              color: AppTheme.graniteGray,
              fontSize: 16.0,
              fontWeight: getFontWeight(300),
            ),
          ),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTheme.text.copyWith(
              color: AppTheme.midGray,
              fontWeight: getFontWeight(300),
              height: 1.64,
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
            color: AppTheme.graniteGray,
            fontSize: 20.0,
            fontWeight: getFontWeight(300),
            height: 1.40,
            letterSpacing: 0.50,
          ),
        ),
        CustomGrid(
          children: [
            _whatGrowsItem(
              title: 'Upload Syllabus',
              body: 'Auto-extract course timeline & details',
            ),
            _whatGrowsItem(
              title: 'AI Course Analysis',
              body: 'Get study recommendations & insights',
            ),
            _whatGrowsItem(
              title: 'Smart Organization',
              body: 'Automatic material categorization',
            ),
          ],
        ),
      ],
    );
  }

  Widget _boardPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          'Your Board Preview',
          style: AppTheme.text.copyWith(
            color: AppTheme.graniteGray,
            fontSize: 20.0,
            fontWeight: getFontWeight(300),
            height: 1.40,
            letterSpacing: 0.50,
          ),
        ),
        ClipRRect(
          child: ResponsiveAspectRatio(
            mobile: 3 / 1,
            laptop: 2 / 1,
            desktop: 3 / 1,
            child: ImagePlaceHolder(
              imagePath: Images.boardMinimalistPreview,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        Text(
          'This preview shows how your academic board will look with the Minimalist aesthetic.',
          style: AppTheme.text.copyWith(
            color: AppTheme.graniteGray,
            fontWeight: getFontWeight(300),
            height: 1.64,
          ),
        ),
        Column(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              [
                    'Ultra-clean, distraction-free interface',
                    'Generous whitespace and breathing room',
                    'Focus on essential academic content',
                  ]
                  .map(
                    (str) => Row(
                      spacing: 10,
                      children: [
                        Icon(Icons.check, color: AppTheme.vividRose),
                        Expanded(
                          child: Text(
                            str,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.midGray,
                              fontWeight: getFontWeight(300),
                              height: 1.64,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _form(BoardCreateVm vm) {
    final hintStyle = AppTheme.text.copyWith(
      color: AppTheme.slateGray,
      fontSize: 16.0,
      fontWeight: getFontWeight(300),
      height: 1.43,
    );
    final labelStyle = AppTheme.text.copyWith(
      color: AppTheme.graniteGray,
      fontWeight: getFontWeight(300),
      letterSpacing: 0.35,
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppTheme.ghostWhite),
    );
    return Form(
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
          CustomInputField(
            controller: vm.subjectController,
            label: 'Academic Subject',
            labelStyle: labelStyle,
            border: border,
            hintStyle: hintStyle,
          ),
          CustomInputField(
            controller: vm.levelController,
            label: 'Academic Level',
            labelStyle: labelStyle,
            border: border,
            hintStyle: hintStyle,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    _privacySettingItem(
                      vm,
                      body: 'Private (only you can access)',
                      isChecked: vm.isPrivate,
                      onTap: () => vm.updateIsPrivate(true),
                    ),
                    _privacySettingItem(
                      vm,
                      body: 'Shareable (you control access)',
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
    );
  }

  Widget _privacySettingItem(
    BoardCreateVm vm, {
    required bool isChecked,
    required String body,
    required VoidCallback onTap,
  }) {
    return AppButton.text(
      onTap: onTap,
      text: body,
      prefix: Container(
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
      style: AppTheme.text.copyWith(
        color: AppTheme.graniteGray,
        fontWeight: getFontWeight(300),
      ),
    );
  }

  Widget _header() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          width: double.infinity,
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
                                color: AppTheme.midGray,
                                size: 18,
                              ),
                              onTap: NavigationHelper.pop,
                              text: 'Choose Different Style',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.midGray,
                                fontWeight: getFontWeight(300),
                                height: 1.43,
                              ),
                            ),
                            ProfilePic(),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Create Your Academic Board',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.graniteGray,
                            fontWeight: getFontWeight(200),
                            fontSize: getDeviceResponsiveValue(
                              deviceType: layoutVm.deviceType,
                              mobile: 24.0,
                              tablet: 28.0,
                              laptop: 32.0,
                              desktop: 36.0,
                            ),
                          ),
                        ),
                        Text(
                          'Step 1 of 2 • Set up your scholarly workspace',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.midGray,
                            height: 1.43,
                            letterSpacing: 0.70,
                            fontWeight: getFontWeight(300),
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
