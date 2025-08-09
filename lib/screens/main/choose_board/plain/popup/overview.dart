import 'package:navinotes/packages.dart';

class BoardPlainPopupOverview extends StatelessWidget {
  const BoardPlainPopupOverview({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _headerSection(),
        _courseActions(),
        Divider(height: 1, color: AppTheme.lightGray),
        _fileUploads(),
        _studyTemplates(),
        _courseOutline(),
        Divider(height: 1, color: AppTheme.lightGray),
        _courseDetails(),
      ],
    );
  }

  Widget _courseDetails() {
    return _section(
      color: AppTheme.white,
      child: CustomGrid(
        wrapWithIntrinsicHeight: false,
        largeDesktop: 2,
        children: [
          Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Details',
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow('Course:', 'BIOLOGY 101'),
                  _detailRow('Instructor:', 'Dr. Sarah Chen'),
                  _detailRow(
                    'Email:',
                    'schen@university.edu',
                    color: const Color(0xFF3B82F6),
                  ),
                  _detailRow('Office:', 'Science Building, Room 310'),
                  _detailRow('Office Hours:', 'Tues 1-3pm, Thurs 2-4pm'),
                  _detailRow('Phone:', '(555) 123-4567'),
                ],
              ),
            ],
          ),
          // Right Section: Class Information
          Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Class Information',
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow('Schedule:', 'Mon, Wed, Fri 10:00-11:00 AM'),
                  _detailRow('Location:', 'Science Building, Room 205'),
                  _detailRow('Semester:', 'Fall 2025'),
                ],
              ),
              Text(
                'Quick Links',
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                spacing: 16,
                children: [
                  _linkText('Syllabus'),
                  _linkText('Library Resources'),
                  _linkText('Academic Calendar'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper widget for info row
  Widget _detailRow(
    String label,
    String value, {
    Color color = const Color(0xFF6B7280),
  }) {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF1F2937),
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// Helper for quick link text
  Widget _linkText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF3B82F6),
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _courseOutline() {
    return _section(
      color: AppTheme.white,
      header: _sectionHeader(
        title: 'Course Timeline',
        subtitle: 'Key events and assignments throughout the semester',
      ),
      child: Column(
        spacing: 25,
        children: [_outlineItem(), _outlineItem(), _outlineItem()],
      ),
    );
  }

  Widget _weekInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: const [
        Text(
          'Week 1-2',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        Text(
          'Sept 5 - Sept 16',
          style: TextStyle(fontSize: 14.0, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _lessonInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        const Text(
          'Cell Structure & Function',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),

        // Assignment Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: const Text(
                      'Cell Structure Lab Report',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  CustomTag(
                    'Due Sept 16',
                    color: const Color(0xFF3B82F6),
                    textColor: Colors.white,
                  ),
                ],
              ),
              const Text(
                'Complete a detailed analysis of cell structures observed in the laboratory session.',
                style: TextStyle(fontSize: 14.0, color: Color(0xFF6B7280)),
              ),
              // Progress Bar
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.72,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _tagLabel('Cell Membrane'),
            _tagLabel('Cytoplasm'),
            _tagLabel('Organelles'),
            _tagLabel('Microscopy'),
          ],
        ),
      ],
    );
  }

  Widget _tagLabel(String text) {
    return CustomTag(
      text,
      color: const Color(0xFFF8F9FA),
      textColor: Color(0xFF6B7280),
    );
  }

  Widget _outlineItem() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return CustomCard(
          addBorder: true,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(25),
          child: ResponsiveSection(
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [_weekInfo(), _lessonInfo()],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: getDeviceResponsiveValue(
                deviceType: layoutVm.deviceType,
                mobile: 24,
                largeDesktop: 100,
              ),
              children: [_weekInfo(), Expanded(child: _lessonInfo())],
            ),
          ),
        );
      },
    );
  }

  Widget _studyTemplates() {
    return _section(
      header: _sectionHeader(
        title: 'Study Templates',
        subtitle: 'Professional formats for your scientific analysis',
      ),
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 25,
          children: [
            _templateCard(
              title: 'Lab Report',
              description: 'Format for experimental documentation',
              usage: 'Used 24 times',
              imagePath: Images.flask,
            ),
            _templateCard(
              title: 'Research Analysis',
              description: 'Framework for evaluating scientific sources',
              usage: 'Used 16 times',
              imagePath: Images.chart3,
            ),
            _templateCard(
              title: 'Scientific Summary',
              description: 'Templates for summarizing complex topics',
              usage: 'Used 9 times',
              imagePath: Images.book,
            ),
          ],
        ),
      ),
    );
  }

  Widget _templateCard({
    required String title,
    required String description,
    required String usage,
    required String imagePath,
  }) {
    return WidthLimiter(
      mobile: 368,
      child: CustomCard(
        addBorder: true,
        addCardShadow: true,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 160,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: CustomCard(
                addBorder: true,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: SVGImagePlaceHolder(
                    imagePath: imagePath,
                    color: const Color(0xFF3B82F6),
                    size: 36,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14.0, color: Color(0xFF6B7280)),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        usage,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        'Use Template',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3B82F6),
                        ),
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

  Widget _fileUploads() {
    return _section(
      color: AppTheme.white,
      header: _sectionHeader(
        title: 'File Uploads',
        subtitle: 'Essential readings and resources for your studies',
      ),
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 25,
          children: [
            _fileCard(
              title: 'Cell Structure Guide',
              subtitle: 'PDF • 2.4 MB • Uploaded Sept 5',
              status: 'Required reading',
            ),
            _fileCard(
              title: 'Genetics Research Paper',
              subtitle: 'PDF • 3.7 MB • Uploaded Sept 7',
              status: 'Supplemental reading',
            ),
            _fileCard(
              title: 'Lab Procedures Video',
              subtitle: 'MP4 • 45:12 • 112 MB',
              status: 'Required viewing',
            ),
          ],
        ),
      ),
    );
  }

  Widget _fileCard({
    required String title,
    required String subtitle,
    required String status,
  }) {
    return WidthLimiter(
      mobile: 368,
      child: CustomCard(
        addBorder: true,
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedChild(
              size: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SVGImagePlaceHolder(
                imagePath: Images.file,
                color: AppTheme.vividBlue,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    spacing: 15,
                    children: [
                      Expanded(
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                      SVGImagePlaceHolder(
                        imagePath: Images.upload4,
                        size: 16,
                        color: AppTheme.vividBlue,
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

  Widget _sectionHeader({required String title, required String subtitle}) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF1F2937),
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 16.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _courseActions() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return _section(
          color: AppTheme.white,
          header: _sectionHeader(
            title: 'Course Actions',
            subtitle: 'Access and manage your course materials efficiently',
          ),
          child: CustomGrid(
            wrapWithIntrinsicHeight: false,
            children: [
              buildActionCard(
                title: 'Create Note',
                description: 'Document your insights and research findings',
                buttonText: 'New Note',
                imagePath: Images.boardPlainCreateNote,
                onTap: vm.goToNewNoteTemplate,
              ),
              buildActionCard(
                title: 'Import PDF',
                description: 'Add research papers and reference materials',
                buttonText: 'Upload PDF',
                imagePath: Images.boardPlainImportPdf,
                // onTap: vm.importPdfFile,
                onTap: () => vm.importPdfFile(context),
              ),
              LoadingIndicator(
                loading: vm.savingFiles,
                child: buildActionCard(
                  title: 'Import Files',
                  description: 'Upload documents, images, and presentations',
                  buttonText: 'Add Files',
                  imagePath: Images.boardPlainImportFiles,
                  onTap: () => vm.importFiles(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildActionCard({
    required String title,
    required String description,
    required String buttonText,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      addBorder: true,
      addCardShadow: true,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          CustomCard(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            alignment: Alignment.center,
            child: WidthLimiter(
              mobile: 96,
              child: ImagePlaceHolder(
                imagePath: imagePath,
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 16.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 14.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          color: AppTheme.vividBlue,
                          fontSize: 16.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppTheme.vividBlue,
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

  Widget _section({required Widget child, Widget? header, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(color: color),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: WidthLimiter(
              mobile: largeDesktopSize,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 40,
                  children: [if (isNotNull(header)) header!, child],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerLeft() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<BoardEditVm>(
          builder: (_, vm, _) {
            final board = vm.board!;
            return Column(
              spacing: 24,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(
                      'Explore ${board.name}',
                      style: TextStyle(
                        color: const Color(0xFF1F2937),
                        fontSize: getDeviceResponsiveValue(
                          deviceType: layoutVm.deviceType,
                          mobile: 24,
                          laptop: 28,
                          desktop: 30,
                        ),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),

                    Text(
                      board.description ??
                          'Explore foundational concepts and key principles in this subject area through a mix of theoretical learning and practical application. This course offers an engaging introduction designed to build a solid understanding for further study',
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: 16.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 16,
                  children: [
                    //TODO this breaks
                    AppButton(
                      onTap: () => NavigationHelper.navigateToBoardNotes(board),
                      text: 'View All Notes',
                      mainAxisSize: MainAxisSize.min,
                      color: AppTheme.vividBlue,
                      wrapWithFlexible: true,
                    ),
                    //TODO return to this
                    AppButton.secondary(
                      onTap: () {},
                      text: 'View Syllabus',
                      mainAxisSize: MainAxisSize.min,
                      color: Color(0xFFE5E7EB),
                      wrapWithFlexible: true,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _headerRight() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        final board = vm.board!;
        CourseTimeline? nextSession = vm.getNextSession();
        //TODO return to this
        return CustomCard(
          addCardShadow: true,
          padding: const EdgeInsets.all(17),
          addBorder: true,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 23,
            children: [
              const Text(
                'Next Session',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  color: Color(0xFF1F2937),
                ),
              ),
              if (isNull(nextSession))
                Text('No upcoming sessions', style: AppTheme.text)
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    const Text(
                      'Monday, Sept 12 • 10:00-11:00 AM',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                        color: Color(0xFF6B7280),
                      ),
                    ),

                    Row(
                      spacing: 12,
                      children: [
                        OutlinedChild(
                          size: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: const Icon(
                            Icons.science_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Cell Structure Lab',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                  color: Color(0xFF1F2937),
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                'Science Building, Room 205',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                  color: Color(0xFF6B7280),
                                  height: 1.43,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _headerSection() {
    return _section(
      child: ResponsiveSection(
        mobile: Column(spacing: 20, children: [_headerLeft(), _headerRight()]),
        desktop: Row(
          spacing: 48,
          children: [
            Expanded(child: _headerLeft()),
            WidthLimiter(mobile: 400, child: _headerRight()),
          ],
        ),
      ),
    );
  }
}
