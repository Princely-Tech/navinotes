import 'vm.dart';
import 'package:navinotes/packages.dart';

class BoardMinimalistEditScreen extends StatelessWidget {
  const BoardMinimalistEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardMinimalistEditVm(),
      child: Consumer<BoardMinimalistEditVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: AppTheme.white,
            body: Column(
              children: [
                _header(),
                _selectRows(),
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
                            child: WidthLimiter(
                              mobile: largeDesktopSize,
                              child: Column(
                                spacing: 30,
                                children: [
                                  _welcome(),
                                  _sectionCard(
                                    header: 'Course Timeline',
                                    color: AppTheme.snowGray,
                                    title:
                                        'Your learning journey will bloom here',
                                    body:
                                        'After uploading your syllabus, we\'ll automatically generate a timeline of important dates, assignments, and events for your semester',
                                    button: AppButton.secondary(
                                      mainAxisSize: MainAxisSize.min,
                                      onTap: () {},
                                      color: AppTheme.strongBlue,
                                      text:
                                          'Upload syllabus to generate timeline',
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.strongBlue,
                                        fontSize: 16.0,
                                        fontWeight: getFontWeight(300),
                                      ),
                                    ),
                                  ),

                                  CustomGrid(
                                    children: [
                                      _gridChild(
                                        body:
                                            'Start here to unlock AI features',
                                        btnText: 'Upload now',
                                        image: Images.ques2,
                                        title: 'Upload Syllabus',
                                      ),
                                      _gridChild(
                                        body: 'Begin taking notes right away',
                                        btnText: 'Create note',
                                        image: Images.edit,
                                        title: 'Create Note',
                                        route: Routes.boardMinimalistNotePage,
                                      ),
                                      _gridChild(
                                        body: 'Add your course materials',
                                        btnText: 'Import now',
                                        image: Images.folder,
                                        title: 'Import Files',
                                      ),
                                    ],
                                  ),
                                  _sectionCard(
                                    header: 'Upcoming Assignments',
                                    color: AppTheme.snowGray,
                                    img: Images.menu3,
                                    title:
                                        'Assignment tracking will appear after syllabus upload',
                                    body:
                                        'We\'ll automatically identify and track all your assignments, quizzes, and exams',
                                    button: AppButton.secondary(
                                      mainAxisSize: MainAxisSize.min,
                                      onTap: () {},
                                      color: AppTheme.strongBlue,
                                      text:
                                          'Upload syllabus to see assignments',
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.strongBlue,
                                        fontSize: 16.0,
                                        fontWeight: getFontWeight(300),
                                      ),
                                    ),
                                  ),
                                  _sectionCard(
                                    header: 'Course Materials',
                                    img: Images.ques2,
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
        addBorder: true,
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: 0.5,
              child: SVGImagePlaceHolder(
                imagePath: image,
                size: 24,
                color: AppTheme.graniteGray,
              ),
            ),
            Text(
              title,
              style: AppTheme.text.copyWith(
                color: AppTheme.graniteGray,
                fontSize: 20.0,
                fontWeight: getFontWeight(300),
                height: 1.40,
              ),
            ),
            Text(
              body,
              style: AppTheme.text.copyWith(
                color: AppTheme.midGray,
                fontSize: 16.0,
                fontWeight: getFontWeight(300),
                height: 1.62,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppButton.text(
                onTap: () {},
                text: btnText,
                suffix: Icon(Icons.arrow_forward, color: AppTheme.strongBlue),
                style: AppTheme.text.copyWith(
                  color: AppTheme.strongBlue,
                  fontSize: 16.0,
                  fontWeight: getFontWeight(300),
                  height: 1.50,
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
    String? img,
  }) {
    return Column(
      spacing: 25,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: AppTheme.text.copyWith(
            color: AppTheme.graniteGray,
            fontSize: 24.0,
            fontWeight: getFontWeight(200),
            height: 1.33,
            letterSpacing: 0.60,
          ),
        ),
        CustomCard(
          addBorder: !isNotNull(color),
          decoration: BoxDecoration(color: color),
          child: Column(
            spacing: 10,
            children: [
              isNotNull(img)
                  ? SVGImagePlaceHolder(
                    imagePath: img!,
                    size: 24,
                    color: AppTheme.midGray,
                  )
                  : Icon(Icons.access_time, color: AppTheme.midGray, size: 30),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.text.copyWith(
                  color: AppTheme.graniteGray,
                  fontSize: 20.0,
                  fontWeight: getFontWeight(300),
                ),
              ),
              WidthLimiter(
                mobile: 500,
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                  style: AppTheme.text.copyWith(
                    color: AppTheme.midGray,
                    fontSize: 16.0,
                    fontWeight: getFontWeight(300),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: button,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _welcome() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Column(
          spacing: 15,
          children: [
            Text(
              'Welcome to your Biology 101 workspace',
              style: AppTheme.text.copyWith(
                color: AppTheme.graniteGray,
                fontWeight: getFontWeight(200),
                height: 1.20,
                letterSpacing: 0.75,
                fontSize: getDeviceResponsiveValue(
                  deviceType: layoutVm.deviceType,
                  mobile: 24.0,
                  tablet: 28.0,
                  laptop: 30.0,
                ),
              ),
            ),
            Text(
              'Upload your syllabus to unlock AI-powered course insights',
              textAlign: TextAlign.center,
              style: AppTheme.text.copyWith(
                color: AppTheme.midGray,
                fontSize: 18.0,
                fontWeight: getFontWeight(300),
                height: 1.67,
              ),
            ),

            AppButton(
              mainAxisSize: MainAxisSize.min,
              color: AppTheme.strongBlue,
              onTap: () {},
              text: 'Upload Syllabus',
              style: AppTheme.text.copyWith(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: getFontWeight(300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: WidthLimiter(
                mobile: 192,
                child: ImagePlaceHolder(
                  imagePath: Images.boardMinimalistScience,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _selectRows() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        double padding = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: mobilePadding,
          tablet: tabletPadding,
        );
        return Container(
          color: AppTheme.white,
          child: Padding(
            padding: EdgeInsets.only(top: 10, right: padding, left: padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: WidthLimiter(
                    mobile: largeDesktopSize,
                    child: TextRowSelect(
                      items: ['Overview', 'Uploads', 'Assignments'],
                      selected: 'Overview',
                      borderColor: AppTheme.strongBlue,
                      inActiveBorderColor: AppTheme.lightGray,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      selectedTextStyle: AppTheme.text.copyWith(
                        color: AppTheme.strongBlue,
                        fontSize: 16.0,
                        fontWeight: getFontWeight(300),
                      ),
                      style: AppTheme.text.copyWith(
                        color: AppTheme.midGray,
                        fontSize: 16.0,
                        fontWeight: getFontWeight(300),
                        height: 1.50,
                      ),
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

  Widget _header() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.offWhite)),
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
                      Expanded(
                        child: Row(
                          spacing: 10,
                          children: [
                            MenuButton(
                              onPressed: () {},
                              decoration: BoxDecoration(
                                color: AppTheme.graniteGray,
                              ),
                            ),
                            AppButton.text(
                              wrapWithFlexible: true,
                              mainAxisSize: MainAxisSize.min,
                              prefix: Icon(
                                Icons.arrow_back,
                                color: AppTheme.graniteGray,
                                size: 18,
                              ),
                              onTap: NavigationHelper.pop,
                              text: 'BIOLOGY 101 - Fall Semester',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.graniteGray,
                                fontWeight: getFontWeight(300),
                                height: 1.43,
                                letterSpacing: 0.70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      VisibleController(
                        mobile: false,
                        tablet: true,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: AppButton.secondary(
                            mainAxisSize: MainAxisSize.min,
                            color: AppTheme.strongBlue,
                            text: 'Upload Syllabus',
                            onTap: () {},
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
