import 'package:navinotes/packages.dart';

class BoardMinimalistPopupScreen extends StatelessWidget {
  const BoardMinimalistPopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
       Board board = ModalRoute.of(context)?.settings.arguments as Board;
    return  ChangeNotifierProvider(
      create: (context) {
        final vm = BoardEditVm(board: board);
        vm.initialize();
        return vm;
      },
      child: ScaffoldFrame(
        backgroundColor: AppTheme.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            _navigationSection(),
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.symmetric(vertical: 15),
                tabletPadding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 50,
                  children: [
                    _widthLimiter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 50,
                        children: [
                          _courseTitle(),
                          _courseActions(),
                          _fileUploads(),
                          _studyTemplates(),
                          _courseTimeLine(),
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

  Widget _footerItem({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF6B6B6B),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 24),
        ...children,
      ],
    );
  }

  Widget _footer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 50),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      child: _widthLimiter(
        child: CustomGrid(
          largeDesktop: 2,
          children: [
            _footerItem(
              title: 'Course Details',
              children: [
                _buildDetailItem('Course: BIOLOGY 101'),
                _buildDetailItem('Instructor: Dr. Sarah Chen'),
                _buildDetailItem('Email: s.chen@university.edu'),
                _buildDetailItem('Office: Science Building, Room 110'),
                _buildDetailItem('Office Hours: Tues 1-3pm, Thurs 2-4pm'),
                _buildDetailItem('Phone: (555) 123-4567'),
              ],
            ),
            _footerItem(
              title: 'Class Information',
              children: [
                _buildDetailItem('Schedule: Mon, Wed, Fri 10:00-11:00 AM'),
                _buildDetailItem('Location: Science Building, Room 205'),
                _buildDetailItem('Semester: Fall 2025'),
                SizedBox(height: 25),
                Text(
                  'Quick Links',
                  style: TextStyle(
                    color: const Color(0xFF6B6B6B),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  spacing: 15,
                  children:
                      ['Syllabus', 'Library Resources', 'Academic Calendar']
                          .map(
                            (str) => AppButton.text(
                              onTap: () {},
                              wrapWithFlexible: true,
                              child: Flexible(
                                child: Text(
                                  str,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF00555A),
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w300,
                                    height: 1.43,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _courseTimeLine() {
    return _section(
      title: 'Course Timeline',
      subTitle: 'Key events and assignments throughout the semester',
      child: Column(
        spacing: 40,
        children: [
          _buildTimelineCard(
            title: 'Week 1-2: Cell Structure & Function',
            status: 'In Progress',
            assignment: 'Assignment: Cell Structure Lab Report',
            dueDate: 'Due Sept 16',
            progress: 0.65,
            tags: ['Cell Membrane', 'Cytoplasm', 'Organelles', 'Microscopy'],
          ),

          _buildTimelineCard(
            title: 'Week 3-4: Genetics & DNA',
            status: 'Upcoming',
            assignment: 'Assignment: Genetic Inheritance Quiz',
            dueDate: 'Due Sept 27',
            progress: 0.1,
            tags: ['DNA Structure', 'Inheritance', 'Genes', 'Mutations'],
          ),

          _buildTimelineCard(
            title: 'Week 5-6: Evolution & Natural Selection',
            status: 'Not Started',
            assignment: 'Assignment: Evolution Case Study',
            dueDate: 'Not Started',
            progress: 0.0,
            tags: [
              'Natural Selection',
              'Adaptation',
              'Speciation',
              'Fossil Record',
            ],
          ),
        ],
      ),
    );
  }

  Widget _studyTemplates() {
    return _section(
      title: 'Study Templates',
      subTitle: 'Professional formats for your scientific analysis',
      child: CustomGrid(
        spacing: 32,
        children: [
          _buildTemplateCard(
            icon: Images.flask,
            title: 'Lab Report',
            description: 'Format for experimental documentation',
            usage: 'Used 24 times',
          ),

          _buildTemplateCard(
            icon: Images.chart3,
            title: 'Research Analysis',
            description: 'Framework for evaluating scientific sources',
            usage: 'Used 12 times',
          ),

          _buildTemplateCard(
            icon: Images.file2,
            title: 'Scientific Summary',
            description: 'Templates for summarizing complex topics',
            usage: 'Used 8 times',
          ),
        ],
      ),
    );
  }

  Widget _fileUploads() {
    return _section(
      title: 'File Uploads',
      subTitle: 'Essential readings and resources for your studies',
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 32,
          children: [
            _buildFileCard(
              icon: Icons.picture_as_pdf,
              title: 'Cell Structure Guide',
              details: 'PDF • 2.4 MB • Uploaded Sept 8',
              tag: 'Required reading',
            ),

            _buildFileCard(
              icon: Icons.picture_as_pdf,
              title: 'Genetics Research Paper',
              details: 'PDF • 3.7 MB • Uploaded Sept 7',
              tag: 'Supplemental reading',
            ),

            _buildFileCard(
              icon: Icons.video_library,
              title: 'Lab Procedures Video',
              details: 'MP4 • 45:12 • 112 MB',
              tag: 'Required viewing',
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required Widget child,
    String? subTitle,
  }) {
    return Column(
      spacing: 25,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF2C2C2C),
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
              ),
            ),
            if (isNotNull(subTitle))
              Text(
                subTitle!,
                style: TextStyle(
                  color: const Color(0xFF6B6B6B),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300,
                  height: 1.43,
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
      child: CustomGrid(
        spacing: 32,
        children: [
          _buildActionCard(
            icon: Images.edit,
            title: 'Create Note',
            description: 'Document your insights and research findings',
            actionText: 'New Note →',
          ),
          _buildActionCard(
            icon: Images.pdf,
            title: 'Import PDF',
            description: 'Add research papers and reference materials',
            actionText: 'Upload PDF →',
          ),
          _buildActionCard(
            icon: Images.folder,
            title: 'Import Files',
            description: 'Upload documents, images, and presentations',
            actionText: 'Add Files →',
          ),
        ],
      ),
    );
  }

  Widget _courseTitle() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore Cell Biology & Genetics',
              style: TextStyle(
                color: const Color(0xFF2C2C2C),
                fontSize: getDeviceResponsiveValue(
                  deviceType: layoutVm.deviceType,
                  mobile: 25,
                  laptop: 30,
                ),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Discover the fundamental principles of cellular structure, function, and genetic inheritance through this comprehensive course. Develop critical thinking skills while exploring cutting-edge research in molecular biology.',
              style: TextStyle(
                color: const Color(0xFF6B6B6B),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 48),
            Row(
              spacing: 15,
              children: [
                AppButton.secondary(
                  onTap: () {},
                  mainAxisSize: MainAxisSize.min,
                  wrapWithFlexible: true,
                  minHeight: 40,
                  text: 'View All Notes',
                  color: const Color(0xFFF0F0F0),
                  style: TextStyle(
                    color: const Color(0xFF2C2C2C),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                AppButton.text(
                  onTap: () {},
                  wrapWithFlexible: true,
                  text: 'View Syllabus',
                  style: TextStyle(
                    color: const Color(0xFF00555A),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    height: 1.43,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Container(
              constraints: BoxConstraints(minWidth: 384),
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF0F0F0)),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next Session',
                    style: TextStyle(
                      color: const Color(0xFF6B6B6B),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Monday, Sept 12 • 10:00-11:00 AM',
                    style: TextStyle(
                      color: const Color(0xFF2C2C2C),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _navigationSection() {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: TextRowSelect(
          items: EditBoardTab.values.map((item) => item.toString()).toList(),
          borderColor: const Color(0xFF00555A),
          selectedTextStyle: TextStyle(
            color: const Color(0xFF00555A),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
          ),
          style: TextStyle(
            color: const Color(0xFF6B6B6B),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container( 
      decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          spacing: 15,
          children: [
            Expanded(
              child: Row(
                children: [
                  MenuButton(onPressed: () {}),
                  IconButton(
                    onPressed: NavigationHelper.pop,
                    icon: Icon(
                      Icons.arrow_back,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'BIOLOGY 101 - Fall Semester',
                      style: TextStyle(
                        color: const Color(0xFF2C2C2C),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                AppIconButton(
                  onPressed: NavigationHelper.navigateToNotification,
                  icon: Icon(
                    Icons.notifications,
                    size: 24,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
                AppIconButton(
                  onPressed: NavigationHelper.navigateToProfile,
                  icon: Icon(
                    Icons.person,
                    size: 24,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildActionCard({
    required String icon,
    required String title,
    required String description,
    required String actionText,
  }) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SVGImagePlaceHolder(
            imagePath: icon,
            size: 20,
            color: const Color(0xFF00555A),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF2C2C2C),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: const Color(0xFF6B6B6B),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 24),
          Text(
            actionText,
            style: TextStyle(
              color: const Color(0xFF00555A),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard({
    required IconData icon,
    required String title,
    required String details,
    required String tag,
  }) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(2),
      ),
      constraints: BoxConstraints(minWidth: 346),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 15,
              children: [Icon(icon, size: 20), Icon(Icons.more_vert, size: 20)],
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF2C2C2C),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8),
            Text(
              details,
              style: TextStyle(
                color: const Color(0xFF6B6B6B),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 16),
            Text(
              tag,
              style: TextStyle(
                color: const Color(0xFF00555A),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
              ),
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
    required String usage,
  }) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SVGImagePlaceHolder(
            imagePath: icon,
            size: 20,
            color: const Color(0xFF00555A),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF2C2C2C),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: const Color(0xFF6B6B6B),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 24),
          Row(
            spacing: 15,
            children: [
              Expanded(
                child: Text(
                  usage,
                  style: TextStyle(
                    color: const Color(0xFF6B6B6B),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Text(
                'Use Template',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF00555A),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard({
    required String title,
    required String status,
    required String assignment,
    required String dueDate,
    required double progress,
    required List<String> tags,
  }) {
    Color statusColor;
    if (status == 'In Progress') {
      statusColor = const Color(0xFF00555A);
    } else {
      statusColor = const Color(0xFF6B6B6B);
    }

    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF2C2C2C),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      status == 'In Progress'
                          ? const Color(0x1900555A)
                          : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            assignment,
            style: TextStyle(
              color: const Color(0xFF2C2C2C),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Text(
            dueDate,
            style: TextStyle(
              color:
                  status == 'In Progress'
                      ? const Color(0xFF00555A)
                      : const Color(0xFF6B6B6B),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFF0F0F0),
            color: const Color(0xFF00555A),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                tags
                    .map(
                      (tag) => Chip(
                        label: Text(
                          tag,
                          style: TextStyle(
                            color: const Color(0xFF2C2C2C),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        backgroundColor: const Color(0xFFF0F0F0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF2C2C2C),
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
