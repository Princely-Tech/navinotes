import 'package:navinotes/packages.dart';

class BoardDarkAcadPopupScreen extends StatelessWidget {
  BoardDarkAcadPopupScreen({super.key});
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
              const Color(0xFFF7F3E9),
              asignmentColor: const Color(0xFF2B1810),
            ),
            body: Row(
              children: [
                VisibleController(
                  mobile: false,
                  largeDesktop: true,
                  child: NavigationSideBar(shrinkWrap: true),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _header(),
                      Expanded(
                        child: ScrollableController(
                          child: vm.returnSelectedTabItem(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _heroSection(),
                                _courseActions(),
                                _fileUploadsSection(),

                                // _studyTemplatesSection(),
                                _courseTimeline(),
                                _footer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        final courseInfo = vm.board.courseInfo;

        if (isNull(courseInfo)) {
          return const SizedBox.shrink();
        }

        return Consumer<LayoutProviderVm>(
          builder: (_, layoutVm, _) {
            return Container(
              color: const Color(0xFF4A3426),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Opacity(
                        opacity: getDeviceResponsiveValue(
                          deviceType: layoutVm.deviceType,
                          mobile: 0.3,
                          desktop: 1,
                        ),
                        child: ImagePlaceHolder(
                          imagePath: Images.boardDarkAcadBook,
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: ResponsiveHorizontalPadding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 15,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stringOrNotSpecified(
                                        courseInfo?.title,
                                        nullPrefix: 'Course name',
                                      ),

                                      style: TextStyle(
                                        color: const Color(0xFFF7F3E9),
                                        fontSize: 24,
                                        fontFamily: 'Playfair Display',
                                        fontWeight: FontWeight.w700,
                                        height: 1.33,
                                      ),
                                    ),
                                    Text(
                                      // 'Modern American History - Semester 2',
                                      courseInfo?.semester ?? '',
                                      style: TextStyle(
                                        color: const Color(0xB2F7F3E9),
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isNotNull(courseInfo?.phone))
                                AppButton(
                                  mainAxisSize: MainAxisSize.min,
                                  onTap:
                                      () => callPhoneNumber(courseInfo!.phone!),
                                  text: 'Contact Professor',
                                  color: const Color(0xFFC19B47),
                                  minHeight: 40,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  style: TextStyle(
                                    color: const Color(0xFF2B1810),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                          // SizedBox(height: 40),
                          // Divider(color: const Color(0x19F7F3E9), height: 1),
                          // SizedBox(height: 33),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   spacing: 30,
                          //   children: [_footerItem(), _footerItem()],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _footerItem() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Links',
            style: TextStyle(
              color: const Color(0xFFC19B47),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Course Syllabus',
            style: TextStyle(
              color: const Color(0xB2F7F3E9),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Academic Calendar',
            style: TextStyle(
              color: const Color(0xB2F7F3E9),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Library Resources',
            style: TextStyle(
              color: const Color(0xB2F7F3E9),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }

  Widget _courseTimeline() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        List<CourseTimeline> courseOutlines = vm.board.courseTimeLines ?? [];
        if (courseOutlines.isEmpty) {
          return SizedBox.shrink();
        }
        double maxHeight = screenHeight(context) / 2;

        return Container(
          key: vm.courseTimelineKey,
          color: const Color(0xFF2B1810),
          padding: EdgeInsets.only(top: 64),
          child: ResponsiveHorizontalPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Course Timeline',
                  style: TextStyle(
                    color: const Color(0xFFF7F3E9),
                    fontSize: 30,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Key events and assignments throughout the semester',
                  style: TextStyle(
                    color: const Color(0xB2F7F3E9),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 40),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Column(
                      children: [
                        for (int i = 0; i < courseOutlines.length; i++)
                          BoardDarkAcadTimelineItem(
                            courseOutlines[i],
                            isFirst: i == 0,
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

  Widget _studyTemplatesSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveHorizontalPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Study Templates',
              style: TextStyle(
                color: const Color(0xFF4A3426),
                fontSize: 30,
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w700,
                height: 1.20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Professional formats for your historical analysis',
              style: TextStyle(
                color: const Color(0xB24A3426),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
            SizedBox(height: 40),
            CustomGrid(
              spacing: 32,
              children: [
                _buildTemplateCard(
                  title: 'Research Paper',
                  description:
                      'Formal academic structure with citation guidelines',
                  lastUsed: '2 days ago',
                  imageUrl: Images.boardDarkAcadResearchPaper,
                ),

                _buildTemplateCard(
                  title: 'Critical Analysis',
                  description: 'Framework for evaluating historical sources',
                  lastUsed: '1 week ago',
                  imageUrl: Images.boardDarkAcadAnalysis,
                ),

                _buildTemplateCard(
                  title: 'Comparative Study',
                  description:
                      'Template for comparing historical events or figures',
                  lastUsed: '3 weeks ago',
                  imageUrl: Images.boardDarkAcadStudy,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fileUploadsSection() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return Consumer<LayoutProviderVm>(
          builder: (_, layoutVm, _) {
            return Container(
              color: const Color(0xFF2B1810),
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 40,
                    right: 0,
                    child: Opacity(
                      opacity: getDeviceResponsiveValue(
                        deviceType: layoutVm.deviceType,
                        mobile: 0.3,
                        tablet: 1,
                      ),
                      child: ImagePlaceHolder(
                        imagePath: Images.boardDarkAcadFileUploadBg,
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  ResponsiveHorizontalPadding(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 64),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'File Uploads',
                            style: TextStyle(
                              color: const Color(0xFFF7F3E9),
                              fontSize: 30,
                              fontFamily: 'Playfair Display',
                              fontWeight: FontWeight.w700,
                              height: 1.20,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Essential readings and resources for your studies',
                            style: TextStyle(
                              color: const Color(0xB2F7F3E9),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          SizedBox(height: 40),
                          if (vm.uploadedFiles.isEmpty)
                            AppButton(
                              mainAxisSize: MainAxisSize.min,
                              onTap: () => vm.importFiles(context),
                              loading: vm.savingFiles,
                              color: const Color(0xFFC19B47),
                              text: 'Import Files',
                              minHeight: 40,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                              style: TextStyle(
                                color: const Color(0xFF2B1810),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            ScrollableController(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 32,
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _courseActions() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: WidthLimiter(
                mobile: 224,
                child: ImagePlaceHolder(
                  borderRadius: BorderRadius.zero,
                  imagePath: Images.boardDarkAcadCourseActionsBg,
                ),
              ),
            ),
            VisibleController(
              mobile: false,
              desktop: true,
              child: Positioned(
                top: -100,
                left: 0,
                right: 0,
                child: Center(
                  child: WidthLimiter(
                    mobile: 224,
                    child: ImagePlaceHolder(
                      size: 268,
                      borderRadius: BorderRadius.zero,
                      imagePath: Images.boardDarkAcadKro,
                    ),
                  ),
                ),
              ),
            ),
            VisibleController(
              mobile: false,
              largeDesktop: true,
              child: Positioned(
                top: -200,
                bottom: -15,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: ImagePlaceHolder(
                        borderRadius: BorderRadius.zero,
                        imagePath: Images.boardDarkAcadFave,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: ResponsiveHorizontalPadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Actions',
                      style: TextStyle(
                        color: const Color(0xFF4A3426),
                        fontSize: 30,
                        fontFamily: 'Playfair Display',
                        fontWeight: FontWeight.w700,
                        height: 1.20,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Access and manage your course materials efficiently',
                      style: TextStyle(
                        color: const Color(0xB24A3426),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(height: 40),
                    CustomGrid(
                      spacing: 32,
                      children: [
                        _buildActionCard(
                          title: 'Create Note',
                          description:
                              'Document your insights and research findings',
                          actionText: 'New Note',
                          imageUrl: Images.boardDarkAcadCreateNote,
                          onTap: vm.goToBoardNotes,
                        ),
                        _buildActionCard(
                          title: 'Import PDF',
                          description:
                              'Add research papers and reference materials',
                          actionText: 'Upload PDF',
                          imageUrl: Images.boardDarkAcadImportPdf,
                          isWhite: false,
                          loading: vm.importingPdf,
                          onTap: () => vm.importPdfFile(context),
                        ),
                        _buildActionCard(
                          title: 'Import Files',
                          description:
                              'Upload documents, images, and presentations',
                          actionText: 'Add Files',
                          imageUrl: Images.boardDarkAcadFileImport,
                          onTap: () => vm.importFiles(context),
                          loading: vm.savingFiles,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _heroSection() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.boardDarkAcadPopupHeader),
              fit: BoxFit.cover,
            ),
          ),
          child: ResponsiveHorizontalPadding(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: getDeviceResponsiveValue(
                    deviceType: layoutVm.deviceType,
                    largeDesktop: 70,
                    mobile: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: 0.8,
                          child: ResponsiveAspectRatio(
                            mobile: 1,
                            child: Opacity(
                              opacity: getDeviceResponsiveValue(
                                deviceType: layoutVm.deviceType,
                                mobile: 0.1,
                                tablet: 1,
                              ),
                              child: ImagePlaceHolder(
                                borderRadius: BorderRadius.zero,
                                imagePath: Images.boardDarkAcadbgPapers,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ResponsivePadding(
                  mobile: EdgeInsets.symmetric(vertical: 60),
                  laptop: EdgeInsets.symmetric(vertical: 100),
                  desktop: EdgeInsets.symmetric(vertical: 120),
                  child: ResponsiveSection(
                    mobile: Column(
                      spacing: 30,
                      children: [_titleSection(), _nextSession()],
                    ),
                    tablet: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: WidthLimiter(
                            mobile: 600,
                            child: _titleSection(),
                          ),
                        ),
                        _nextSession(),
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

  Widget _titleSection() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<BoardEditVm>(
          builder: (_, vm, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: getDeviceResponsiveValue(
                    deviceType: layoutVm.deviceType,
                    mobile: 0.7,
                    desktop: 1,
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: vm.board.name,
                          style: TextStyle(
                            color: const Color(0xFF4A3426),
                            fontSize: getDeviceResponsiveValue(
                              deviceType: layoutVm.deviceType,
                              mobile: 60,
                              tablet: 75,
                              desktop: 96,
                            ),
                            fontFamily: 'Luxurious Script',
                            fontWeight: FontWeight.w400,
                            height: 0.50,
                          ),
                        ),
                        TextSpan(
                          text: ' ${vm.board.subject}',
                          style: TextStyle(
                            color: const Color(0xFF4A3426),
                            // fontSize: 48,
                            fontSize: getDeviceResponsiveValue(
                              deviceType: layoutVm.deviceType,
                              mobile: 30,
                              tablet: 35,
                              desktop: 48,
                            ),
                            fontFamily: 'Playfair Display',
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  //TODO check this
                  '${vm.board.level}',
                  style: TextStyle(
                    color: const Color(0xFF4A3426),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  spacing: 16,
                  children: [
                    AppButton(
                      mainAxisSize: MainAxisSize.min,
                      onTap: vm.goToBoardNotes,
                      color: const Color(0xFFC19B47),
                      text: 'View All Notes',
                      minHeight: 40,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      style: TextStyle(
                        color: const Color(0xFF2B1810),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    AppButton.secondary(
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
      builder: (context, vm, _) {
        CourseTimeline? nextSession = vm.getNextSession();
        // if (isNull(nextSession)) return SizedBox.shrink();
        return CustomCard(
          width: null,
          addCardShadow: true,
          decoration: BoxDecoration(
            color: const Color(0xFF4A3426),
            borderRadius: BorderRadius.circular(2),
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                'Next session:',
                style: TextStyle(
                  color: const Color(0xFFF7F3E9),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isNull(nextSession))
                Text(
                  'No upcoming session',
                  style: TextStyle(
                    color: const Color(0xFFC19B47),
                    fontSize: 18,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w400,
                  ),
                )
              else
                Column(
                  children: [
                    Text(
                      nextSession!.title,
                      style: TextStyle(
                        color: const Color(0xFFC19B47),
                        fontSize: 18,
                        fontFamily: 'Playfair Display',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      // 'June 5th, 2:00 PM',
                      formatSessionDate(nextSession),
                      style: TextStyle(
                        color: const Color(0xB2F7F3E9),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _header() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<BoardEditVm>(
          builder: (_, vm, _) {
            return Container(
              color: const Color(0xFF2B1810),
              padding: EdgeInsets.symmetric(vertical: 15),
              child: ResponsiveHorizontalPadding(
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              VisibleController(
                                mobile: true,
                                largeDesktop: false,
                                child: MenuButton(
                                  onPressed: vm.openDrawer,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F3E9),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: NavigationHelper.pop,
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: const Color(0xFFF7F3E9),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  vm.board.name,
                                  style: TextStyle(
                                    color: const Color(0xFFF7F3E9),
                                    fontSize: getDeviceResponsiveValue(
                                      deviceType: layoutVm.deviceType,
                                      mobile: 18,
                                      tablet: 22,
                                      laptop: 25,
                                      desktop: 30,
                                    ),
                                    fontFamily: 'Playfair Display',
                                    fontWeight: FontWeight.w600,
                                    height: 1.20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ProfilePic(),
                      ],
                    ),

                    TextRowSelect(
                      items:
                          EditBoardTab.values
                              .map((item) => item.toString())
                              .toList(),
                      borderColor: const Color(0xFFC19B47),
                      selectedTextStyle: TextStyle(
                        color: const Color(0xFFC19B47),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      style: TextStyle(
                        color: const Color(0xCCF7F3E9),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      onSelected: (value) {
                        vm.updateSelectedTab(
                          stringToEnum<EditBoardTab>(
                            value,
                            EditBoardTab.values,
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

  // Helper Widgets
  Widget _buildActionCard({
    required String title,
    required String description,
    required String actionText,
    required String imageUrl,
    bool isWhite = true,
    bool loading = false,
    required VoidCallback onTap,
  }) {
    Color textColor =
        isWhite ? const Color(0xFF4A3426) : const Color(0xFFF7F3E9);
    return LoadingIndicator(
      loading: loading,
      child: InkWell(
        onTap: onTap,
        child: CustomCard(
          width: null,
          addCardShadow: true,
          decoration: BoxDecoration(
            color: isWhite ? AppTheme.white : const Color(0xFF4A3426),
            borderRadius: BorderRadius.circular(2),
          ),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 5 / 2,
                child: ImagePlaceHolder(
                  imagePath: imageUrl,
                  isCardHeader: true,
                  borderRadius: BorderRadius.circular(0),
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontFamily: 'Playfair Display',
                        fontWeight: FontWeight.w600,
                        height: 1.40,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      spacing: 8,
                      children: [
                        Flexible(
                          child: Text(
                            actionText,
                            style: TextStyle(
                              color: const Color(0xFFC19B47),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: const Color(0xFFC19B47),
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

  Widget _buildFileCard(Content file) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () => handleOpenFile(file, context),
          child: Container(
            // constraints: BoxConstraints(maxWidth: 400),

            // width: 384,
            // height: 228,
            decoration: BoxDecoration(
              color: const Color(0xFF4A3426),
              borderRadius: BorderRadius.circular(2),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0x33C19B47),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Icon(
                    getFileIcon(file.file),
                    color: AppTheme.goldenSaffron,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  file.title,
                  style: TextStyle(
                    color: const Color(0xFFF7F3E9),
                    fontSize: 20,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w600,
                    height: 1.40,
                  ),
                ),
                SizedBox(height: 8),
                // Text(
                //   description,
                //   style: TextStyle(
                //     color: const Color(0xB2F7F3E9),
                //     fontSize: 14,
                //     fontFamily: 'Inter',
                //     fontWeight: FontWeight.w400,
                //     height: 1.43,
                //   ),
                // ),
                // Spacer(),
                Row(
                  spacing: 50,
                  children: [
                    Text(
                      getFileDescription(file),
                      style: TextStyle(
                        color: const Color(0x99F7F3E9),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                    ),
                    InkWell(
                      onTap: () => handleFileDownload(file, context),
                      child: SVGImagePlaceHolder(
                        imagePath: Images.upload4,
                        color: AppTheme.goldenSaffron,
                        size: 16,
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

  Widget _buildTemplateCard({
    required String title,
    required String description,
    required String lastUsed,
    required String imageUrl,
  }) {
    return CustomCard(
      addCardShadow: true,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 5 / 2,
            child: ImagePlaceHolder(
              imagePath: imageUrl,
              borderRadius: BorderRadius.zero,
            ),
          ),
          Container(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF4A3426),
                    fontSize: 20,
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.w600,
                    height: 1.40,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: const Color(0xB24A3426),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      size: 12,
                      color: const Color(0x994A3426),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Last used $lastUsed',
                      style: TextStyle(
                        color: const Color(0x994A3426),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
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
}
