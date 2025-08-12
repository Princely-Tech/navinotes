import 'package:navinotes/packages.dart';

class BoardLightAcadPopupOverview extends StatelessWidget {
  const BoardLightAcadPopupOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
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
                  children: [
                    // _studyTemplates(),
                    _courseTimeline(),
                  ],
                ),
              ),
            ),
            _footer(),
          ],
        );
      },
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
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return _footerItem(
          title: 'Course Details',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Instructor:', vm.board.courseInfo?.instructor),
              _buildDetailItem('Email:', vm.board.courseInfo?.email),
              _buildDetailItem(
                'Office Hours:',
                vm.board.courseInfo?.officeHours,
              ),
              _buildDetailItem('Phone:', vm.board.courseInfo?.phone),
            ],
          ),
        );
      },
    );
  }

  Widget _classInfo() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return _footerItem(
          title: 'Class Information',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Schedule:', vm.board.courseInfo?.schedule),
              _buildDetailItem('Location:', vm.board.courseInfo?.location),
              _buildDetailItem('Semester:', vm.board.courseInfo?.semester),
              // SizedBox(height: 16),
              // Text(
              //   'Quick Links',
              //   style: TextStyle(
              //     color: const Color(0xFFFFB347),
              //     fontSize: 16,
              //     fontFamily: 'EB Garamond',
              //     fontWeight: FontWeight.w400,
              //     height: 1.50,
              //   ),
              // ),
              // SizedBox(height: 8),
              // Wrap(
              //   spacing: 16,
              //   children:
              //       ['Syllabus', 'Academic Calendar', 'Library Resources']
              //           .map(
              //             (str) => Text(
              //               str,
              //               style: TextStyle(
              //                 color: const Color(0xFFFAF7F0),
              //                 fontSize: 16,
              //                 fontFamily: 'Open Sans',
              //                 fontWeight: FontWeight.w400,
              //                 height: 1.50,
              //               ),
              //             ),
              //           )
              //           .toList(),
              // ),
            ],
          ),
        );
      },
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
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return Column(
          key: vm.courseTimelineKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
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

            Consumer<ApiServiceProvider>(
              builder: (_, apiServiceProvider, _) {
                List<CourseTimeline> courseOutlines =
                    vm.board.courseTimeLines ?? [];
                if (courseOutlines.isEmpty) {
                  return AppButton(
                    onTap:
                        () => vm.uploadSyllabus(
                          apiServiceProvider: apiServiceProvider,
                          context: context,
                        ),
                    mainAxisSize: MainAxisSize.min,
                    color: const Color(0xFFF0EBE0),
                    text: 'Upload Syllabus',
                    loading: vm.uploadingSyllabus,
                    borderColor: const Color(0x338B4513),
                    minHeight: 40,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.upload,
                      color: const Color(0xFF654321),
                      size: 16,
                    ),
                    style: TextStyle(
                      color: const Color(0xFF654321),
                      fontSize: 16,
                      fontFamily: 'EB Garamond',
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }
                double maxHeight = screenHeight(context) / 2;
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // spacing: 24,
                      children:
                          courseOutlines
                              .map((item) => BoardLightAcadTimelineItem(item))
                              .toList(),
                      // children: [
                      //   _buildTimelineItem(
                      //     week: 'Week 1-2: Cell Structure & Function',
                      //     assignment: 'Cell Structure Lab Report',
                      //     status: 'In Progress',
                      //     progress: 0.65,
                      //     tags: [
                      //       'Cell Membrane',
                      //       'Cytoplasm',
                      //       'Organelles',
                      //       'Microscopy',
                      //     ],
                      //   ),
                      // ],
                    ),
                  ),
                );
              },
            ),

            // Timeline Items
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   spacing: 24,
            //   children: [
            //     _buildTimelineItem(
            //       week: 'Week 1-2: Cell Structure & Function',
            //       assignment: 'Cell Structure Lab Report',
            //       status: 'In Progress',
            //       progress: 0.65,
            //       tags: [
            //         'Cell Membrane',
            //         'Cytoplasm',
            //         'Organelles',
            //         'Microscopy',
            //       ],
            //     ),
            //   ],
            // ),
            // SizedBox(height: 24),
            // _buildTimelineItem(
            //   week: 'Week 3-4: Genetics & DNA',
            //   assignment: 'Genetic Inheritance Quiz',
            //   status: 'Due Oct 15',
            //   tags: ['DNA Structure', 'Inheritance', 'Genes', 'Mutations'],
            // ),
            // SizedBox(height: 24),
            // _buildTimelineItem(
            //   week: 'Week 5-6: Evolution & Natural Selection',
            //   assignment: 'Evolution Case Study',
            //   status: 'Not Started',
            //   tags: [
            //     'Natural Selection',
            //     'Adaptation',
            //     'Speciation',
            //     'Fossil Record',
            //   ],
            // ),
          ],
        );
      },
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
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return _section(
          title: 'File Uploads',
          subTitle: 'Recently uploaded study materials',
          child:
              vm.uploadedFiles.isEmpty
                  ? AppButton(
                    onTap: () => vm.importFiles(context),
                    mainAxisSize: MainAxisSize.min,
                    color: const Color(0xFFF0EBE0),
                    text: 'Upload files',
                    loading: vm.savingFiles,
                    borderColor: const Color(0x338B4513),
                    minHeight: 40,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.upload,
                      color: const Color(0xFF654321),
                      size: 16,
                    ),
                    style: TextStyle(
                      color: const Color(0xFF654321),
                      fontSize: 16,
                      fontFamily: 'EB Garamond',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                  : ScrollableController(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 24,
                      children:
                          vm.uploadedFiles.map((file) {
                            return _buildFileCard(file);
                          }).toList(),
                      // children: [
                      //   _buildFileCard('Cell_Membrane_Notes.pdf', '2.4 MB', 'Oct 8, 2023'),
                      //   _buildFileCard(
                      //     'DNA_Structure_Lecture.pptx',
                      //     '5.7 MB',
                      //     'Oct 5, 2023',
                      //   ),
                      //   _buildFileCard(
                      //     'Cell_Microscopy_Images.zip',
                      //     '18.2 MB',
                      //     'Oct 2, 2023',
                      //   ),
                      // ],
                    ),
                  ),
        );
      },
    );
  }

  Widget _section({
    required String title,
    required String subTitle,
    required Widget child,
    bool isWhite = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Column(
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
      ),
    );
  }

  Widget _courseActions() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
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
                onTap: vm.createNoteHandler,
              ),
              _buildActionCard(
                icon: Images.pdf,
                title: 'Import PDF',
                description:
                    'Upload and annotate PDF documents from your course materials or research.',
                actionText: 'Import document',
                onTap: () => vm.importPdfFile(context),
                loading: vm.importingPdf,
              ),
              _buildActionCard(
                icon: Images.folder,
                title: 'Import Files',
                description:
                    'Upload multiple files including images, documents, and presentations.',
                actionText: 'Upload files',
                onTap: () => vm.importFiles(context),
                loading: vm.savingFiles,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _title() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<BoardEditVm>(
          builder: (_, vm, _) {
            final board = vm.board;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  'Explore ${board.name}',
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
                Text(
                  getBoardDescription(board),
                  style: TextStyle(
                    color: const Color(0xFF8B4513),
                    fontSize: 16,
                    fontFamily: 'Open Sans',
                  ),
                ),
                Wrap(
                  spacing: 16,
                  children: [
                    AppButton(
                      mainAxisSize: MainAxisSize.min,
                      onTap: vm.goToBoardNotes,
                      text: 'View All Notes',
                      color: const Color(0xFF8B4513),
                      padding: EdgeInsets.symmetric(horizontal: 24),
                    ),
                    AppButton.secondary(
                      mainAxisSize: MainAxisSize.min,
                      onTap: vm.scrollToCourseTimeline,
                      text: 'View Syllabus',
                      color: const Color(0xFF8B4513),
                    ),

                    AppButton.secondary(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      mainAxisSize: MainAxisSize.min,
                      onTap: vm.scrollToCourseTimeline,
                      color: const Color(0x4CF7F3E9),
                      text: 'View Syllabus',
                      minHeight: 40,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      style: TextStyle(
                        color: const Color(0xFFF7F3E9),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
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

  Widget _nextSession() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        CourseTimeline? nextSession = vm.getNextSession();
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 20),
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
              if (isNull(nextSession))
                Text('No upcoming sessions', style: AppTheme.text)
              else
                Builder(
                  builder: (context) {
                    final courseInfo = vm.board.courseInfo;
                    return Column(
                      spacing: 8,
                      children: [
                        Text(
                          nextSession!.title,
                          style: TextStyle(
                            color: const Color(0xFF2F2F2F),
                            fontSize: 16,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          stringOrNotSpecified(courseInfo?.instructor),
                          style: TextStyle(
                            color: const Color(0xFF2F2F2F),
                            fontSize: 14,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Column(
                          spacing: 8,
                          children: [
                            _nextSessionRow(
                              icon: Images.calender,
                              text: stringOrNotSpecified(nextSession.week),
                            ),
                            _nextSessionRow(
                              icon: Images.clock,
                              text: stringOrNotSpecified(nextSession.due),
                            ),
                            _nextSessionRow(
                              icon: Images.location,
                              text: stringOrNotSpecified(courseInfo?.location),
                            ),
                          ],
                        ),
                        // SizedBox(height: 16),
                        // AppButton(
                        //   onTap: () {},
                        //   text: 'Prepare Materials',
                        //   color: const Color(0xFF8B4513),
                        //   style: TextStyle(
                        //     color: const Color(0xFFD4AF37),
                        //     fontSize: 16,
                        //     fontFamily: 'EB Garamond',
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                      ],
                    );
                  },
                ),
            ],
          ),
        );
      },
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
      mobile: Column(spacing: 10, children: [_title(), _nextSession()]),
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
      child: LargeDesktopWidthLimiter(child: child),
    );
  }

  // Helper Widgets
  Widget _buildActionCard({
    required String icon,
    required String title,
    required String description,
    required String actionText,
    required VoidCallback onTap,
    bool loading = false,
  }) {
    return LoadingIndicator(
      loading: loading,
      child: InkWell(
        onTap: onTap,
        child: CustomCard(
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
        ),
      ),
    );
  }

  Widget _buildFileCard(Content file) {
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
                      file.title,
                      style: TextStyle(
                        color: const Color(0xFF654321),
                        fontSize: 16,
                        fontFamily: 'EB Garamond',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 10,
                      children:
                          [
                                getFileSize(
                                  file.metaData[ContentMetadataKey.fileSize],
                                ),
                                formatUnixTimestamp(file.createdAt),

                                // date,
                              ]
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

  Widget _buildDetailItem(String label, String? value) {
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
              text: ' ${stringOrNotSpecified(value)}',
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
