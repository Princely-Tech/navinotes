import 'package:navinotes/packages.dart';

class BoardPlainPopupOverview extends StatelessWidget {
  const BoardPlainPopupOverview({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiServiceProvider>(
      builder: (_, apiServiceProvider, _) {
        return Consumer<BoardEditVm>(
          builder: (context, vm, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerSection(),
                _courseActions(),
                Divider(height: 1, color: AppTheme.lightGray),
                _fileUploads(vm: vm, context: context),
                //  _studyTemplates(), // not completed
                _syllabus(
                  vm: vm,
                  apiServiceProvider: apiServiceProvider,
                  context: context,
                ),
                _courseOutline(vm: vm),
                Divider(height: 1, color: AppTheme.lightGray),
                _courseDetails(vm: vm),
              ],
            );
          },
        );
      },
    );
  }

  Widget _courseDetails({required BoardEditVm vm}) {
    if (vm.board.courseInfo == null) {
      return const SizedBox.shrink();
    }

    final courseInfo = vm.board.courseInfo;

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
                  _detailRow('Course:', courseInfo?.title),
                  _detailRow('Instructor:', courseInfo?.instructor),
                  _detailRow(
                    'Email:',
                    courseInfo?.email,
                    color: const Color(0xFF3B82F6),
                  ),
                  _detailRow('Office:', courseInfo?.location),
                  _detailRow('Office Hours:', courseInfo?.officeHours),
                  _detailRow('Phone:', courseInfo?.phone),
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
                  _detailRow('Schedule:', courseInfo?.schedule),
                  _detailRow('Location:', courseInfo?.location),
                  _detailRow('Semester:', courseInfo?.semester),
                  _detailRow('Duration:', courseInfo?.semesterDuration),
                ],
              ),
              // Text(
              //   'Quick Links',
              //   style: TextStyle(
              //     color: const Color(0xFF1F2937),
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // Row(
              //   spacing: 16,
              //   children: [
              //     _linkText('Syllabus'),
              //     _linkText('Library Resources'),
              //     _linkText('Academic Calendar'),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper widget for info row
  Widget _detailRow(
    String label,
    String? value, {
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
            stringOrNotSpecified(value),
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

  Widget _courseOutline({required BoardEditVm vm}) {
    List<CourseTimeline> courseOutlines = vm.board.courseTimeLines ?? [];

    if (courseOutlines.isEmpty) {
      return SizedBox.shrink();
    }

    return _section(
      key: vm.courseTimelineKey,
      color: AppTheme.white,
      header: _sectionHeader(
        title: 'Course Timeline',
        subtitle: 'Key events and assignments throughout the semester',
      ),
      child: Column(
        spacing: 25,
        children: courseOutlines.map((item) => _outlineItem(item)).toList(),
      ),
    );
  }

  Widget _weekInfo({required String week, String? date}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          week,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        Text(
          date ?? '',
          style: TextStyle(fontSize: 14.0, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _lessonInfo({
    required String title,
    required String? description,
    required String? assignment,
    required String? dueDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),

        if (description != null)
          Text(
            description,
            style: TextStyle(fontSize: 14.0, color: Color(0xFF6B7280)),
          ),

        // Assignment Card
        (assignment != null && assignment.isNotEmpty)
            ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                    "Assignment:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),

                  Row(
                    spacing: 15,
                    children: [
                      Expanded(
                        child: Text(
                          assignment,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                      (dueDate != null)
                          ? CustomTag(
                            dueDate,
                            color: const Color(0xFF3B82F6),
                            textColor: Colors.white,
                          )
                          : SizedBox.shrink(),
                    ],
                  ),

                  // Progress Bar
                  // Container(
                  //   height: 8,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFFE5E7EB),
                  //     borderRadius: BorderRadius.circular(9999),
                  //   ),
                  //   child: FractionallySizedBox(
                  //     alignment: Alignment.centerLeft,
                  //     widthFactor: 0.72,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xFF3B82F6),
                  //         borderRadius: BorderRadius.circular(9999),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
            : SizedBox.shrink(),
        // Tags
        // Wrap(
        //   spacing: 8,
        //   runSpacing: 8,
        //   children: [
        //     _tagLabel('Cell Membrane'),
        //     _tagLabel('Cytoplasm'),
        //     _tagLabel('Organelles'),
        //     _tagLabel('Microscopy'),
        //   ],
        // ),
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

  Widget _outlineItem(CourseTimeline courseTimeline) {
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
              children: [
                _weekInfo(week: courseTimeline.week),
                _lessonInfo(
                  title: courseTimeline.title,
                  description: courseTimeline.description,
                  assignment: courseTimeline.assignment,
                  dueDate: courseTimeline.due,
                ),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: getDeviceResponsiveValue(
                deviceType: layoutVm.deviceType,
                mobile: 24,
                largeDesktop: 100,
              ),
              children: [
                _weekInfo(week: courseTimeline.week),
                Expanded(
                  child: _lessonInfo(
                    title: courseTimeline.title,
                    description: courseTimeline.description,
                    assignment: courseTimeline.assignment,
                    dueDate: courseTimeline.due,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget studyTemplates() {
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

  Widget _sectionCard({
    required String header,
    required Color color,
    required String title,
    required String body,
    required Widget button,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              button,
            ],
          ),
        ),
      ),
    );
  }

  Widget _syllabus({
    required BoardEditVm vm,
    required ApiServiceProvider apiServiceProvider,
    required BuildContext context,
  }) {
    var btnText = "Upload syllabus to get AI analysis";
    var desc =
        "After uploading your syllabus, we\'ll automatically generate course details, a timeline of important dates, and assignments for your semester";
    if (vm.board.courseTimeLines != null) {
      btnText = "Change syllabus";
      desc =
          "Your timeline, assignments and course details are generated from the syllabus you uploaded.";
    }

    var syllabusContent = vm.board.syllabusContent;
    return _sectionCard(
      header: 'Course Timeline',
      color: AppTheme.lightAsh,
      title: 'Your AI assisted analysis',
      body: desc,
      button: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AppButton.secondary(
              mainAxisSize: MainAxisSize.min,
              loading: vm.uploadingSyllabus,
              onTap: () {
                vm.uploadSyllabus(
                  context: context,
                  apiServiceProvider: apiServiceProvider,
                );
              },
              color: AppTheme.strongBlue,
              text: btnText,
              style: const TextStyle(
                color: Color(0xFF3B82F6),
                fontSize: 16.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(width: 16),

            (syllabusContent != null)
                ? _buildMenuItem(
                  icon: Icons.open_in_new,
                  label: 'Open Syllabus',
                  onTap: () {
                    handleOpenFile(syllabusContent, context);
                  },
                )
                : SizedBox.shrink(),

            SizedBox(width: 16),
            (syllabusContent != null)
                ? _buildMenuItem(
                  icon: Icons.download,
                  label: 'Download Syllabus',
                  onTap: () {
                    handleFileDownload(syllabusContent, context);
                  },
                )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            // NavigationHelper.pop();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color:
                      textColor ??
                      Theme.of(context).textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        textColor ??
                        Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  // Widget fileUploads1({required BoardEditVm vm}) {
  //   return _section(
  //     color: AppTheme.white,
  //     header: _sectionHeader(
  //       title: 'File Uploads',
  //       subtitle: 'Essential readings and resources for your studies',
  //     ),
  //     child: ScrollableController(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         spacing: 25,
  //         children: [
  //           _fileCard(
  //             title: 'Cell Structure Guide',
  //             subtitle: 'PDF • 2.4 MB • Uploaded Sept 5',
  //             status: 'Required reading',
  //           ),
  //           _fileCard(
  //             title: 'Genetics Research Paper',
  //             subtitle: 'PDF • 3.7 MB • Uploaded Sept 7',
  //             status: 'Supplemental reading',
  //           ),
  //           _fileCard(
  //             title: 'Lab Procedures Video',
  //             subtitle: 'MP4 • 45:12 • 112 MB',
  //             status: 'Required viewing',
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _fileUploads({
    required BoardEditVm vm,
    required BuildContext context,
  }) {
    if (vm.uploadedFiles.isEmpty) {
      return _section(
        color: AppTheme.white,
        header: _sectionHeader(
          title: 'File Uploads',
          subtitle: 'No files uploaded yet',
        ),
        child: const SizedBox.shrink(),
      );
    }

    return _section(
      color: AppTheme.white,
      header: _sectionHeader(
        title: 'File Uploads',
        subtitle: 'Essential readings and resources for your studies',
      ),
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 16,
          children:
              vm.uploadedFiles.map((file) {
                final metaDataSize = file.metaData[ContentMetadataKey.fileSize];
                final size = getFileSize(metaDataSize);
                final name = file.title;
                //TODO return to this. Needs description
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 16),
                  child: CustomCard(
                    addBorder: true,
                    addCardShadow: true,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                getFileIcon(file.file),
                                size: 24,
                                color: AppTheme.vividBlue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            size,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.open_in_new, size: 20),
                                onPressed: () {
                                  handleOpenFile(file, context);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Open',
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.download, size: 20),
                                onPressed: () {
                                  handleFileDownload(file, context);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Download',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
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
                onTap: vm.goToBoardNotes,
              ),
              buildActionCard(
                title: 'Import PDF',
                description: 'Add research papers and reference materials',
                buttonText: 'Upload PDF',
                imagePath: Images.boardPlainImportPdf,
                onTap: () => vm.importPdfFile(context),
                loading: vm.importingPdf,
              ),
              buildActionCard(
                title: 'Import Files',
                description: 'Upload documents, images, and presentations',
                buttonText: 'Add Files',
                imagePath: Images.boardPlainImportFiles,
                onTap: () => vm.importFiles(context),
                loading: vm.savingFiles,
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
    bool loading = false,
  }) {
    return LoadingIndicator(
      loading: loading,
      child: InkWell(
        onTap: onTap,
        child: CustomCard(
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
        ),
      ),
    );
  }

  Widget _section({
    required Widget child,
    Widget? header,
    Color? color,
    Key? key,
  }) {
    return Container(
      key: key,
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
            final board = vm.board;
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
                      getBoardDescription(board),
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
                    AppButton(
                      onTap: vm.goToBoardNotes,
                      text: 'View All Notes',
                      mainAxisSize: MainAxisSize.min,
                      color: AppTheme.vividBlue,
                      wrapWithFlexible: true,
                    ),
                    AppButton.secondary(
                      onTap: vm.scrollToCourseTimeline,
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
        CourseTimeline? nextSession = vm.getNextSession();

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
                    Text(
                      // 'Monday, Sept 12 • 10:00-11:00 AM',
                      '${nextSession!.due}',
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
                            Icons.event_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nextSession.title,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                  color: Color(0xFF1F2937),
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                nextSession.week,
                                // 'Science Building, Room 205',
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
