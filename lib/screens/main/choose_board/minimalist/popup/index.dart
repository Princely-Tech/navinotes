import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/date_utils.dart';
import 'package:navinotes/settings/navi_backup.dart';
import 'package:navinotes/widgets/board/timeline_edit_dialog.dart';
import 'package:navinotes/widgets/board/sync_syllabus_button.dart';

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
                _header(),
                _navigationSection(),
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
                                _courseTitle(),
                                _courseActions(),
                                _recentNotesSection(),
                                _mindMapsSection(),
                                _flashCardsDeckSection(),
                                _fileUploads(),
                                _syllabusSection(),
                                _courseTimeLine(),
                              ],
                            ),
                          ),
                          _footer(),  const SizedBox(height: 24),
                    ExportBoardButton(),
                          const SizedBox(height: 24),
                          DeleteBoardButton(),
                          const SizedBox(height: 24),
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
                children: [
                  SyncSyllabusButton(
                    board: vm.board,
                    buttonColor: const Color(0xFF00555A),
                  ),
                  ...courseOutlines
                      .asMap()
                      .entries
                      .map((entry) => BoardMinimalistOutlineItem(
                            entry.value,
                            onEdit: () => _editTimelineItem(context, vm, entry.key),
                            onDelete: () => _deleteTimelineItem(context, vm, entry.key),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
                onTap: vm.createNoteHandler,
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
              // _buildActionCard(
              //   icon: Images.trash,
              //   title: 'Delete Board',
              //   description:
              //       'Permanently delete this board, its notes, files, and flashcards',
              //   actionText: 'Delete Board →',
              //   onTap: () async {
              //     final sessionVm = Provider.of<SessionManager>(
              //       context,
              //       listen: false,
              //     );
              //     await NaviBackupService.deleteBoardWithConfirmation(
              //       context: context,
              //       board: vm.board,
              //       sessionVm: sessionVm,
              //     );
              //   },
              // ),
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
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
                    ),
                    SizedBox(width: 8),
                    Builder(
                      builder: (context) {
                        return InkWell(
                          onTap: () => _editBoardName(context),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: const Color(0xFF00555A),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        vm.board.hasDescription()
                            ? vm.board.description!
                            : 'Describe your board',
                        style: TextStyle(
                          color: const Color(0xFF6B6B6B),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          fontStyle:
                              vm.board.hasDescription()
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Builder(
                      builder: (context) {
                        return InkWell(
                          onTap: () => _editBoardDescription(context),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: const Color(0xFF00555A),
                          ),
                        );
                      },
                    ),
                  ],
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
              onTap: () => NavigationHelper.navigateToContent(file),
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

  Widget _recentNotesSection() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return FutureBuilder<List<Content>>(
          future: _getAllContents(vm.board.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox.shrink();
            }

            final allContents = snapshot.data ?? [];
            final notes =
                allContents
                    .where((content) => content.type == AppContentType.note)
                    .toList();

            // Sort by updated date (most recent first)
            notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

            return _section(
              title: 'Recent Notes',
              subTitle:
                  notes.isEmpty
                      ? 'No notes yet. Create your first note to get started.'
                      : 'Your latest notes and insights',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton.text(
                        onTap: vm.goToBoardNotes,
                        text: notes.isEmpty ? 'Create Note' : 'View All Notes',
                        style: TextStyle(
                          color: const Color(0xFF00555A),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  if (notes.isNotEmpty)
                    Column(
                      spacing: 12,
                      children:
                          notes.take(3).map((note) => _noteItem(note)).toList(),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _mindMapsSection() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return _section(
          title: 'Board Mind Map',
          subTitle: 'Visual representation of your board\'s knowledge',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton.text(
                    onTap: () => NavigationHelper.navigateToMindmap(vm.board),
                    text: 'Open Mind Map',
                    style: TextStyle(
                      color: const Color(0xFF00555A),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              // Show the board's mind map preview
              MindMapPreview(board: vm.board, height: 140),
            ],
          ),
        );
      },
    );
  }

  Widget _flashCardsDeckSection() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return FutureBuilder<List<Content>>(
          future: _getFlashCardDecks(vm.board.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox.shrink();
            }

            final flashCardDecks = snapshot.data ?? [];

            return _section(
              title: 'Flashcard Decks',
              subTitle:
                  flashCardDecks.isEmpty
                      ? 'No flashcard decks yet. Create your first deck to get started.'
                      : 'Practice and memorize key concepts',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton.text(
                        onTap: vm.createFlashCardDeck,
                        text: 'Create Deck',
                        style: TextStyle(
                          color: const Color(0xFF00555A),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  if (flashCardDecks.isNotEmpty)
                    Column(
                      spacing: 12,
                      children:
                          flashCardDecks
                              .take(3)
                              .map((deck) => _flashCardDeckItem(deck))
                              .toList(),
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

            return _section(
              title: 'Course Syllabus',
              subTitle: desc,
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: const Color(0xFF00555A),
                    text: btnText,
                    minHeight: 40,
                    style: TextStyle(
                      color: const Color(0xFF6B6B6B),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  if (syllabusContent != null)
                    Row(
                      spacing: 16,
                      children: [
                        AppButton.text(
                          onTap: () {
                            NavigationHelper.navigateToContent(syllabusContent);
                          },
                          text: 'Open Syllabus',
                          style: TextStyle(
                            color: const Color(0xFF00555A),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        AppButton.text(
                          onTap: () {
                            handleFileDownload(syllabusContent, context);
                          },
                          text: 'Download Syllabus',
                          style: TextStyle(
                            color: const Color(0xFF00555A),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _noteItem(Content note) {
    return InkWell(
      onTap: () => NavigationHelper.navigateToContent(note),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF0F0F0)),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: [
            SVGImagePlaceHolder(
              imagePath: Images.edit,
              size: 16,
              color: const Color(0xFF00555A),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title.isNotEmpty ? note.title : 'Untitled Note',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF2C2C2C),
                      fontFamily: 'Inter',
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
                      color: const Color(0xFF6B6B6B),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
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
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF0F0F0)),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: [
            SVGImagePlaceHolder(
              imagePath: Images.flashCards,
              size: 16,
              color: const Color(0xFF00555A),
            ),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF2C2C2C),
                      fontFamily: 'Inter',
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
                      color: const Color(0xFF6B6B6B),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
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

  void _editTimelineItem(BuildContext context, BoardEditVm vm, int index) {
    final timeline = vm.board.courseTimeLines![index];
    showDialog(
      context: context,
      builder: (context) => TimelineEditDialog(
        timeline: timeline,
        onSave: (updated) async {
          final courseOutlines = List<CourseTimeline>.from(vm.board.courseTimeLines ?? []);
          courseOutlines[index] = updated;
          final updatedBoard = vm.board.copyWith(
            courseTimeLines: courseOutlines,
            updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          );
          await DatabaseHelper.instance.updateBoard(updatedBoard);
          vm.updateBoard(updatedBoard);
        },
      ),
    );
  }

  void _deleteTimelineItem(BuildContext context, BoardEditVm vm, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Timeline Item'),
        content: const Text('Are you sure you want to delete this timeline item? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final courseOutlines = List<CourseTimeline>.from(vm.board.courseTimeLines ?? []);
              courseOutlines.removeAt(index);
              final updatedBoard = vm.board.copyWith(
                courseTimeLines: courseOutlines,
                updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              );
              await DatabaseHelper.instance.updateBoard(updatedBoard);
              vm.updateBoard(updatedBoard);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
