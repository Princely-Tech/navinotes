import 'package:navinotes/packages.dart';

class BoardDarkAcadPopupScreen extends StatelessWidget {
  const BoardDarkAcadPopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Board board = ModalRoute.of(context)?.settings.arguments as Board;
    return ChangeNotifierProvider(
      create: (context) {
        final vm = BoardEditVm(board: board);
        vm.initialize();
        return vm;
      },
      child: Consumer<BoardEditVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            drawer: CustomDrawer(child: NavigationSideBar()),
            backgroundColor: const Color(0xFFF7F3E9),
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
                      // _header(),
                      Expanded(
                        child: ScrollableController(
                          child: vm.returnSelectedTabItem(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _heroSection(),
                                _courseActions(),
                                _fileUploadsSection(),
                                _studyTemplatesSection(),
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
                                  'HISTORY 1302',
                                  style: TextStyle(
                                    color: const Color(0xFFF7F3E9),
                                    fontSize: 24,
                                    fontFamily: 'Playfair Display',
                                    fontWeight: FontWeight.w700,
                                    height: 1.33,
                                  ),
                                ),
                                Text(
                                  'Modern American History - Semester 2',
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
                          AppButton(
                            mainAxisSize: MainAxisSize.min,
                            onTap: () {},
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
                      SizedBox(height: 40),
                      Divider(color: const Color(0x19F7F3E9), height: 1),
                      SizedBox(height: 33),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 30,
                        children: [_footerItem(), _footerItem()],
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
      builder: (_, vm, _) {
        return Container(
          key: vm.courseTimelineKey,
          color: const Color(0xFF2B1810),
          padding: EdgeInsets.symmetric(vertical: 64),
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
                Column(
                  children: [
                    _buildTimelineItem(
                      isFirst: true,
                      week: 'Week 1-2',
                      title: 'Civil War & Reconstruction',
                      description:
                          'Examine the causes, course, and consequences of the American Civil War and the challenges of Reconstruction.',
                      assignment:
                          'Primary source analysis of Lincoln\'s speeches and Confederate documents',
                      dueDate: 'June 15, 2025',
                    ),
                    _buildTimelineItem(
                      week: 'Week 3-4',
                      title: 'Industrialization Era',
                      description:
                          'Study the rapid industrial growth and its impact on American society, economy, and politics.',
                      assignment:
                          'Research paper on a major industrialist and their influence on America',
                      dueDate: 'June 29, 2025',
                    ),
                    _buildTimelineItem(
                      week: 'Week 5-6',
                      title: 'Progressive Era',
                      description:
                          'Analyze the reform movements that addressed the problems created by industrialization and urbanization.',
                      assignment:
                          'Comparative analysis of progressive reforms and their effectiveness',
                      dueDate: 'July 13, 2025',
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
        return Container(
          color: const Color(0xFF2B1810),
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 40,
                right: 0,
                child: ImagePlaceHolder(
                  imagePath: Images.boardDarkAcadFileUploadBg,
                  borderRadius: BorderRadius.zero,
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
                          onTap: () {
                            vm.importFiles(context);
                          },
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

                            // children: [
                            //   _buildFileCard(
                            //     title: 'The Civil War Era',
                            //     description:
                            //         'Comprehensive analysis of the American Civil War and its aftermath.',
                            //     fileType: 'PDF • 24 MB',
                            //     icon: Icons.description,
                            //   ),
                            //   _buildFileCard(
                            //     title: 'Industrial Revolution',
                            //     description:
                            //         'The transformation of America through industrialization and its social impact.',
                            //     fileType: 'PDF • 18 MB',
                            //     icon: Icons.description,
                            //   ),

                            //   // _buildFileCard(
                            //   //   title: 'World War Lecture',
                            //   //   description:
                            //   //       'Video lecture covering American involvement in global conflicts.',
                            //   //   fileType: 'Video • 102 MB',
                            //   //   icon: Icons.video_library,
                            //   // ),
                            // ],
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
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   child: WidthLimiter(
            //     mobile: 224,
            //     child: ImagePlaceHolder(
            //       borderRadius: BorderRadius.zero,
            //       imagePath: Images.boardDarkAcadCourseActionsBg,
            //     ),
            //   ),
            // ),
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
                          onTap: vm.goToNewNoteTemplate,
                        ),
                        _buildActionCard(
                          title: 'Import PDF',
                          description:
                              'Add research papers and reference materials',
                          actionText: 'Upload PDF',
                          imageUrl: Images.boardDarkAcadImportPdf,
                          isWhite: false,
                          onTap: () => vm.importPdfFile(context),
                        ),
                        _buildActionCard(
                          title: 'Import Files',
                          description:
                              'Upload documents, images, and presentations',
                          actionText: 'Add Files',
                          imageUrl: Images.boardDarkAcadFileImport,
                          onTap: () => vm.importFiles(context),
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
                          text: 'Explore',
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
                  'Delve into the pivotal events and cultural shifts that shaped contemporary American society from the Civil War to present day.',
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
          Text(
            'Civil Rights Movement',
            style: TextStyle(
              color: const Color(0xFFC19B47),
              fontSize: 18,
              fontFamily: 'Playfair Display',
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'June 5th, 2:00 PM',
            style: TextStyle(
              color: const Color(0xB2F7F3E9),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
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
    required VoidCallback onTap,
    bool isWhite = true,
  }) {
    Color textColor =
        isWhite ? const Color(0xFF4A3426) : const Color(0xFFF7F3E9);
    return InkWell(
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
    );
  }

  Widget _buildFileCard(
    Content file,

    //   {
    //   required String title,
    //   required String description,
    //   required String fileType,
    //   required IconData icon,
    // }
  ) {
    return Container(
      width: 384,
      height: 228,
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
            child: Icon(getFileIcon(file.file), color: const Color(0xFFF7F3E9)),
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
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${getFileType(file.file)} • ${getFileSize(file.metaData[ContentMetadataKey.fileSize])}',
                style: TextStyle(
                  color: const Color(0x99F7F3E9),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                ),
              ),
              Icon(Icons.more_vert, color: const Color(0xB2F7F3E9)),
            ],
          ),
        ],
      ),
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

  Widget _timelineLeft({
    required String week,
    required String title,
    required String description,
  }) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        final textAlign = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: TextAlign.start,
          laptop: TextAlign.end,
        );
        return Column(
          crossAxisAlignment: getDeviceResponsiveValue(
            deviceType: layoutVm.deviceType,
            mobile: CrossAxisAlignment.start,
            laptop: CrossAxisAlignment.end,
          ),
          children: [
            Text(
              week,
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
              title,
              textAlign: textAlign,
              style: TextStyle(
                color: const Color(0xFFF7F3E9),
                fontSize: 24,
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
            SizedBox(height: 16),
            Text(
              description,
              textAlign: textAlign,
              style: TextStyle(
                color: const Color(0xB2F7F3E9),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _timeLineRight({required String assignment, required String dueDate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4A3426),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assignment',
                style: TextStyle(
                  color: const Color(0xFFF7F3E9),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                assignment,
                style: TextStyle(
                  color: const Color(0xB2F7F3E9),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Due: $dueDate',
                style: TextStyle(
                  color: const Color(0xFFC19B47),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timelineDivider() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VerticalDivider(width: 1, color: const Color(0x4CC19B47)),
            ],
          ),
        ),
        Center(
          child: OutlinedChild(
            size: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFC19B47),
              shape: BoxShape.circle,
            ),
            child: SVGImagePlaceHolder(
              imagePath: Images.book,
              color: const Color(0xFF2B1810),
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String week,
    required String title,
    required String description,
    required String assignment,
    required String dueDate,
    bool isFirst = false,
  }) {
    final padding = EdgeInsets.only(top: isFirst ? 0 : 40);
    return IntrinsicHeight(
      child: ResponsiveSection(
        mobile: Row(
          spacing: 30,
          children: [
            _timelineDivider(),
            Expanded(
              child: Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    _timelineLeft(
                      description: description,
                      title: title,
                      week: week,
                    ),
                    _timeLineRight(assignment: assignment, dueDate: dueDate),
                  ],
                ),
              ),
            ),
          ],
        ),
        laptop: Row(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: padding,
                child: _timelineLeft(
                  description: description,
                  title: title,
                  week: week,
                ),
              ),
            ),
            _timelineDivider(),
            Expanded(
              child: Padding(
                padding: padding,
                child: _timeLineRight(assignment: assignment, dueDate: dueDate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
