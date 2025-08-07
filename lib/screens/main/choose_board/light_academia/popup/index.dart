import 'package:navinotes/packages.dart';

class BoardLightAcadPopupScreen extends StatelessWidget {
  const BoardLightAcadPopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      backgroundColor: const Color(0xFFF5F2E8),
      body: Consumer<LayoutProviderVm>(
        builder: (_, layoutVm, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              Expanded(
                child: ScrollableController(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        _widthLimiter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 48,
                            children: [
                              _courseTitleSection(),
                              _courseActions(),
                              _fileUploads(),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Images.boardLightAcadPopupImg),
                              fit: getDeviceResponsiveValue(
                                deviceType: layoutVm.deviceType,
                                mobile: BoxFit.cover,
                                largeDesktop: BoxFit.fill,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(top: 25, bottom: 40),
                          child: _widthLimiter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 25,
                              children: [_studyTemplates(), _courseTimeline()],
                            ),
                          ),
                        ),
                        _footer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _footerItem({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(
          'Course Details',
          style: TextStyle(
            color: const Color(0xFFFFB347),
            fontSize: 20,
            fontFamily: 'EB Garamond',
            fontWeight: FontWeight.w400,
            height: 1.40,
          ),
        ),

        child,
      ],
    );
  }

  Widget _courseDetails() {
    return _footerItem(
      title: 'Course Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Instructor:', 'Dr. Eleanor Blackwood'),
          _buildDetailItem('Email:', 'e.blackwood@academia.edu'),
          _buildDetailItem('Office Hours:', 'Mon/Wed 2:00-4:00 PM'),
          _buildDetailItem('Phone:', '(555) 123-4567'),
        ],
      ),
    );
  }

  Widget _classInfo() {
    return _footerItem(
      title: 'Class Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Schedule:', 'Tue/Thu 10:30 AM - 12:00 PM'),
          _buildDetailItem('Location:', 'Science Hall, Room 305'),
          _buildDetailItem('Semester:', 'Fall 2025'),
          SizedBox(height: 16),
          Text(
            'Quick Links',
            style: TextStyle(
              color: const Color(0xFFFFB347),
              fontSize: 16,
              fontFamily: 'EB Garamond',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 16,
            children:
                ['Syllabus', 'Academic Calendar', 'Library Resources']
                    .map(
                      (str) => Text(
                        str,
                        style: TextStyle(
                          color: const Color(0xFFFAF7F0),
                          fontSize: 16,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
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

  Widget _footer() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          decoration: BoxDecoration(color: const Color(0xFF654321)),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Opacity(
                  opacity: getDeviceResponsiveValue(
                    deviceType: layoutVm.deviceType,
                    mobile: 0.5,
                    desktop: 1,
                  ),
                  child: ImagePlaceHolder(
                    imagePath: Images.boardLightAcadPopupFooterBg,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              VisibleController(
                mobile: false,
                desktop: true,
                child: Positioned(
                  right: getDeviceResponsiveValue(
                    deviceType: layoutVm.deviceType,
                    mobile: 250,
                    largeDesktop: 350,
                  ),
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ImagePlaceHolder(
                          imagePath: Images.boardLightAcadFooterImg,
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ResponsivePadding(
                mobile: EdgeInsets.symmetric(vertical: 40),
                desktop: EdgeInsets.only(top: 80, bottom: 40),
                largeDesktop: EdgeInsets.only(top: 100, bottom: 40),
                child: _widthLimiter(
                  child: CustomGrid(
                    largeDesktop: 2,
                    children: [_courseDetails(), _classInfo()],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _courseTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xC99A8634),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0x4C8B4513)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                'Course Timeline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'EB Garamond',
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                ),
              ),
              Text(
                'Weekly course progression and assignments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        // Timeline Items
        _buildTimelineItem(
          week: 'Week 1-2: Cell Structure & Function',
          assignment: 'Cell Structure Lab Report',
          status: 'In Progress',
          progress: 0.65,
          tags: ['Cell Membrane', 'Cytoplasm', 'Organelles', 'Microscopy'],
        ),
        SizedBox(height: 24),
        _buildTimelineItem(
          week: 'Week 3-4: Genetics & DNA',
          assignment: 'Genetic Inheritance Quiz',
          status: 'Due Oct 15',
          tags: ['DNA Structure', 'Inheritance', 'Genes', 'Mutations'],
        ),
        SizedBox(height: 24),
        _buildTimelineItem(
          week: 'Week 5-6: Evolution & Natural Selection',
          assignment: 'Evolution Case Study',
          status: 'Not Started',
          tags: [
            'Natural Selection',
            'Adaptation',
            'Speciation',
            'Fossil Record',
          ],
        ),
      ],
    );
  }

  Widget _studyTemplates() {
    return _section(
      title: 'Study Templates',
      subTitle: 'Pre-designed formats for effective studying',
      isWhite: true,
      child: CustomGrid(
        spacing: 24,
        children: [
          _buildTemplateCard(
            icon: Images.flask,
            title: 'Lab Report',
            description:
                'Structured template for documenting laboratory experiments and findings.',
            usedBy: '127 students',
          ),

          _buildTemplateCard(
            icon: Images.chart3,
            title: 'Research Analysis',
            description:
                'Framework for analyzing scientific papers and research findings.',
            usedBy: '89 students',
          ),

          _buildTemplateCard(
            icon: Images.file,
            title: 'Scientific Summary',
            description:
                'Template for concise summaries of complex scientific concepts.',
            usedBy: '104 students',
          ),
        ],
      ),
    );
  }

  Widget _fileUploads() {
    return _section(
      title: 'File Uploads',
      subTitle: 'Recently uploaded study materials',
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 24,
          children: [
            _buildFileCard('Cell_Membrane_Notes.pdf', '2.4 MB', 'Oct 8, 2023'),
            _buildFileCard(
              'DNA_Structure_Lecture.pptx',
              '5.7 MB',
              'Oct 5, 2023',
            ),
            _buildFileCard(
              'Cell_Microscopy_Images.zip',
              '18.2 MB',
              'Oct 2, 2023',
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required String subTitle,
    required Widget child,
    bool isWhite = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isWhite ? AppTheme.white : const Color(0xFF654321),
                fontSize: 24,
                fontFamily: 'EB Garamond',
                fontWeight: FontWeight.w400,
                height: 1.33,
              ),
            ),
            Text(
              subTitle,
              style: TextStyle(
                color: isWhite ? AppTheme.white : const Color(0xFF8B4513),
                fontSize: 16,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }

  Widget _courseActions() {
    return _section(
      title: 'Course Actions',
      subTitle: 'Create and manage your study materials',
      child: CustomGrid(
        spacing: 24,
        children: [
          _buildActionCard(
            icon: Images.pen2,
            title: 'Create Note',
            description:
                'Start a new study note with customizable templates and formatting options.',
            actionText: 'Create a new note',
          ),
          _buildActionCard(
            icon: Images.pdf,
            title: 'Import PDF',
            description:
                'Upload and annotate PDF documents from your course materials or research.',
            actionText: 'Import document',
          ),
          _buildActionCard(
            icon: Images.folder,
            title: 'Import Files',
            description:
                'Upload multiple files including images, documents, and presentations.',
            actionText: 'Upload files',
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore Cell Biology & Genetics',
              style: TextStyle(
                color: const Color(0xFF654321),
                fontSize: getDeviceResponsiveValue(
                  deviceType: layoutVm.deviceType,
                  mobile: 30,
                  tablet: 36,
                ),
                fontFamily: 'EB Garamond',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Dive into the fascinating world of cellular structures and genetic mechanisms. This course explores the fundamental building blocks of life, from microscopic cell components to the intricate dance of DNA replication and genetic inheritance patterns.',
              style: TextStyle(
                color: const Color(0xFF8B4513),
                fontSize: 16,
                fontFamily: 'Open Sans',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _nextSession() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x19FFB347),
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x4CFFB347)),
      ),
      padding: EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Session',
            style: TextStyle(
              color: const Color(0xFF654321),
              fontSize: 20,
              fontFamily: 'EB Garamond',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'DNA Replication Mechanisms',
            style: TextStyle(
              color: const Color(0xFF2F2F2F),
              fontSize: 16,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Dr. Eleanor Blackwood',
            style: TextStyle(
              color: const Color(0xFF2F2F2F),
              fontSize: 14,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Column(
            spacing: 8,
            children: [
              _nextSessionRow(
                icon: Images.calender,
                text: 'Tuesday, October 12th',
              ),
              _nextSessionRow(icon: Images.clock, text: '10:30 AM - 12:00 PM'),
              _nextSessionRow(
                icon: Images.location,
                text: 'Science Hall, Room 305',
              ),
            ],
          ),
          SizedBox(height: 24),
          AppButton(
            onTap: () {},
            text: 'Prepare Materials',
            color: const Color(0xFF8B4513),
            style: TextStyle(
              color: const Color(0xFFD4AF37),
              fontSize: 16,
              fontFamily: 'EB Garamond',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextSessionRow({required String text, required String icon}) {
    return Row(
      spacing: 8,
      children: [
        SVGImagePlaceHolder(
          imagePath: icon,
          size: 14,
          color: const Color(0xFF8B4513),
        ),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFF8B4513),
            fontSize: 14,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
      ],
    );
  }

  Widget _courseTitleSection() {
    return ResponsiveSection(
      mobile: Column(spacing: 30, children: [_title(), _nextSession()]),
      desktop: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          Expanded(child: _title()),
          WidthLimiter(mobile: 500, child: _nextSession()),
        ],
      ),
    );
  }

  Widget _widthLimiter({required Widget child}) {
    return ResponsiveHorizontalPadding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: WidthLimiter(mobile: largeDesktopSize, child: child)),
        ],
      ),
    );
  }

  Widget _textRowSelect() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        bool isBottom = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: true,
          laptop: false,
        );
        return TextRowSelect(
          items: EditBoardTab.values.map((item) => item.toString()).toList(),
          inActiveBorderColor:
              isBottom
                  ? const Color(0xFFD4AF37).withAlpha(100)
                  : AppTheme.transparent,
          selectedTextStyle: TextStyle(
            color: const Color(0xFFD4AF37),
            fontSize: 16,
            fontFamily: 'EB Garamond',
            fontWeight: FontWeight.w400,
          ),
          fillWidth: isBottom,
          borderColor: const Color(0xFFD4AF37),
          style: TextStyle(
            color: const Color(0xFF8B4513),
            fontSize: 16,
            fontFamily: 'EB Garamond',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        );
      },
    );
  }

  Widget _header() {
    return Column(
      children: [
        Container(
          decoration: ShapeDecoration(
            color: const Color(0xFFFAF7F0),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: const Color(0x4CFFB347)),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 2,
                offset: Offset(0, 1),
                spreadRadius: 0,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: _widthLimiter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MenuButton(
                        onPressed: () {},
                        decoration: BoxDecoration(
                          color: AppTheme.burntLeather.withAlpha(0XFF),
                        ),
                      ),
                      AppIconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppTheme.burntLeather.withAlpha(0XFF),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'BIOLOGY 101 - Fall Semester',
                          style: TextStyle(
                            color: const Color(0xFF654321),
                            fontSize: 16,
                            fontFamily: 'EB Garamond',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                VisibleController(
                  mobile: false,
                  laptop: true,
                  child: _textRowSelect(),
                ),

                Row(
                  children: [
                    AppIconButton(
                      onPressed: NavigationHelper.navigateToNotification,
                      icon: Badge(
                        backgroundColor: const Color(0xFFD4AF37),
                        textStyle: AppTheme.text.copyWith(
                          color: AppTheme.white,
                          fontSize: 8.0,
                        ),
                        label: Center(
                          child: Text('3', textAlign: TextAlign.center),
                        ),
                        child: Icon(
                          Icons.notifications,
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                    ),
                    AppIconButton(
                      onPressed: () {},
                      icon: SVGImagePlaceHolder(
                        imagePath: Images.ques,
                        size: 16,
                        color: const Color(0xFF8B4513),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: ProfilePic(borderColor: const Color(0xFFD4AF37)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        VisibleController(
          mobile: true,
          laptop: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _textRowSelect(),
          ),
        ),
      ],
    );
  }

  // Helper Widgets
  Widget _buildActionCard({
    required String icon,
    required String title,
    required String description,
    required String actionText,
  }) {
    return CustomCard(
      addShadow: true,
      padding: EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0x33A67C52),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x4C8B4513)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            spacing: 12,
            children: [
              OutlinedChild(
                size: 48,
                decoration: BoxDecoration(
                  color: const Color(0x338B4513),
                  shape: BoxShape.circle,
                ),
                child: SVGImagePlaceHolder(
                  imagePath: icon,
                  size: 20,
                  color: const Color(0xFFD4AF37),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF654321),
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Text(
            description,
            style: TextStyle(
              color: const Color(0xFF8B4513),
              fontSize: 16,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            spacing: 4,
            children: [
              Flexible(
                child: Text(
                  actionText,
                  style: TextStyle(
                    color: const Color(0xFF948247),
                    fontSize: 16,
                    fontFamily: 'EB Garamond',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: const Color(0xFF948247),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(String fileName, String size, String date) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 400),
      child: CustomCard(
        width: null,
        addShadow: true,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0x19A67C52),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(width: 4, color: const Color(0xFFD4AF37)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 16,
              children: [
                SVGImagePlaceHolder(
                  imagePath: Images.pdf,
                  size: 24,
                  width: 4,
                  color: const Color(0xFFD4AF37),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: TextStyle(
                        color: const Color(0xFF654321),
                        fontSize: 16,
                        fontFamily: 'EB Garamond',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      spacing: 16,
                      children:
                          [size, date]
                              .map(
                                (str) => Text(
                                  str,
                                  style: TextStyle(
                                    color: const Color(0xFF8B4513),
                                    fontSize: 12,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                    height: 1.33,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ],
            ),

            SVGImagePlaceHolder(
              imagePath: Images.upload4,
              color: const Color(0xFFD4AF37),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard({
    required String icon,
    required String title,
    required String description,
    required String usedBy,
  }) {
    return Container(
      padding: EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x338B4513)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            spacing: 12,
            children: [
              OutlinedChild(
                size: 40,
                decoration: BoxDecoration(
                  color: const Color(0x33FFB347),
                  shape: BoxShape.circle,
                ),
                child: SVGImagePlaceHolder(
                  imagePath: icon,
                  color: const Color(0xFFD4AF37),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF654321),
                  fontSize: 20,
                  fontFamily: 'EB Garamond',
                  fontWeight: FontWeight.w400,
                  height: 1.40,
                ),
              ),
            ],
          ),
          Text(
            description,
            style: TextStyle(
              color: const Color(0xFF8B4513),
              fontSize: 16,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            spacing: 8,
            children: [
              SVGImagePlaceHolder(
                imagePath: Images.people,
                size: 12,
                color: const Color(0xFF8B4513),
              ),
              Expanded(
                child: Text(
                  'Used by $usedBy',
                  style: TextStyle(
                    color: const Color(0xFF8B4513),
                    fontSize: 12,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
          AppButton(
            onTap: () {},
            color: const Color(0xFFF0EBE0),
            text: 'Use Template',
            borderColor: const Color(0x338B4513),
            minHeight: 40,
            style: TextStyle(
              color: const Color(0xFF654321),
              fontSize: 16,
              fontFamily: 'EB Garamond',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String week,
    required String assignment,
    required String status,
    double progress = 0,
    List<String> tags = const [],
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VisibleController(
            mobile: false,
            tablet: true,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Center(
                      child: Container(
                        width: 2,
                        color: const Color(0x99FFB347),
                      ),
                    ),
                  ),
                  OutlinedChild(
                    size: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      shape: BoxShape.circle,
                    ),
                    child: SVGImagePlaceHolder(
                      imagePath: Images.flask,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CustomCard(
              addCardShadow: true,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F0),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x338B4513)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text(
                    week,
                    style: TextStyle(
                      color: const Color(0xFF654321),
                      fontSize: 20,
                      fontFamily: 'EB Garamond',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0x7FF0EBE0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0x198B4513)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 15,
                          children: [
                            Expanded(
                              child: Text(
                                assignment,
                                style: TextStyle(
                                  color: const Color(0xFF654321),
                                  fontSize: 16,
                                  fontFamily: 'EB Garamond',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    status == 'In Progress'
                                        ? const Color(0x33FFB347)
                                        : status == 'Due Oct 15'
                                        ? const Color(0x33D4AF37)
                                        : const Color(0xFFF5F2E8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: const Color(0xFF8B4513),
                                  fontSize: 12,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (progress > 0) ...[
                          SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: const Color(0xFFF5F2E8),
                            color: const Color(0xFFD4AF37),
                          ),
                        ],

                        SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              tags
                                  .map(
                                    (tag) => Text(
                                      tag,
                                      style: TextStyle(
                                        color: const Color(0xFF8B4513),
                                        fontSize: 12,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                color: const Color(0xFFD4AF37),
                fontSize: 16,
                fontFamily: 'Open Sans',
              ),
            ),
            TextSpan(
              text: ' $value',
              style: TextStyle(
                color: const Color(0xFFFAF7F0),
                fontSize: 16,
                fontFamily: 'Open Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
