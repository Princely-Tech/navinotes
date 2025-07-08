import 'vm.dart';
import 'package:navinotes/packages.dart';

class BoardPlainEditScreen extends StatelessWidget {
  const BoardPlainEditScreen({super.key});
//TODO use apptheme to replace Teaxtstyles
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardPlainEditVm(),
      child: Consumer<BoardPlainEditVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: AppTheme.white,
            body: Column(
              children: [
                _header(),
                _selectRows(),
                Expanded(
                  child: ScrollableController(
                    mobilePadding: EdgeInsets.symmetric(vertical: 30),
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
                                    color: AppTheme.lightAsh,
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
                                      style: TextStyle(
                                        color: const Color(0xFF3B82F6),
                                        fontSize: 16.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  CustomGrid(
                                    children: [
                                      _gridChild(
                                        body:
                                            'Start here to unlock AI features',
                                        btnText: 'Upload now',
                                        image: Images.file2,
                                        title: 'Upload Syllabus',
                                        color: true,
                                      ),
                                      _gridChild(
                                        body: 'Begin taking notes right away',
                                        btnText: 'Create note',
                                        image: Images.edit,
                                        title: 'Create Note',
                                        route: Routes.boardPlainNotePage,
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
                                    color: AppTheme.lightAsh,
                                    img: Images.menu2,
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
                                        color: const Color(0xFF3B82F6),
                                        fontSize: 16.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  _sectionCard(
                                    color: AppTheme.whiteSmoke,
                                    header: 'Course Materials',
                                    img: Images.ques2,
                                    title:
                                        'Upload and organize your study materials',
                                    body: 'Drag and drop files here\nor',
                                    button: AppButton(
                                      mainAxisSize: MainAxisSize.min,
                                      color: AppTheme.white,
                                      borderColor: AppTheme.lightGray,
                                      onTap: () {},
                                      text: 'Browse files',
                                      style: TextStyle(
                                        color: const Color(0xFF1F2937),
                                        fontSize: 16.0,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
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
    return Column(
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
    );
  }

  Widget _keyVal({required String title, required String value}) {
    return Row(
      spacing: 10,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 16.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 16.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _courseInformation() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: EdgeInsets.only(top: 20),
      child: CustomGrid(
        largeDesktop: 2,
        children: [
          _courseItem(
            title: 'Course Details',
            children: [
              _keyVal(
                title: 'Professor:',
                value: '[Will be extracted from syllabus]',
              ),
              _keyVal(
                title: 'Email:',
                value: '[Contact info will appear here]',
              ),
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
              _keyVal(
                title: 'Location:',
                value: '[Classroom info will appear]',
              ),
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
      ),
    );
  }

  Widget _gridChild({
    required String title,
    required String body,
    required String btnText,
    required String image,
    bool color = false,
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
        decoration: BoxDecoration(
          color: color ? AppTheme.iceBlue : null,
          border: Border.all(
            color: color ? AppTheme.paleBlue : AppTheme.lightGray,
          ),
        ),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedChild(
              size: 48,
              decoration: BoxDecoration(
                color: color ? AppTheme.paleBlue : AppTheme.lightAsh,
                shape: BoxShape.circle,
              ),
              child: SVGImagePlaceHolder(
                imagePath: image,
                size: 20,
                color: color ? AppTheme.vividBlue : AppTheme.steelMist,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF1F2937),
                fontSize: 18.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              body,
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 16.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppButton.text(
                onTap: () {},
                text: btnText,
                suffix: Icon(Icons.arrow_forward, color: AppTheme.vividBlue),
                style: AppTheme.text.copyWith(
                  color: AppTheme.vividBlue,
                  fontSize: 16.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
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
            color: const Color(0xFF1F2937),
            fontSize: 20.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.40,
          ),
        ),
        CustomCard(
          addBorder: !isNotNull(color),
          decoration: BoxDecoration(color: color),
          child: Column(
            spacing: 10,
            children: [
              OutlinedChild(
                size: 64,
                decoration: BoxDecoration(
                  color: AppTheme.lightGray,
                  shape: BoxShape.circle,
                ),
                child:
                    isNotNull(img)
                        ? SVGImagePlaceHolder(
                          imagePath: img!,
                          size: 24,
                          color: AppTheme.midGray,
                        )
                        : Icon(
                          Icons.access_time,
                          color: AppTheme.midGray,
                          size: 30,
                        ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 16.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              WidthLimiter(
                mobile: 500,
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 16.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
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

  Widget _welcomeText() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        TextAlign textAlign = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: TextAlign.center,
          desktop: TextAlign.start,
        );
        return Column(
          spacing: 15,
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
                color: const Color(0xFF1F2937),
                fontSize: 24.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
            Text(
              'Upload your syllabus to unlock AI-powered course insights',
              textAlign: textAlign,
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 16.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppButton(
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
            ),
          ],
        );
      },
    );
  }

  Widget _welcomeImage() {
    return WidthLimiter(
      mobile: 389,
      child: ImagePlaceHolder(
        imagePath: Images.boardPlainScience,
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  Widget _welcome() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return CustomCard(
          decoration: BoxDecoration(
            color: AppTheme.almostWhite,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ResponsiveSection(
            mobile: Column(
              spacing: 30,
              children: [_welcomeText(), _welcomeImage()],
            ),
            desktop: Row(
              spacing: 30,
              children: [Expanded(child: _welcomeText()), _welcomeImage()],
            ),
          ),
        );
      },
    );
  }

  Widget _selectRows() {
    return TextRowSelect(
      items: ['Overview', 'Uploads', 'Assignments'],
      selected: 'Overview',
      borderColor: AppTheme.strongBlue,
      inActiveBorderColor: AppTheme.lightGray,
      padding: EdgeInsets.symmetric(vertical: 10),
      selectedTextStyle: AppTheme.text.copyWith(
        color: const Color(0xFF3B82F6),
        fontSize: 16.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
      style: TextStyle(
        color: const Color(0xFF6B7280),
        fontSize: 16.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  spacing: 10,
                  children: [
                    MenuButton(
                      onPressed: () {},
                      decoration: BoxDecoration(color: AppTheme.vividRose),
                    ),
                    AppButton.text(
                      wrapWithFlexible: true,
                      mainAxisSize: MainAxisSize.min,
                      prefix: Icon(
                        Icons.arrow_back,
                        color: AppTheme.steelMist,
                        size: 18,
                      ),
                      onTap: NavigationHelper.pop,
                      text: 'BIOLOGY 101 - Fall Semester',
                      style: TextStyle(
                        color: const Color(0xFF1F2937),
                        fontSize: 20.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.40,
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
                  child: AppButton(
                    mainAxisSize: MainAxisSize.min,
                    color: AppTheme.strongBlue,
                    text: 'Upload Syllabus',
                    onTap: () {},
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
