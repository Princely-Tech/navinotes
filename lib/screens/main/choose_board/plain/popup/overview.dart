import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/date_utils.dart';

class BoardPlainPopupOverview extends StatelessWidget {
  const BoardPlainPopupOverview({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiServiceProvider>(
      builder: (_, apiServiceProvider, _) {
        return Consumer<BoardEditVm>(
          builder: (context, vm, _) {
            return FutureBuilder<List<Content>>(
              future: _getAllContents(vm.board.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Loading board contents...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final allContents = snapshot.data ?? [];
                final notes =
                    allContents
                        .where((content) => content.type == AppContentType.note)
                        .toList();
                final mindMaps =
                    allContents
                        .where(
                          (content) => content.type == AppContentType.mindmap,
                        )
                        .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerSection(context),

                    _courseActions(),
                    _recentNotesSection(notes),

                    _fileUploads(vm: vm, context: context),
                    _mindMapsSection(mindMaps),

                    _flashCardsDeckSection(vm),

                    Divider(height: 1, color: AppTheme.lightGray),
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
                    NavigationHelper.navigateToContent(syllabusContent);
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
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 16),
                  child: CustomCard(
                    addBorder: true,
                    addCardShadow: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image preview or icon section
                        _buildFilePreview(file),

                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                                    icon: const Icon(
                                      Icons.open_in_new,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      NavigationHelper.navigateToContent(file);
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
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilePreview(Content file) {
    final filePath = file.file;
    if (filePath == null) {
      return _buildFileIconPreview(file);
    }

    // Check if it's an image file
    final extension = filePath.toLowerCase();
    final isImage =
        extension.endsWith('.png') ||
        extension.endsWith('.jpg') ||
        extension.endsWith('.jpeg') ||
        extension.endsWith('.gif') ||
        extension.endsWith('.webp') ||
        extension.endsWith('.bmp');

    if (isImage && File(filePath).existsSync()) {
      return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          color: Colors.grey.shade100,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          child: Image.file(
            File(filePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildFileIconPreview(file);
            },
          ),
        ),
      );
    }

    return _buildFileIconPreview(file);
  }

  Widget _buildFileIconPreview(Content file) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        color: Colors.grey.shade100,
      ),
      child: Center(
        child: Icon(
          getFileIcon(file.file),
          size: 48,
          color: AppTheme.vividBlue,
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

  Widget _headerLeft(BuildContext context) {
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
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Explore ${board.name}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 8),

                        InkWell(
                          onTap: () => _editBoardName(context),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: AppTheme.vividBlue,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            (board.hasDescription())
                                ? board.description!
                                : 'Describe your board',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF6B7280),
                              fontSize: 16.0,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        SizedBox(width: 8),
                        InkWell(
                          onTap: () => _editBoardDescription(context),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: AppTheme.vividBlue,
                          ),
                        ),
                      ],
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

  Widget _headerSection(BuildContext context) {
    return _section(
      child: ResponsiveSection(
        mobile: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: [_headerLeft(context), _headerRight()],
        ),
        desktop: Row(
          spacing: 48,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: _headerLeft(context)),
            WidthLimiter(mobile: 400, child: _headerRight()),
          ],
        ),
      ),
    );
  }

  void _editBoardName(BuildContext context) {
    final vm = Provider.of<BoardEditVm>(context, listen: false);
    final controller = TextEditingController(text: vm.board.name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Board Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter board name...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                vm.updateBoardName(value.trim());
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  vm.updateBoardName(controller.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _recentNotesSection(List<Content> notes) {
    // Sort by updated date (most recent first)
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return _section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Notes',
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 18.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (notes.length > 5)
                Consumer<BoardEditVm>(
                  builder: (context, vm, _) {
                    return TextButton(
                      onPressed: vm.goToBoardNotes,
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: AppTheme.vividBlue,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          if (notes.isEmpty)
            Text(
              'No notes yet. Create your first note to get started.',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 14.0,
                fontFamily: 'Inter',
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Column(
              spacing: 8,
              children: notes.take(5).map((note) => _noteItem(note)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _mindMapsSection(List<Content> mindMaps) {
    // Sort by updated date (most recent first)
    mindMaps.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return _section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mind Maps',
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 18.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Consumer<BoardEditVm>(
                builder: (context, vm, _) {
                  return TextButton.icon(
                    onPressed: vm.createMindMap,
                    icon: Icon(
                      Icons.add,
                      size: 16,
                      color: AppTheme.emeraldGreen,
                    ),
                    label: Text(
                      'Create Mind Map',
                      style: TextStyle(
                        color: AppTheme.vividBlue,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          if (mindMaps.isEmpty)
            Text(
              'No mind maps yet. Create your first mind map to get started.',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 14.0,
                fontFamily: 'Inter',
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Column(
              spacing: 8,
              children:
                  mindMaps.map((mindMap) => _mindMapItem(mindMap)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _flashCardsDeckSection(BoardEditVm vm) {
    return _section(
      child: FutureBuilder<List<Content>>(
        future: _getFlashCardDecks(vm.board.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final flashCardDecks = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Flashcard Decks',
                    style: TextStyle(
                      color: const Color(0xFF1F2937),
                      fontSize: 18.0,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Consumer<BoardEditVm>(
                    builder: (context, vm, _) {
                      return TextButton.icon(
                        onPressed: vm.createFlashCardDeck,
                        icon: Icon(
                          Icons.add,
                          size: 16,
                          color: AppTheme.vividBlue,
                        ),
                        label: Text(
                          'Create Deck',
                          style: TextStyle(
                            color: AppTheme.vividBlue,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              if (flashCardDecks.isEmpty)
                Text(
                  'No flashcard decks yet. Create your first deck to get started.',
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 14.0,
                    fontFamily: 'Inter',
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                Column(
                  spacing: 8,
                  children:
                      flashCardDecks
                          .map((deck) => _flashCardDeckItem(deck))
                          .toList(),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _noteItem(Content note) {
    return InkWell(
      onTap: () => NavigationHelper.navigateToContent(note),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.note, size: 16, color: AppTheme.steelBlue),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title.isNotEmpty ? note.title : 'Untitled Note',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    formatDate(
                      DateTime.fromMillisecondsSinceEpoch(
                        note.updatedAt * 1000,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Content>> _getAllContents(int boardId) async {
    try {
      return await DatabaseHelper.instance.getAllContents(boardId);
    } catch (e) {
      debugPrint('Error fetching contents: $e');
      return [];
    }
  }

  Future<List<Content>> _getFlashCardDecks(int boardId) async {
    try {
      return await DatabaseHelper.instance.getBoardDecks(boardId);
    } catch (e) {
      debugPrint('Error fetching flashcard decks: $e');
      return [];
    }
  }

  Widget _mindMapItem(Content mindMap) {
    return InkWell(
      onTap: () => NavigationHelper.navigateToContent(mindMap),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.account_tree, size: 16, color: AppTheme.emeraldGreen),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mindMap.title.isNotEmpty
                        ? mindMap.title
                        : 'Untitled Mind Map',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    formatDate(
                      DateTime.fromMillisecondsSinceEpoch(
                        mindMap.updatedAt * 1000,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _flashCardDeckItem(Content deck) {
    return InkWell(
      onTap: () {
        NavigationHelper.navigateToDeck(deck);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.quiz, size: 16, color: AppTheme.vividBlue),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deck.title.isNotEmpty
                        ? deck.title
                        : 'Untitled Flashcard Deck',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    formatDate(
                      DateTime.fromMillisecondsSinceEpoch(
                        deck.updatedAt * 1000,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editBoardDescription(BuildContext context) {
    final vm = Provider.of<BoardEditVm>(context, listen: false);
    final controller = TextEditingController(text: vm.board.description ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Board Description'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter board description...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            maxLines: 3,
            onSubmitted: (value) {
              vm.updateBoardDescription(value.trim());
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                vm.updateBoardDescription(controller.text.trim());
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
