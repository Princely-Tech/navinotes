import 'dart:io';
import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/date_utils.dart';

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
                            FutureBuilder<List<Content>>(
                              future: _getAllContents(vm.board.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _heroSection(),
                                      _courseActions(),
                                      Container(
                                        height: 200,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                color: AppTheme.goldenSaffron,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Loading board contents...',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFFF7F3E9,
                                                  ),
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                final allContents = snapshot.data ?? [];
                                final notes =
                                    allContents
                                        .where(
                                          (content) =>
                                              content.type ==
                                              AppContentType.note,
                                        )
                                        .toList();
                                final mindMaps =
                                    allContents
                                        .where(
                                          (content) =>
                                              content.type ==
                                              AppContentType.mindmapNode,
                                        )
                                        .toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _heroSection(),
                                    _courseActions(),
                                    _recentNotesSection(notes),
                                    _mindMapsSection(mindMaps),
                                    _flashCardsDeckSection(vm),
                                    _fileUploadsSection(),
                                    _syllabusSection(),
                                    _courseTimeline(),
                                    _footer(),
                                  ],
                                );
                              },
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
                                      (isNull(courseInfo))
                                          ? 'Upload syllabus to get course details'
                                          : stringOrNotSpecified(
                                            courseInfo?.title,
                                            nullPrefix: 'Course name',
                                          ),

                                      style: TextStyle(
                                        color: const Color(0xFFF7F3E9),
                                        fontSize: isNull(courseInfo) ? 16 : 24,
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
                                      () => callPhoneNumber(courseInfo.phone!),
                                  text:
                                      'Contact Professor \n${courseInfo!.phone ?? ''}',
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

  Widget _syllabusSection() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            var btnText = "Upload syllabus to get AI analysis";
            var desc =
                "After uploading your syllabus, we'll automatically generate course details, a timeline of important dates, and assignments for your semester";

            if (vm.board.courseTimeLines != null) {
              btnText = "Change syllabus";
              desc =
                  "Your timeline, assignments and course details are generated from the syllabus you uploaded.";
            }

            var syllabusContent = vm.board.syllabusContent;

            return Container(
              key: vm.courseTimelineKey,

              color: const Color(0xFF2B1810),
              width: double.infinity,
              child: ResponsiveHorizontalPadding(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 64),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Course Syllabus',
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
                        desc,
                        style: TextStyle(
                          color: const Color(0xB2F7F3E9),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        spacing: 16,
                        children: [
                          AppButton(
                            mainAxisSize: MainAxisSize.min,
                            loading: vm.uploadingSyllabus,
                            onTap: () {
                              vm.uploadSyllabus(
                                context: context,
                                apiServiceProvider: apiServiceProvider,
                              );
                            },
                            color: const Color(0xFFC19B47),
                            text: btnText,
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
                          if (syllabusContent != null) ...[
                            AppButton.text(
                              onTap: () {
                                NavigationHelper.navigateToContent(
                                  syllabusContent,
                                );
                              },
                              text: 'Open Syllabus',
                              style: TextStyle(
                                color: const Color(0xFFC19B47),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            AppButton.text(
                              onTap: () {
                                handleFileDownload(syllabusContent, context);
                              },
                              text: 'Download',
                              style: TextStyle(
                                color: const Color(0xB2F7F3E9),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ],
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

  Widget _courseTimeline() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        List<CourseTimeline> courseOutlines = vm.board.courseTimeLines ?? [];
        if (courseOutlines.isEmpty) {
          return SizedBox.shrink();
        }

        return Container(
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
                Column(
                  children: [
                    for (int i = 0; i < courseOutlines.length; i++)
                      BoardDarkAcadTimelineItem(
                        courseOutlines[i],
                        isFirst: i == 0,
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
                          onTap: vm.createNoteHandler,
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
          builder: (context, vm, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: FractionallySizedBox(
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
                    ),
                    SizedBox(width: 12),
                    Builder(
                      builder: (context) {
                        return InkWell(
                          onTap: () => _editBoardName(context),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0x33C19B47),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: const Color(0xFF4A3426),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        (vm.board.hasDescription())
                            ? vm.board.description!
                            : 'Add a description for your board',
                        style: TextStyle(
                          color: const Color(0xFF4A3426),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.67,
                          fontStyle:
                              vm.board.hasDescription()
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12),
                    Builder(
                      builder: (context) {
                        return InkWell(
                          onTap: () => _editBoardDescription(context),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0x33C19B47),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: const Color(0xFF4A3426),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
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
    final metaDataSize = file.metaData[ContentMetadataKey.fileSize];
    final size = getFileSize(metaDataSize);
    final name = file.title;

    return Builder(
      builder: (context) {
        return Container(
          width: 200,
          margin: const EdgeInsets.only(right: 16),
          child: InkWell(
            onTap: () => NavigationHelper.navigateToContent(file),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A3426),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: const Color(0x33C19B47), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File preview section
                  _buildFilePreview(file),

                  // Content section
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: const Color(0xFFF7F3E9),
                            fontSize: 16,
                            fontFamily: 'Playfair Display',
                            fontWeight: FontWeight.w600,
                            height: 1.40,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          size,
                          style: TextStyle(
                            color: const Color(0x99F7F3E9),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap:
                                  () =>
                                      NavigationHelper.navigateToContent(file),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.open_in_new,
                                  color: AppTheme.goldenSaffron,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => handleFileDownload(file, context),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                child: SVGImagePlaceHolder(
                                  imagePath: Images.upload4,
                                  color: AppTheme.goldenSaffron,
                                  size: 16,
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
            ),
          ),
        );
      },
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
          color: const Color(0x33C19B47),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
        color: const Color(0x33C19B47),
      ),
      child: Center(
        child: Icon(
          getFileIcon(file.file),
          size: 48,
          color: AppTheme.goldenSaffron,
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

  Future<List<Content>> _getAllContents(String boardId) async {
    try {
      return await DatabaseHelper.instance.getAllContents(boardId);
    } catch (e) {
      debugPrint('Error fetching contents: $e');
      return [];
    }
  }

  Future<List<Content>> _getFlashCardDecks(String boardId) async {
    try {
      return await DatabaseHelper.instance.getBoardDecks(boardId);
    } catch (e) {
      debugPrint('Error fetching flashcard decks: $e');
      return [];
    }
  }

  Widget _recentNotesSection(List<Content> notes) {
    // Sort by updated date (most recent first)
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Container(
      color: const Color(0xFF2B1810),
      width: double.infinity,
      child: ResponsiveHorizontalPadding(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Notes',
                    style: TextStyle(
                      color: const Color(0xFFF7F3E9),
                      fontSize: 30,
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.w700,
                      height: 1.20,
                    ),
                  ),
                  if (notes.length > 5)
                    Consumer<BoardEditVm>(
                      builder: (context, vm, _) {
                        return AppButton.text(
                          onTap: vm.goToBoardNotes,
                          text: 'View All',
                          style: TextStyle(
                            color: AppTheme.goldenSaffron,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Your latest thoughts and discoveries',
                style: TextStyle(
                  color: const Color(0xB2F7F3E9),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              SizedBox(height: 40),
              if (notes.isEmpty)
                Column(
                  children: [
                    Text(
                      'No notes yet. Create your first note to begin your academic journey.',
                      style: TextStyle(
                        color: const Color(0x99F7F3E9),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    Consumer<BoardEditVm>(
                      builder: (context, vm, _) {
                        return AppButton(
                          mainAxisSize: MainAxisSize.min,
                          onTap: vm.createNoteHandler,
                          color: const Color(0xFFC19B47),
                          text: 'Create Note',
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
                        );
                      },
                    ),
                  ],
                )
              else
                Column(
                  spacing: 16,
                  children:
                      notes.take(5).map((note) => _noteItem(note)).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mindMapsSection(List<Content> mindMaps) {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return Container(
          color: const Color(0xFF4A3426),
          width: double.infinity,
          child: ResponsiveHorizontalPadding(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Board Mind Map',
                        style: TextStyle(
                          color: const Color(0xFFF7F3E9),
                          fontSize: 30,
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.w700,
                          height: 1.20,
                        ),
                      ),
                      AppButton.text(
                        onTap: () => NavigationHelper.navigateToMindmap(vm.board),
                        text: 'Open Mind Map',
                        style: TextStyle(
                          color: AppTheme.goldenSaffron,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Visual representation of your board\'s knowledge',
                    style: TextStyle(
                      color: const Color(0xB2F7F3E9),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Show the board's mind map preview
                  MindMapPreview(
                    board: vm.board,
                    height: 160,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _flashCardsDeckSection(BoardEditVm vm) {
    return Container(
      color: const Color(0xFF2B1810),
      width: double.infinity,
      child: ResponsiveHorizontalPadding(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 64),
          child: FutureBuilder<List<Content>>(
            future: _getFlashCardDecks(vm.board.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.goldenSaffron,
                    ),
                  ),
                );
              }

              final flashCardDecks = snapshot.data ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Flashcard Decks',
                        style: TextStyle(
                          color: const Color(0xFFF7F3E9),
                          fontSize: 30,
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.w700,
                          height: 1.20,
                        ),
                      ),
                      Consumer<BoardEditVm>(
                        builder: (context, vm, _) {
                          return AppButton.text(
                            onTap: vm.createFlashCardDeck,
                            text: 'Create Deck',
                            style: TextStyle(
                              color: AppTheme.goldenSaffron,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Test your knowledge with interactive study cards',
                    style: TextStyle(
                      color: const Color(0xB2F7F3E9),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  SizedBox(height: 40),
                  if (flashCardDecks.isEmpty)
                    Column(
                      children: [
                        Text(
                          'No flashcard decks yet. Create your first deck to enhance your learning.',
                          style: TextStyle(
                            color: const Color(0x99F7F3E9),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 24),
                        Consumer<BoardEditVm>(
                          builder: (context, vm, _) {
                            return AppButton(
                              mainAxisSize: MainAxisSize.min,
                              onTap: vm.createFlashCardDeck,
                              color: const Color(0xFFC19B47),
                              text: 'Create Deck',
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
                            );
                          },
                        ),
                      ],
                    )
                  else
                    Column(
                      spacing: 16,
                      children:
                          flashCardDecks
                              .map((deck) => _flashCardDeckItem(deck))
                              .toList(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _noteItem(Content note) {
    return InkWell(
      onTap: () => NavigationHelper.navigateToContent(note),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF4A3426),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0x33C19B47), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0x33C19B47),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Icon(Icons.note, size: 20, color: AppTheme.goldenSaffron),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title.isNotEmpty ? note.title : 'Untitled Note',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF7F3E9),
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
                      fontSize: 12,
                      fontFamily: 'Inter',
                      color: const Color(0x99F7F3E9),
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
      onTap: () => NavigationHelper.navigateToDeck(deck),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF4A3426),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0x33C19B47), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0x33C19B47),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Icon(Icons.quiz, size: 20, color: AppTheme.goldenSaffron),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deck.title.isNotEmpty
                        ? deck.title
                        : 'Untitled Flashcard Deck',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF7F3E9),
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
                      fontSize: 12,
                      fontFamily: 'Inter',
                      color: const Color(0x99F7F3E9),
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
}
