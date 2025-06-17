import 'vm.dart';
import 'package:navinotes/packages.dart';

//TODO work on textstyle to use apptheme

class BoardNatureEditScreen extends StatelessWidget {
  const BoardNatureEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardNatureEditVm(),
      child: Consumer<BoardNatureEditVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: Apptheme.softLinen,
            body: Column(
              children: [
                _header(),
                _selectRows(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, 0.50),
                        end: Alignment(1.00, 0.50),
                        colors: [
                          const Color(0x4CB5C4A0),
                          const Color(0xFFF8F6F0),
                        ],
                      ),
                    ),
                    child: ScrollableController(
                      mobilePadding: EdgeInsets.only(top: tabletPadding),
                      tabletPadding: EdgeInsets.only(top: tabletPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: WidthLimiter(
                              mobile: largeDesktopSize,
                              child: Column(
                                spacing: 50,
                                children: [
                                  ResponsivePadding(
                                    mobile: EdgeInsets.symmetric(
                                      horizontal: tabletPadding,
                                    ),
                                    tablet: EdgeInsets.symmetric(
                                      horizontal: tabletPadding,
                                    ),
                                    child: Column(
                                      spacing: 30,
                                      children: [
                                        _welcome(),
                                        _customCardSection(
                                          header: _aiSection(
                                            title: 'Course Timeline',
                                          ),
                                          title:
                                              'Your learning journey will bloom here',
                                          body:
                                              'After uploading your syllabus, we\'ll automatically generate a timeline of important dates, assignments, and events for your semester',
                                          button: AppButton.text(
                                            onTap: () {},
                                            prefix: SVGImagePlaceHolder(
                                              imagePath: Images.upload,
                                              size: 16,
                                              color: Apptheme.sageMist,
                                            ),
                                            text:
                                                'Upload syllabus to generate timeline',
                                            style: TextStyle(
                                              color: const Color(0xFF9CAF88),
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        CustomGrid(
                                          children: [
                                            _gridChild(
                                              body:
                                                  'Start here to unlock AI features and organize your course automatically',
                                              btnText: 'Upload now',
                                              color: Apptheme.sageMist,
                                              image: Images.uploadFile,
                                              title: 'Upload Syllabus',
                                            ),
                                            _gridChild(
                                              body:
                                                  'Begin taking notes right away with our nature-inspired note templates',
                                              btnText: 'Create note',
                                              color: Apptheme.walnutBronze,
                                              image: Images.edit,
                                              title: 'Create Note',
                                            ),
                                            _gridChild(
                                              body:
                                                  'Add your course materials, readings, and research documents',
                                              btnText: 'Import now',
                                              color: Apptheme.mossGreen,
                                              image: Images.folder,
                                              title: 'Import Files',
                                            ),
                                          ],
                                        ),

                                        _customCardSection(
                                          header: _aiSection(
                                            title: 'Upcoming Assignments',
                                            img: Images.menu2,
                                          ),
                                          img: Images.checkRect,
                                          title: 'Track your academic growth',
                                          body:
                                              'We\'ll automatically identify and track all your assignments, quizzes, and exams after you upload your syllabus',
                                          button: AppButton.text(
                                            onTap: () {},
                                            prefix: SVGImagePlaceHolder(
                                              imagePath: Images.upload,
                                              size: 16,
                                              color: Apptheme.sageMist,
                                            ),
                                            text:
                                                'Upload syllabus to see assignments',
                                            style: TextStyle(
                                              color: const Color(0xFF9CAF88),
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        _customCardSection(
                                          header: _aiSection(
                                            title: 'Course Materials',
                                            img: Images.book,
                                            isAi: false,
                                          ),
                                          color: Apptheme.white.withAlpha(128),
                                          img: Images.upload2,
                                          title:
                                              'Cultivate your resource library',
                                          body:
                                              'Drag and drop files here to upload and organize your study materials',
                                          button: AppButton.secondary(
                                            mainAxisSize: MainAxisSize.min,
                                            color: Apptheme.sageMist,
                                            onTap: () {},
                                            minHeight: 35,
                                            prefix: SVGImagePlaceHolder(
                                              imagePath: Images.folder,
                                              size: 16,
                                              color: Apptheme.sageMist,
                                            ),
                                            text: 'Browse files',
                                          ),
                                        ),
                                        _courseInformation(),
                                        Column(
                                          spacing: 10,
                                          children: [
                                            Text(
                                              'Upload your syllabus to complete your academic ecosystem',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: const Color(0xFF1F2937),
                                                fontSize: 20,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                height: 1.40,
                                              ),
                                            ),
                                            AppButton(
                                              mainAxisSize: MainAxisSize.min,
                                              color: Apptheme.sageMist,
                                              onTap: () {},
                                              text: 'Upload Syllabus',
                                              prefix: SVGImagePlaceHolder(
                                                imagePath: Images.upload,
                                                size: 16,
                                                color: Apptheme.white,
                                              ),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Nurture your learning journey with organized, AI-powered insights',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: const Color(0xFF6B7280),
                                                fontSize: 16,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 1.50,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  _footer(),
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

  Widget _footer() {
    return Container(
      color: const Color(0x339CAF88),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      child: Text(
        '© 2023 Environmental Science 2401 - Fall Semester',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF4B5563),
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ),
    );
  }

  Widget _aiPowered({bool isExtracted = false}) {
    Color color = isExtracted ? Apptheme.walnutBronze : Apptheme.sageMist;
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(0x33),
        borderRadius: BorderRadius.circular(9999),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          SVGImagePlaceHolder(imagePath: Images.robot, size: 16, color: color),
          Text(
            isExtracted ? 'AI-Extracted' : 'AI-Powered',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _courseItemHeader({required String title, String? img}) {
    return Row(
      spacing: 10,
      children: [
        if (isNotNull(img))
          SVGImagePlaceHolder(imagePath: img!, size: 20)
        else
          Icon(Icons.calendar_month, size: 20, color: Apptheme.walnutBronze),
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF1F2937),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.56,
          ),
        ),
        _aiPowered(isExtracted: true),
      ],
    );
  }

  Widget _courseItem({required Widget header, required List<Widget> children}) {
    return CustomCard(
      child: Column(
        spacing: 15,
        children: [header, Column(spacing: 10, children: children)],
      ),
    );
  }

  Widget _keyVal({required String title, required String value}) {
    return Row(
      spacing: 5,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 130),
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        //
      ],
    );
  }

  Widget _courseInformation() {
    return CustomCard(
      decoration: BoxDecoration(color: Apptheme.walnutBronze.withAlpha(0x19)),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            'Course Information',
            style: TextStyle(
              color: const Color(0xFF1F2937),
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          CustomGrid(
            largeDesktop: 2,
            children: [
              _courseItem(
                header: _courseItemHeader(
                  title: 'Course Details',
                  img: Images.pers,
                ),
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
                header: _courseItemHeader(title: 'Class Information'),
                children: [
                  _keyVal(
                    title: 'Schedule:',
                    value: '[Class times from syllabus]',
                  ),
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
        ],
      ),
    );
  }

  Widget _aiSection({required String title, String? img, bool isAi = true}) {
    return Row(
      spacing: 10,
      children: [
        if (isNotNull(img))
          SVGImagePlaceHolder(
            imagePath: img!,
            size: 20,
            color: Apptheme.sageMist,
          )
        else
          Icon(Icons.calendar_month, color: Apptheme.sageMist),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFF1F2937),
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.40,
            ),
          ),
        ),
        if (isAi) _aiPowered(),
      ],
    );
  }

  Widget _gridChild({
    required String title,
    required String body,
    required String btnText,
    required String image,
    required Color color,
  }) {
    return CustomCard(
      decoration: BoxDecoration(color: color),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OutlinedChild(
            size: 48,
            decoration: BoxDecoration(
              color: Apptheme.white.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: SVGImagePlaceHolder(
              imagePath: image,
              size: 20,
              color: Apptheme.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            body,
            style: TextStyle(
              color: Apptheme.white.withAlpha(229),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          AppButton.text(
            mainAxisSize: MainAxisSize.min,
            onTap: () {},
            text: btnText,
            suffix: Icon(Icons.arrow_forward, color: Apptheme.white),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customCardSection({
    required Widget header,
    required String title,
    required String body,
    required Widget button,
    Color? color,
    String? img,
  }) {
    return CustomCard(
      addShadow: !isNotNull(color),
      decoration: BoxDecoration(
        color: color,
        border:
            isNotNull(color)
                ? Border.all(color: Apptheme.sageMist.withAlpha(0x66))
                : null,
      ),
      child: Column(
        spacing: 30,
        children: [
          header,
          Column(
            spacing: 10,
            children: [
              OutlinedChild(
                size: 64,
                decoration: BoxDecoration(
                  color: Apptheme.sageMist.withAlpha(0x19),
                  shape: BoxShape.circle,
                ),
                child:
                    isNotNull(img)
                        ? SVGImagePlaceHolder(
                          imagePath: img!,
                          size: 24,
                          color: Apptheme.sageMist,
                        )
                        : Icon(
                          Icons.access_time,
                          color: Apptheme.sageMist,
                          size: 30,
                        ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.56,
                ),
              ),
              WidthLimiter(
                mobile: 500,
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF4B5563),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: button,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _welcome() {
    return CustomCard(
      addShadow: true,
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to your Environmental Science sanctuary',
            style: TextStyle(
              color: const Color(0xFF1F2937),
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          Text(
            'Upload your syllabus to unlock AI-powered course insights and organization tools tailored for your environmental studies',
            style: TextStyle(
              color: const Color(0xFF4B5563),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),

          AppButton(
            mainAxisSize: MainAxisSize.min,
            color: Apptheme.sageMist,
            onTap: () {},
            text: 'Upload Syllabus',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
          color: Apptheme.white,
          child: Padding(
            padding: EdgeInsets.only(top: 10, right: padding, left: padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: WidthLimiter(
                    mobile: largeDesktopSize,
                    child: TextRowSelect(
                      items: [
                        'Overview',
                        'Uploads',
                        'Assignments',
                        'Resources',
                      ],
                      selected: 'Overview',
                      selectedTextColor: Apptheme.sageMist,
                      borderColor: Apptheme.sageMist,
                      textColor: Apptheme.steelMist,
                      padding: EdgeInsets.symmetric(vertical: 10),
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
            gradient: LinearGradient(
              begin: Alignment(0.00, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [Apptheme.sageMist, Apptheme.dustyOlive],
            ),
          ),
          child: ResponsivePadding(
            mobile: EdgeInsets.all(mobilePadding),
            tablet: EdgeInsets.all(tabletPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: WidthLimiter(
                    mobile: largeDesktopSize,
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ENVIRONMENTAL SCIENCE 2401',
                                style: TextStyle(
                                  color: Colors.white,
                                  // fontSize: 30,
                                  fontSize: getDeviceResponsiveValue(
                                    deviceType: layoutVm.deviceType,
                                    mobile: 18.0,
                                    tablet: 22.0,
                                    laptop: 24.0,
                                    desktop: 30.0,
                                  ),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.20,
                                ),
                              ),
                              Text(
                                'Fall Semester',
                                style: TextStyle(
                                  color: Apptheme.white.withAlpha(204),
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ),

                        AppButton(
                          mainAxisSize: MainAxisSize.min,
                          color: Apptheme.white,
                          text: 'Upload Syllabus',
                          prefix: SVGImagePlaceHolder(
                            imagePath: Images.upload,
                            color: Apptheme.sageMist,
                            size: 16,
                          ),
                          onTap: () {},
                          style: TextStyle(
                            color: Apptheme.sageMist,
                            fontSize: 16,
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
