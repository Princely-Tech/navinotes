import 'package:navinotes/packages.dart';

class BoardMinimalistPopupScreen extends StatelessWidget {
  BoardMinimalistPopupScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Board board = ModalRoute.of(context)?.settings.arguments as Board;

    return ChangeNotifierProvider(
      create: (context) {
        final vm = BoardEditVm(board: board, scaffoldKey: _scaffoldKey);
        vm.initialize();
        return vm;
      },
      child: Consumer<BoardEditVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            drawer: CustomDrawer(child: NavigationSideBar()),
            backgroundColor: AppTheme.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _header(),
                // _navigationSection(),
                Expanded(
                  child: ScrollableController(
                    mobilePadding: EdgeInsets.symmetric(vertical: 15),
                    tabletPadding: EdgeInsets.symmetric(vertical: 30),
                    child: vm.returnSelectedTabItem(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // spacing: 50,
                        children: [
                          _widthLimiter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 50,
                              children: [
                                // _courseTitle(),
                                // _courseActions(),
                                // _fileUploads(),

                                // _studyTemplates(),
                                // _courseTimeLine(),
                              ],
                            ),
                          ),
                          _footer(),
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
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        final courseInfo = vm.board.courseInfo;

        if (isNull(courseInfo)) {
          return const SizedBox.shrink();
        }
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
                    // _buildDetailItem('Course:', courseInfo?.title),
                    // _buildDetailItem('Instructor:', courseInfo?.instructor),
                    // _buildDetailItem(
                    //   'Email:',
                    //   courseInfo?.email,
                    //   color: const Color(0xFF3B82F6),
                    // ),
                    // _buildDetailItem('Office:', courseInfo?.location),
                    // _buildDetailItem('Office Hours:', courseInfo?.officeHours),
                    // _buildDetailItem('Phone:', courseInfo?.phone),
                    _buildDetailItem('Course: ${courseInfo?.title}'),
                    _buildDetailItem('Instructor: ${courseInfo?.instructor}'),
                    _buildDetailItem('Email: ${courseInfo?.email}'),
                    _buildDetailItem('Office: ${courseInfo?.location}'),
                    _buildDetailItem(
                      'Office Hours: ${courseInfo?.officeHours}',
                    ),
                    _buildDetailItem('Phone: ${courseInfo?.phone}'),
                  ],
                ),
                _footerItem(
                  title: 'Class Information',
                  children: [
                    _buildDetailItem('Schedule: ${courseInfo?.schedule}'),
                    _buildDetailItem('Location: ${courseInfo?.location}'),
                    _buildDetailItem('Semester: ${courseInfo?.semester}'),
                    //   SizedBox(height: 25),
                    //   Text(
                    //     'Quick Links',
                    //     style: TextStyle(
                    //       color: const Color(0xFF6B6B6B),
                    //       fontSize: 14,
                    //       fontFamily: 'Inter',
                    //       fontWeight: FontWeight.w300,
                    //     ),
                    //   ),
                    //   SizedBox(height: 16),
                    //   Row(
                    //     spacing: 15,
                    //     children:
                    //         ['Syllabus', 'Library Resources', 'Academic Calendar']
                    //             .map(
                    //               (str) => AppButton.text(
                    //                 onTap: () {},
                    //                 wrapWithFlexible: true,
                    //                 child: Flexible(
                    //                   child: Text(
                    //                     str,
                    //                     textAlign: TextAlign.center,
                    //                     style: TextStyle(
                    //                       color: const Color(0xFF00555A),
                    //                       fontSize: 14,
                    //                       fontFamily: 'Inter',
                    //                       fontWeight: FontWeight.w300,
                    //                       height: 1.43,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             )
                    //             .toList(),
                    //   ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _courseTimeLine() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        List<CourseTimeline> courseOutlines = vm.board.courseTimeLines ?? [];
        if (courseOutlines.isEmpty) {
          return SizedBox.shrink();
        }
        double maxHeight = screenHeight(context) / 2;
        return _section(
          key: vm.courseTimelineKey,
          title: 'Course Timeline',
          subTitle: 'Key events and assignments throughout the semester',
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 50),
              child: Column(
                spacing: 40,
                children:
                    courseOutlines
                        .map(
                          (item) => BoardMinimalistOutlineItem(
                            item,
                            // title: 'Week 1-2: Cell Structure & Function',
                            // status: 'In Progress',
                            // assignment: 'Assignment: Cell Structure Lab Report',
                            // dueDate: 'Due Sept 16',
                            // progress: 0.65,
                            // tags: [
                            //   'Cell Membrane',
                            //   'Cytoplasm',
                            //   'Organelles',
                            //   'Microscopy',
                            // ],
                          ),
                        )
                        .toList(),
                // children: [

                //   _buildTimelineCard(
                //     title: 'Week 3-4: Genetics & DNA',
                //     status: 'Upcoming',
                //     assignment: 'Assignment: Genetic Inheritance Quiz',
                //     dueDate: 'Due Sept 27',
                //     progress: 0.1,
                //     tags: ['DNA Structure', 'Inheritance', 'Genes', 'Mutations'],
                //   ),

                //   _buildTimelineCard(
                //     title: 'Week 5-6: Evolution & Natural Selection',
                //     status: 'Not Started',
                //     assignment: 'Assignment: Evolution Case Study',
                //     dueDate: 'Not Started',
                //     progress: 0.0,
                //     tags: [
                //       'Natural Selection',
                //       'Adaptation',
                //       'Speciation',
                //       'Fossil Record',
                //     ],
                //   ),
                // ],
              ),
            ),
          ),
        );
      },
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

  //  AppButton.secondary(
  //                     onTap: vm.goToBoardNotes,
  //                     mainAxisSize: MainAxisSize.min,
  //                     wrapWithFlexible: true,
  //                     minHeight: 40,
  //                     text: 'View All Notes',
  //                     color: const Color(0xFFF0F0F0),

  //                   )

  Widget _fileUploads() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return _section(
          title: 'File Uploads',
          subTitle: 'Essential readings and resources for your studies',
          child:
              vm.uploadedFiles.isEmpty
                  ? AppButton.secondary(
                    mainAxisSize: MainAxisSize.min,
                    onTap: () => vm.importFiles(context),
                    loading: vm.savingFiles,
                    color: const Color(0xFFF0F0F0),
                    text: 'Import Files',
                    minHeight: 40,
                    style: TextStyle(
                      color: const Color(0xFF2C2C2C),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  )
                  : ScrollableController(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 32,
                      children:
                          vm.uploadedFiles.map((file) {
                            return _buildFileCard(file);
                          }).toList(),
                      // children: [
                      //   _buildFileCard(
                      //     icon: Icons.picture_as_pdf,
                      //     title: 'Cell Structure Guide',
                      //     details: 'PDF • 2.4 MB • Uploaded Sept 8',
                      //     tag: 'Required reading',
                      //   ),

                      //   _buildFileCard(
                      //     icon: Icons.picture_as_pdf,
                      //     title: 'Genetics Research Paper',
                      //     details: 'PDF • 3.7 MB • Uploaded Sept 7',
                      //     tag: 'Supplemental reading',
                      //   ),

                      //   _buildFileCard(
                      //     icon: Icons.video_library,
                      //     title: 'Lab Procedures Video',
                      //     details: 'MP4 • 45:12 • 112 MB',
                      //     tag: 'Required viewing',
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
    required Widget child,
    String? subTitle,
    Key? key,
  }) {
    return Column(
      key: key,
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
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
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
                onTap: vm.goToBoardNotes,
              ),
              _buildActionCard(
                icon: Images.pdf,
                title: 'Import PDF',
                description: 'Add research papers and reference materials',
                actionText: 'Upload PDF →',
                loading: vm.importingPdf,
                onTap: () => vm.importPdfFile(context),
              ),
              _buildActionCard(
                icon: Images.folder,
                title: 'Import Files',
                description: 'Upload documents, images, and presentations',
                actionText: 'Add Files →',
                onTap: () => vm.importFiles(context),
                loading: vm.savingFiles,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _courseTitle() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<BoardEditVm>(
          builder: (_, vm, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore ${vm.board.name}',
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
                  getBoardDescription(vm.board),
                  // 'Discover the fundamental principles of cellular structure, function, and genetic inheritance through this comprehensive course. Develop critical thinking skills while exploring cutting-edge research in molecular biology.',
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
                      onTap: vm.goToBoardNotes,
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
                      onTap: vm.scrollToCourseTimeline,
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
                Builder(
                  builder: (context) {
                    CourseTimeline? nextSession = vm.getNextSession();
                    return Container(
                      constraints: BoxConstraints(minWidth: 384),
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFF0F0F0)),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
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
                          Text(
                            isNull(nextSession)
                                ? 'No upcoming session'
                                : formatSessionDate(nextSession!),
                            style: TextStyle(
                              color: const Color(0xFF2C2C2C),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _navigationSection() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
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
              items:
                  EditBoardTab.values.map((item) => item.toString()).toList(),
              onSelected: (value) {
                vm.updateSelectedTab(
                  stringToEnum<EditBoardTab>(value, EditBoardTab.values),
                );
              },
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
      },
    );
  }

  Widget _header() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
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
                      MenuButton(onPressed: vm.openDrawer),
                      IconButton(
                        onPressed: NavigationHelper.pop,
                        icon: Icon(
                          Icons.arrow_back,
                          color: const Color(0xFF2C2C2C),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          vm.board.name,
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
      },
    );
  }

  // Helper Widgets
  Widget _buildActionCard({
    required String icon,
    required String title,
    required String description,
    required String actionText,
    bool loading = false,
    required VoidCallback onTap,
  }) {
    return LoadingIndicator(
      loading: loading,
      child: InkWell(
        onTap: onTap,
        child: Container(
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
        ),
      ),
    );
  }

  Widget _buildFileCard(Content file) {
    return Builder(
      builder: (context) {
        return Consumer<LayoutProviderVm>(
          builder: (_, layoutVm, _) {
            return InkWell(
              onTap: () => handleOpenFile(file, context),
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF0F0F0)),
                  borderRadius: BorderRadius.circular(2),
                ),
                constraints: BoxConstraints(
                  minWidth: getDeviceResponsiveValue(
                    deviceType: layoutVm.deviceType,
                    mobile: 200,
                    tablet: 346,
                  ),
                ),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 40,
                        children: [
                          Icon(getFileIcon(file.file), size: 20),
                          //TODO return to this
                          Icon(Icons.more_vert, size: 20),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        file.title,
                        style: TextStyle(
                          color: const Color(0xFF2C2C2C),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        // details,
                        getFileDescription(file),
                        style: TextStyle(
                          color: const Color(0xFF6B6B6B),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      // SizedBox(height: 16),
                      // Text(
                      //   tag,
                      //   style: TextStyle(
                      //     color: const Color(0xFF00555A),
                      //     fontSize: 12,
                      //     fontFamily: 'Inter',
                      //     fontWeight: FontWeight.w300,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
