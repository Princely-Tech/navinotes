import 'package:navinotes/packages.dart';

class BoardNaturePopupScreen extends StatelessWidget {
  BoardNaturePopupScreen({super.key});
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
            backgroundColor: vm.returnSelectedTabColor(
              const Color(0xFFF8F6F0),
              asignmentColor: const Color(0xFF2D5016),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _headerSection(),
                  vm.returnSelectedTabItem(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _heroSection(),
                        _courseActions(),
                        _fileUploadsSection(),

                        // _studyTemplateSection(),
                        _semesterJourney(),
                        _courseInfo(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _section({
    required Widget child,
    required String title,
    bool isSemester = false,
    bool isCourseInfo = false,
    double bottomPadding = 64,
  }) {
    Color textColor = const Color(0xFF2D5016);
    Color dividerColor = const Color(0xFF9CAF88).withValues(alpha: 0.5);
    String icon = Images.leaf;
    Color? iconColor;
    if (isSemester) {
      textColor = const Color(0xFFF8F6F0);
      dividerColor = Colors.white.withValues(alpha: 0.5);
      icon = Images.tree;
      iconColor = const Color(0xB2F8F6F0);
    }
    if (isCourseInfo) {
      icon = Images.plant;
      textColor = const Color(0xFFF8F6F0);
      dividerColor = const Color(0x7FF8F6F0);
      iconColor = const Color(0xB2F8F6F0);
    }
    return Container(
      padding: EdgeInsets.only(top: 64, bottom: bottomPadding),
      child: ResponsiveHorizontalPadding(
        child: Column(
          spacing: 32,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 30,
                    fontFamily: 'Crimson Text',
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
                SizedBox(width: 30),
                Expanded(child: Divider(color: dividerColor, height: 1)),
                SizedBox(width: 15),
                SVGImagePlaceHolder(
                  imagePath: icon,
                  size: 16,
                  color: iconColor,
                ),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _professorInfo() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  Icon(Icons.person, color: Colors.white),
                  Expanded(
                    child: Text(
                      'Professor Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Crimson Text',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      // image: DecorationImage(
                      //   image: NetworkImage("https://placehold.co/60x60"),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stringOrNotSpecified(
                            vm.board.courseInfo?.instructor,
                            nullPrefix: 'Professor name',
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          // 'Environmental Sciences Department',
                          stringOrNotSpecified(
                            vm.board.courseInfo?.title,
                            nullPrefix: 'Course title',
                          ),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          spacing: 4,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            Expanded(
                              child: Text(
                                'AI-populated from syllabus',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildInfoItem(Icons.email, vm.board.courseInfo?.email),
              _buildInfoItem(Icons.location_on, vm.board.courseInfo?.location),
              _buildInfoItem(Icons.schedule, vm.board.courseInfo?.schedule),
              _buildInfoItem(Icons.phone, vm.board.courseInfo?.phone),
            ],
          ),
        );
      },
    );
  }

  Widget _classInfo() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.school, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Class Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Crimson Text',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildInfoItem(
                Icons.calendar_today,
                'Schedule: ${stringOrNotSpecified(vm.board.courseInfo?.schedule)}',
              ),
              _buildInfoItem(
                Icons.room,
                'Location: ${stringOrNotSpecified(vm.board.courseInfo?.location)}',
              ),
              _buildInfoItem(
                Icons.date_range,
                'Semester: ${stringOrNotSpecified(vm.board.courseInfo?.semester)}',
              ),
              // _buildInfoItem(Icons.credit_card, 'Credits: 4 credit hours'),
              // SizedBox(height: 24),
              // Text(
              //   'Quick Links',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 16,
              //     fontFamily: 'Inter',
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // SizedBox(height: 16),
              // Wrap(
              //   spacing: 8,
              //   runSpacing: 8,
              //   children: [
              //     _buildQuickLinkButton('Syllabus', Icons.description),
              //     _buildQuickLinkButton(
              //       'Academic Calendar',
              //       Icons.calendar_month,
              //     ),
              //     _buildQuickLinkButton(
              //       'Library Resources',
              //       Icons.library_books,
              //     ),
              //   ],
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _courseInfo() {
    return Container(
      color: const Color(0xFF8B7355),
      child: _section(
        title: 'Course Information',
        isCourseInfo: true,
        child: ResponsiveSection(
          mobile: Column(
            spacing: 32,
            children: [_professorInfo(), _classInfo()],
          ),
          laptop: Row(
            spacing: 32,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _professorInfo()),
              Expanded(child: _classInfo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _semesterJourney() {
    return Consumer<ApiServiceProvider>(
      builder: (_, apiServiceProvider, _) {
        return Consumer<BoardEditVm>(
          builder: (context, vm, _) {
            List<CourseTimeline> courseOutlines =
                vm.board.courseTimeLines ?? [];
            double maxHeight = screenHeight(context) / 2;
            return Container(
              key: vm.courseTimelineKey,
              color: const Color(0xFF2D5016),
              child: _section(
                bottomPadding: 15,
                isSemester: true,
                title: 'Semester Journey',
                child: Column(
                  children: [
                    if (courseOutlines.isEmpty)
                      AppButton(
                        loading: vm.uploadingSyllabus,
                        onTap:
                            () => vm.uploadSyllabus(
                              context: context,
                              apiServiceProvider: apiServiceProvider,
                            ),
                        text: 'Upload Syllabus',
                        color: const Color(0xFF4A7C59),
                        mainAxisSize: MainAxisSize.min,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        minHeight: 40,
                        spacing: 10,
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.upload,
                          color: AppTheme.white,
                          size: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      )
                    else
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: maxHeight),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: 60),
                          child: Column(
                            children: [
                              for (int i = 0; i < courseOutlines.length; i++)
                                BoardNatureOutlineItem(i),
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
      },
    );
  }

  // Widget _studyTemplateSection() {
  //   return _section(
  //     title: 'Study Templates',
  //     child: CustomGrid(
  //       children: [
  //         _sectionCard(
  //           title: 'Observation Log',
  //           description:
  //               'Template for documenting environmental field research',
  //           lastUsed: 'Last used 3 days ago',
  //           color: const Color(0xFF2D5016),
  //           imageUrl: Images.boardNatureObservationLog,
  //         ),
  //         _sectionCard(
  //           title: 'Data Collection Sheet',
  //           description: 'Framework for assessing human impact on ecosystems',
  //           lastUsed: 'Last used 1 week ago',
  //           color: const Color(0xFF4A7C59),
  //           imageUrl: Images.boardNatureDataCollection,
  //         ),
  //         _sectionCard(
  //           title: 'Research Proposal',
  //           description:
  //               'Template for developing environmental conservation plans',
  //           lastUsed: 'Last used 2 weeks ago',
  //           color: const Color(0xFF8B7355),
  //           imageUrl: Images.boardNatureResearchPaper,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _fileUploadsSection() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.boardNatureFileUploadBg),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 64),
          child: ResponsiveHorizontalPadding(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xE5F8F6F0),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 25,
                    offset: Offset(0, 20),
                  ),
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ResponsivePadding(
                mobile: EdgeInsets.all(15),
                tablet: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 15,
                      children: [
                        Expanded(
                          child: Text(
                            'File Uploads',
                            style: TextStyle(
                              color: const Color(0xFF2D5016),
                              fontSize: 30,
                              fontFamily: 'Crimson Text',
                              fontWeight: FontWeight.w400,
                              height: 1.20,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x339CAF88),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              SVGImagePlaceHolder(
                                imagePath: Images.aiBot,
                                size: 20,
                                color: AppTheme.mossGreen,
                              ),
                              Text(
                                'AI Organized',
                                style: TextStyle(
                                  color: const Color(0xFF4A7C59),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    if (vm.uploadedFiles.isEmpty)
                      AppButton(
                        onTap: () => vm.importFiles(context),
                        loading: vm.savingFiles,
                        text: 'Import Files',
                        color: const Color(0xFF4A7C59),
                        mainAxisSize: MainAxisSize.min,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        minHeight: 40,
                        spacing: 10,
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.upload,
                          color: AppTheme.white,
                          size: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      )
                    else
                      ScrollableController(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 16,
                          children:
                              vm.uploadedFiles.map((file) {
                                return _buildFileCard(file);
                              }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _courseActions() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return _section(
          title: 'Course Actions',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomGrid(
                children: [
                  _sectionCard(
                    title: 'Create Note',
                    description:
                        'Create organized notes for your environmental studies',
                    buttonText: 'New Note',
                    color: const Color(0xFF2D5016),
                    imageUrl: Images.boardNatureCreateNote,
                    onTap: vm.goToBoardNotes,
                  ),
                  _sectionCard(
                    title: 'Import PDF',
                    description: 'Add research papers and reference materials',
                    buttonText: 'Upload PDF',
                    color: const Color(0xFF8B7355),
                    imageUrl: Images.boardNatureImportPdf,
                    onTap: () => vm.importPdfFile(context),
                    loading: vm.importingPdf,
                  ),
                  _sectionCard(
                    title: 'Import Files',
                    description: 'Upload documents, images, and presentations',
                    buttonText: 'Add Files',
                    color: const Color(0xFF9CAF88),
                    imageUrl: Images.boardNatureImportFiles,
                    onTap: () => vm.importFiles(context),
                    loading: vm.savingFiles,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _heroSection() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return Consumer<LayoutProviderVm>(
          builder: (_, layoutVm, _) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.boardNatureLandscape),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 40),
              child: ResponsiveHorizontalPadding(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 48,
                  children: [
                    WidthLimiter(
                      mobile: 800,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore ${vm.board.subject}',
                            style: TextStyle(
                              color: const Color(0xFFF8F6F0),
                              fontSize: getDeviceResponsiveValue(
                                deviceType: layoutVm.deviceType,
                                mobile: 30,
                                tablet: 35,
                                laptop: 40,
                                desktop: 48,
                              ),
                              fontFamily: 'Crimson Text',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            getBoardDescription(vm.board),
                            style: TextStyle(
                              color: const Color(0xE5F8F6F0),
                              fontSize: 20,
                              fontFamily: 'Crimson Text',
                              fontWeight: FontWeight.w400,
                              height: 1.65,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      spacing: 16,
                      children: [
                        AppButton(
                          wrapWithFlexible: true,
                          onTap: vm.goToBoardNotes,
                          text: 'View All Notes',
                          color: const Color(0xFF4A7C59),
                          mainAxisSize: MainAxisSize.min,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          minHeight: 40,
                          spacing: 10,
                          prefix: SVGImagePlaceHolder(
                            imagePath: Images.book2,
                            color: AppTheme.white,
                            size: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        AppButton(
                          wrapWithFlexible: true,
                          onTap: vm.scrollToCourseTimeline,
                          text: 'View Syllabus',
                          color: const Color(0xCC8B7355),
                          mainAxisSize: MainAxisSize.min,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          minHeight: 40,
                          spacing: 10,
                          prefix: SVGImagePlaceHolder(
                            imagePath: Images.file,
                            color: AppTheme.white,
                            size: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                      ],
                    ),

                    Builder(
                      builder: (context) {
                        CourseTimeline? nextSession = vm.getNextSession();
                        return Container(
                          width: 448,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0x33F8F6F0),
                            border: Border.all(
                              width: 1,
                              color: const Color(0x4CF8F6F0),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4A7C59),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Next Class',
                                    style: TextStyle(
                                      color: const Color(0xFFF8F6F0),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.50,
                                    ),
                                  ),
                                  if (isNull(nextSession))
                                    Text(
                                      'No Upcoming session',
                                      style: TextStyle(
                                        color: const Color(0xCCF8F6F0),
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                      ),
                                    )
                                  else
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatSessionDate(nextSession!),
                                          style: TextStyle(
                                            color: const Color(0xCCF8F6F0),
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 1.50,
                                          ),
                                        ),
                                        Text(
                                          // 'Science Complex, Room 150',
                                          nextSession.title,
                                          style: TextStyle(
                                            color: const Color(0xCCF8F6F0),
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
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _headerSection() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return Consumer<LayoutProviderVm>(
          builder: (_, layoutVm, _) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.boardNatureHeader),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  begin: Alignment(0.00, 0.50),
                  end: Alignment(1.00, 0.50),
                  colors: [const Color(0xB22D5016), const Color(0x4C2D5016)],
                ),
              ),
              child: ResponsivePadding(
                mobile: EdgeInsets.symmetric(vertical: 32),
                laptop: EdgeInsets.only(top: 32, bottom: 50),
                desktop: EdgeInsets.only(top: 32, bottom: 80),
                child: ResponsiveHorizontalPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                MenuButton(
                                  onPressed: vm.openDrawer,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8F6F0),
                                  ),
                                ),
                                AppIconButton(
                                  onPressed: NavigationHelper.pop,
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: const Color(0xFFF8F6F0),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    vm.board.name,
                                    style: TextStyle(
                                      color: const Color(0xFFF8F6F0),
                                      fontSize: getDeviceResponsiveValue(
                                        deviceType: layoutVm.deviceType,
                                        mobile: 25,
                                        laptop: 30,
                                        desktop: 36,
                                      ),
                                      fontFamily: 'Crimson Text',
                                      fontWeight: FontWeight.w400,
                                      height: 1.11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // VisibleController(
                          //   mobile: false,
                          //   tablet: true,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(left: 16),
                          //     child: Row(
                          //       children: [
                          //         Column(
                          //           crossAxisAlignment: CrossAxisAlignment.end,
                          //           children: [
                          //             Text(
                          //               stringOrNotSpecified(
                          //                 courseInfo?.instructor,
                          //                 nullPrefix: 'Instructor info',
                          //               ),
                          //               style: TextStyle(
                          //                 color: const Color(0xFFF8F6F0),
                          //                 fontSize: 16,
                          //                 fontFamily: 'Inter',
                          //                 fontWeight: FontWeight.w500,
                          //                 height: 1.50,
                          //               ),
                          //             ),
                          //             Text(
                          //               stringOrNotSpecified(
                          //                 courseInfo?.instructor,
                          //                 nullPrefix: 'Campus location',
                          //               ),
                          //               style: TextStyle(
                          //                 color: const Color(0xFFF8F6F0),
                          //                 fontSize: 14,
                          //                 fontFamily: 'Inter',
                          //                 fontWeight: FontWeight.w400,
                          //                 height: 1.43,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         SizedBox(width: 16),
                          //         Container(
                          //           width: 40,
                          //           height: 40,
                          //           decoration: BoxDecoration(
                          //             border: Border.all(
                          //               width: 2,
                          //               color: const Color(0xFFF8F6F0),
                          //             ),
                          //             borderRadius: BorderRadius.circular(9999),
                          //             image: DecorationImage(
                          //               image: NetworkImage(
                          //                 "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          //               ),
                          //               fit: BoxFit.cover,
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // SizedBox(height: 60),
                      Text(
                        'Semester 1',
                        style: TextStyle(
                          color: const Color(0xE5F8F6F0),
                          fontSize: 20,
                          fontFamily: 'Crimson Text',
                          fontWeight: FontWeight.w400,
                          height: 1.40,
                        ),
                      ),
                      SizedBox(height: 25),
                      // SizedBox(height: 16),
                      TextRowSelect(
                        onSelected: (value) {
                          vm.updateSelectedTab(
                            stringToEnum<EditBoardTab>(
                              value,
                              EditBoardTab.values,
                            ),
                          );
                        },
                        items:
                            EditBoardTab.values
                                .map((item) => item.toString())
                                .toList(),
                        borderColor: const Color(0xFFF8F6F0),
                        selectedTextStyle: TextStyle(
                          color: const Color(0xFFF8F6F0),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        style: TextStyle(
                          color: const Color(0xB2F8F6F0),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
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

  Widget _sectionCard({
    required String title,
    required String description,
    String? buttonText,
    String? lastUsed,
    required Color color,
    required String imageUrl,
    bool loading = false,
    required VoidCallback onTap,
  }) {
    return LoadingIndicator(
      loading: loading,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0x339CAF88)),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 5 / 2,
                    child: ImagePlaceHolder(
                      imagePath: imageUrl,
                      isCardHeader: true,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            color.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontFamily: 'Crimson Text',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: const Color(0xFF4B5563),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (isNotNull(lastUsed))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              lastUsed!,
                              style: TextStyle(
                                color: color,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward, color: color),
                        ],
                      ),
                    if (isNotNull(buttonText))
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              buttonText!,
                              style: TextStyle(
                                color: color,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward, color: color),
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

  Widget _buildFileCard(Content file) {
    Color color = getRandomListElement<Color>([
      const Color(0xFF2D5016),
      const Color(0xFF4A7C59),
      const Color(0xFF8B7355),
    ]);
    return Builder(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 56,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(getFileIcon(file.file), color: color),
                      ),
                      SizedBox(width: 16),
                      Text(
                        file.title,
                        style: TextStyle(
                          color: color,
                          fontSize: 20,
                          fontFamily: 'Crimson Text',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  // WidthLimiter(
                  //   mobile: 250,
                  //   child: Text(
                  //     description,
                  //     style: TextStyle(
                  //       color: const Color(0xFF4B5563),
                  //       fontSize: 16,
                  //       fontFamily: 'Inter',
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //   ),
                  // ),
                  Row(
                    spacing: 30,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Flexible(
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: 12,
                      //       vertical: 4,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: color.withValues(alpha: 0.2),
                      //       borderRadius: BorderRadius.circular(9999),
                      //     ),
                      //     child: Text(
                      //       tag,
                      //       style: TextStyle(
                      //         color: color,
                      //         fontSize: 14,
                      //         fontFamily: 'Inter',
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Text(
                        getFileDescription(file),
                        style: TextStyle(
                          color: const Color(0xFF4B5563),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () => handleFileDownload(file, context),
                        child: SVGImagePlaceHolder(
                          imagePath: Images.upload4,
                          size: 16,
                          color: AppTheme.mossGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String? text) {
    bool isPhone = icon == Icons.phone;
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.8)),
          SizedBox(width: 8),
          Flexible(
            child: InkWell(
              onTap: isPhone ? () => callPhoneNumber(text!) : null,
              child: Text(
                stringOrNotSpecified(text),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: isPhone ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinkButton(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x4C4A7C59),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
