import 'vm.dart';
import 'package:navinotes/packages.dart';

class BoardLightAcadEditScreen extends StatelessWidget {
  const BoardLightAcadEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardLightAcadEditVm(),
      child: Consumer<BoardLightAcadEditVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: AppTheme.eggShell.withAlpha(0xFF),
            body: Column(
              children: [
                _header(),
                Expanded(
                  child: ScrollableController(
                    mobilePadding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: ResponsivePadding(
                            mobile: EdgeInsets.symmetric(
                              horizontal: tabletPadding,
                            ),
                            tablet: EdgeInsets.symmetric(horizontal: 30),
                            child: WidthLimiter(
                              mobile: largeDesktopSize,
                              child: Column(
                                spacing: 30,
                                children: [
                                  // _welcome(),
                                  // _sectionCard(
                                  //   header: 'Course Timeline',
                                  //   color: AppTheme.almondCream,
                                  //   img: Images.ques2,
                                  //   title:
                                  //       'Your learning journey will bloom here',
                                  //   body:
                                  //       'After uploading your syllabus, we\'ll automatically generate a timeline of important dates, assignments, and events for your semester',
                                  //   button: AppButton.secondary(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     onTap: () {},
                                  //     color: AppTheme.lightBrown,
                                  //     text:
                                  //         'Upload syllabus to generate timeline',
                                  //     style: TextStyle(
                                  //       color: const Color(0xFFBC8F59),
                                  //       fontSize: 16,
                                  //       fontFamily: 'EB Garamond',
                                  //       fontWeight: FontWeight.w400,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Column(
                                  //   spacing: 15,
                                  //   children: [
                                  // _titleSection('Quick Actions'),
                                  //     CustomGrid(
                                  //       children: [
                                  //         _gridChild(
                                  //           body:
                                  //               'Start here to unlock AI features',
                                  //           btnText: 'Upload now',
                                  //           image: Images.scroll,
                                  //           title: 'Upload Syllabus',
                                  //         ),
                                  //         _gridChild(
                                  //           body:
                                  //               'Begin taking notes right away',
                                  //           btnText: 'Create note',
                                  //           image: Images.leaf2,
                                  //           title: 'Create Note',
                                  //           route:
                                  //               Routes.boardMinimalistNotePage,
                                  //         ),
                                  //         _gridChild(
                                  //           body: 'Add your course materials',
                                  //           btnText: 'Import now',
                                  //           image: Images.folder,
                                  //           title: 'Import Files',
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                  // _sectionCard(
                                  //   header: 'Upcoming Assignments',
                                  //   color: AppTheme.almondCream,
                                  //   img: Images.menu,
                                  //   title:
                                  //       'Assignment tracking will appear after syllabus upload',
                                  //   body:
                                  //       'We\'ll automatically identify and track all your assignments, quizzes, and exams',
                                  //   button: AppButton.secondary(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     onTap: () {},
                                  //     color: AppTheme.lightBrown,
                                  //     minHeight: 35,
                                  //     padding: EdgeInsets.symmetric(
                                  //       vertical: 3,
                                  //       horizontal: 15,
                                  //     ),
                                  //     text:
                                  //         'Upload syllabus to see assignments',
                                  //     style: TextStyle(
                                  //       color: const Color(0xFFBC8F59),
                                  //       fontSize: 16,
                                  //       fontFamily: 'EB Garamond',
                                  //       fontWeight: FontWeight.w400,
                                  //     ),
                                  //   ),
                                  // ),
                                  _sectionCard(
                                    header: 'Course Materials', 
                                    img: Images.uploadFile, //TODO resume here
                                    title:
                                        'Upload and organize your study materials',
                                    body: 'Drag and drop files here',
                                    button: AppButton.text(
                                      onTap: () {},
                                      text: 'Browse files',
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.strongBlue,
                                        fontSize: 16.0,
                                        fontWeight: getFontWeight(300),
                                      ),
                                    ),
                                  ),
                                  _courseInformation(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _titleSection(String title) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.royalGold.withAlpha(0x4C)),
        ),
      ),
      padding: EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF2F2F2F),
          fontSize: 24,
          fontFamily: 'Playfair Display',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _courseItem({required String title, required List<Widget> children}) {
    return CustomCard(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 30),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.text.copyWith(
              color: AppTheme.graniteGray,
              fontSize: 24.0,
              fontWeight: getFontWeight(200),
              height: 1.33,
              letterSpacing: 0.60,
            ),
          ),
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _keyVal({required String title, required String value}) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.graniteGray,
            fontSize: 18.0,
            fontWeight: getFontWeight(300),
            height: 1.56,
          ),
        ),
        Text(
          value,
          style: AppTheme.text.copyWith(
            color: const Color(0xFFA0A0A0),
            fontSize: 16.0,
            fontWeight: getFontWeight(300),
            height: 1.50,
          ),
        ),
      ],
    );
  }

  Widget _courseInformation() {
    return CustomGrid(
      largeDesktop: 2,
      children: [
        _courseItem(
          title: 'Course Details',
          children: [
            _keyVal(
              title: 'Professor:',
              value: '[Will be extracted from syllabus]',
            ),
            _keyVal(title: 'Email:', value: '[Contact info will appear here]'),
            _keyVal(
              title: 'Office Hours:',
              value: '[Schedule will be populated]',
            ),
            _keyVal(
              title: 'Office Location:',
              value: '[Location will be extracted]',
            ),
          ],
        ),
        _courseItem(
          title: 'Class Information',
          children: [
            _keyVal(title: 'Schedule:', value: '[Class times from syllabus]'),
            _keyVal(title: 'Location:', value: '[Classroom info will appear]'),
            _keyVal(
              title: 'Duration:',
              value: '[Semester dates will populate]',
            ),
            _keyVal(
              title: 'Credits:',
              value: '[Credit hours will be extracted]',
            ),
          ],
        ),
      ],
    );
  }

  Widget _gridChild({
    required String title,
    required String body,
    required String btnText,
    required String image,
    String? route, //TODO make required
  }) {
    return InkWell(
      onTap: () {
        if (isNotNull(route)) {
          NavigationHelper.push(route!);
        }
      },
      child: CustomCard(
        addCardShadow: true,
        decoration: BoxDecoration(
          color: AppTheme.ivoryCream,
          border: Border.all(color: AppTheme.royalGold.withAlpha(0x66)),
        ),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SVGImagePlaceHolder(
              imagePath: image,
              size: 30,
              color: AppTheme.yellowishOrange.withAlpha(0xFF),
            ),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF2F2F2F),
                fontSize: 20,
                fontFamily: 'EB Garamond',
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              body,
              style: TextStyle(
                color: const Color(0xFF654321),
                fontSize: 16,
                fontFamily: 'EB Garamond',
                fontWeight: FontWeight.w400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppButton.text(
                onTap: () {},
                text: '$btnText →',
                style: TextStyle(
                  color: const Color(0xFFE6B800),
                  fontSize: 16,
                  fontFamily: 'EB Garamond',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required String header,
    required String body,
    required Widget button,
    Color? color,
    required String img,
  }) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleSection(header),
        CustomCard(
          addCardShadow: true,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: AppTheme.royalGold.withAlpha(0x66)),
          ),
          child: Column(
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SVGImagePlaceHolder(
                  imagePath: img,
                  size: 34,
                  color: AppTheme.burntLeather.withAlpha(0xFF),
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF2F2F2F),
                  fontSize: 20,
                  fontFamily: 'EB Garamond',
                  fontWeight: FontWeight.w400,
                  height: 1.40,
                ),
              ),
              Text(
                body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF654321),
                  fontSize: 16,
                  fontFamily: 'EB Garamond',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: button,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _welcomeText() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        TextAlign textAlign = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: TextAlign.center,
          desktop: TextAlign.start,
        );
        return Column(
          spacing: 30,
          crossAxisAlignment: getDeviceResponsiveValue(
            deviceType: layoutVm.deviceType,
            mobile: CrossAxisAlignment.center,
            desktop: CrossAxisAlignment.start,
          ),
          children: [
            Text(
              'Welcome to your Biology 101 workspace',
              textAlign: textAlign,
              style: TextStyle(
                color: const Color(0xFF2F2F2F),
                fontSize: getDeviceResponsiveValue(
                  deviceType: layoutVm.deviceType,
                  mobile: 25.0,
                  laptop: 30.0,
                  desktop: 35.0,
                  largeDesktop: 48,
                ),
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w400,
                height: 1,
              ),
            ),
            Text(
              'Upload your syllabus to unlock AI-powered course insights',
              textAlign: textAlign,
              style: TextStyle(
                color: const Color(0xFF654321),
                fontSize: 18,
                fontFamily: 'EB Garamond',
                fontWeight: FontWeight.w400,
                height: 1.56,
              ),
            ),
            AppButton(
              mainAxisSize: MainAxisSize.min,
              color: AppTheme.lightBrown,
              onTap: () {},
              text: 'Get Started',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'EB Garamond',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _welcomeImage() {
    return WidthLimiter(
      mobile: 600,
      child: ImagePlaceHolder(
        imagePath: Images.boardLightAcadScience,
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  Widget _welcome() {
    return ResponsiveSection(
      mobile: Column(spacing: 50, children: [_welcomeText(), _welcomeImage()]),
      desktop: Row(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: _welcomeText()), _welcomeImage()],
      ),
    );
  }

  Widget _selectRows() {
    return TextRowSelect(
      fillWidth: false,
      items: ['Overview', 'Uploads', 'Assignments'],
      selected: 'Overview',
      borderColor: AppTheme.yellowishOrange.withAlpha(0xFF),
      padding: EdgeInsets.symmetric(vertical: 10),
      btnStyle: TextButton.styleFrom(
        shape: RoundedRectangleBorder(),
        backgroundColor: AppTheme.yellowishOrange.withAlpha(0x19),
      ),
      selectedTextStyle: AppTheme.text.copyWith(
        color: const Color(0xFF8B4513),
        fontSize: 16,
        fontFamily: 'EB Garamond',
        fontWeight: FontWeight.w400,
      ),
      style: TextStyle(
        color: const Color(0xFF654321),
        fontSize: 16,
        fontFamily: 'EB Garamond',
        fontWeight: FontWeight.w400,
        height: 1.50,
      ),
    );
  }

  Widget _header() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppTheme.royalGold.withAlpha(0x4C)),
            ),
            color: AppTheme.ivoryCream,
            boxShadow: [
              BoxShadow(
                color: AppTheme.black.withAlpha(0x19),
                blurRadius: 6,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: AppTheme.black.withAlpha(0x19),
                blurRadius: 4,
                offset: Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: WidthLimiter(
                  mobile: largeDesktopSize,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            MenuButton(
                              onPressed: () {},
                              decoration: BoxDecoration(
                                color: AppTheme.sepiaBrown,
                              ),
                            ),
                            AppButton.text(
                              wrapWithFlexible: true,
                              mainAxisSize: MainAxisSize.min,
                              prefix: Icon(
                                Icons.arrow_back,
                                color: AppTheme.sepiaBrown,
                                size: 18,
                              ),
                              onTap: NavigationHelper.pop,
                              text: 'BIOLOGY 101 - Fall Semester',
                              style: TextStyle(
                                color: const Color(0xFF2F2F2F),
                                fontSize: 20,
                                fontFamily: 'EB Garamond',
                                fontWeight: FontWeight.w400,
                                height: 1.40,
                              ),
                            ),
                          ],
                        ),
                      ),

                      VisibleController(
                        mobile: false,
                        desktop: true,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: _selectRows(),
                        ),
                      ),

                      VisibleController(
                        mobile: false,
                        tablet: true,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            spacing: 10,
                            children: [
                              AppButton(
                                mainAxisSize: MainAxisSize.min,
                                color: AppTheme.lightBrown,
                                text: 'Upload Syllabus',
                                onTap: () {},
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'EB Garamond',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.search,
                                color: AppTheme.sepiaBrown,
                                size: 24,
                              ),
                              Icon(
                                Icons.notifications,
                                color: AppTheme.sepiaBrown,
                                size: 24,
                              ),
                              ProfilePic(
                                borderColor: AppTheme.royalGold.withAlpha(0x7F),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
