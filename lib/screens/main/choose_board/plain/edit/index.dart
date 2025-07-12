import '../../common/edit_vm.dart';
import 'package:navinotes/packages.dart';

class BoardPlainEditScreen extends StatefulWidget {
  const BoardPlainEditScreen({super.key});

  @override
  State<BoardPlainEditScreen> createState() => _BoardPlainEditScreenState();
}

class _BoardPlainEditScreenState extends State<BoardPlainEditScreen> {
  late final BoardEditVm _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BoardEditVm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the board ID from route arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && mounted) {
      final boardId = args['boardId'] as int? ?? 0;
      final showSuccess = args['showSuccess'] as bool? ?? false;
      final message = args['message'] as String?;

      _viewModel.initialize(
        boardId,
        showSuccess: showSuccess,
        message: message,
      );
    }
  }


  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<BoardEditVm>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (vm.error != null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(vm.error!)),
            );
          }

          if (vm.board == null) {
            return const Scaffold(
              body: Center(child: Text('No board data available')),
            );
          }

           // Main content
          return ScaffoldFrame(
            backgroundColor: AppTheme.white,
            body:_buildContent(vm),
          );
        },
      ),
    );
  }

  Widget _buildContent(BoardEditVm vm) {
    final board = vm.board!;
    
    return Column(
      children: [
        _header(board),
        _selectRows(),
        Expanded(
          child: ScrollableController(
            mobilePadding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ResponsivePadding(
                    mobile:  EdgeInsets.symmetric(
                      horizontal: tabletPadding,
                    ),
                    child: WidthLimiter(
                      mobile: largeDesktopSize,
                      child: Column(
                        spacing: 30,
                        children: [
                          _welcome(board),
                          _sectionCard(
                            header: 'Course Timeline',
                            color: AppTheme.lightAsh,
                            title: 'Your learning journey will bloom here',
                            body: 'After uploading your syllabus, we\'ll automatically generate a timeline of important dates, assignments, and events for your semester',
                            button: AppButton.secondary(
                              mainAxisSize: MainAxisSize.min,
                              onTap: () {},
                              color: AppTheme.strongBlue,
                              text: 'Upload syllabus to generate timeline',
                              style: const TextStyle(
                                color: Color(0xFF3B82F6),
                                fontSize: 16.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          CustomGrid(
                            children: [
                              _gridChild(
                                body:
                                    'Start here to unlock AI features',
                                btnText: 'Upload now',
                                image: Images.file2,
                                title: 'Upload Syllabus',
                                color: true,
                                onTap: () {},
                              ),
                              _gridChild(
                                body: 'Begin taking notes right away',
                                btnText: 'Create note',
                                image: Images.edit,
                                title: 'Create Note',
                               onTap: () {
                               NavigationHelper.navigateToBoardNotes(board);
                                },
                              ),
                              _gridChild(
                                body: 'Add your course materials',
                                btnText: 'Import now',
                                image: Images.folder,
                                title: 'Import Files',
                                onTap: () {},
                              ),
                            ],
                          ),
                          _sectionCard(
                            header: 'Upcoming Assignments',
                            color: AppTheme.lightAsh,
                            img: Images.menu2,
                            title:
                                'Assignment tracking will appear after syllabus upload',
                            body:
                                'We\'ll automatically identify and track all your assignments, quizzes, and exams',
                            button: AppButton.secondary(
                              mainAxisSize: MainAxisSize.min,
                              onTap: () {},
                              color: AppTheme.strongBlue,
                              text:
                                  'Upload syllabus to see assignments',
                              style: AppTheme.text.copyWith(
                                color: const Color(0xFF3B82F6),
                                fontSize: 16.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _sectionCard(
                            color: AppTheme.whiteSmoke,
                            header: 'Course Materials',
                            img: Images.ques2,
                            title:
                                'Upload and organize your study materials',
                            body: 'Drag and drop files here\nor',
                            button: AppButton(
                              mainAxisSize: MainAxisSize.min,
                              color: AppTheme.white,
                              borderColor: AppTheme.lightGray,
                              onTap: () {},
                              text: 'Browse files',
                              style: const TextStyle(
                                color: Color(0xFF1F2937),
                                fontSize: 16.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _courseInformation(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(Board board) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 10),
          Text(
            board.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Add more header actions here
        ],
      ),
    );
  }

  Widget _selectRows() {
    return TextRowSelect(
      items: ['Overview', 'Uploads', 'Assignments'],
      selected: 'Overview',
      borderColor: AppTheme.strongBlue,
      inActiveBorderColor: AppTheme.lightGray,
      padding: const EdgeInsets.symmetric(vertical: 10),
      selectedTextStyle: AppTheme.text.copyWith(
        color: const Color(0xFF3B82F6),
        fontSize: 16.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
      style: const TextStyle(
        color: Color(0xFF6B7280),
        fontSize: 16.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _welcome(Board board) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to ${board.name}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (board.description?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              board.description!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionCard({
    required String header,
    required Color color,
    required String title,
    required String body,
    required Widget button,
    String? img,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: const TextStyle(
                  fontSize: 16,
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
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              button,
            ],
          ),
        ),
      ),
    );
  }

  Widget _courseItem({required String title, required List<Widget> children}) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.graniteGray,
            fontSize: 24.0,
            fontWeight: getFontWeight(200),
            height: 1.33,
            letterSpacing: 0.60,
          ),
        ),
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ],
    );
  }

  Widget _keyVal({required String title, required String value}) {
    return Row(
      spacing: 10,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 16.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 16.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _courseInformation() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: const EdgeInsets.only(top: 20),
      child: CustomGrid(
        largeDesktop: 2,
        children: [
          _courseItem(
            title: 'Course Details',
            children: [
              _keyVal(
                title: 'Professor:',
                value: '[Will be extracted from syllabus]',
              ),
              _keyVal(
                title: 'Email:',
                value: '[Contact info will appear here]',
              ),
              _keyVal(
                title: 'Office Hours:',
                value: '[Schedule will be populated]',
              ),
              _keyVal(
                title: 'Office Location:',
                value: '[Location will be extracted]',
              ),
            ],
          ),
          _courseItem(
            title: 'Class Information',
            children: [
              _keyVal(title: 'Schedule:', value: '[Class times from syllabus]'),
              _keyVal(
                title: 'Location:',
                value: '[Classroom info will appear]',
              ),
              _keyVal(
                title: 'Duration:',
                value: '[Semester dates will populate]',
              ),
              _keyVal(
                title: 'Credits:',
                value: '[Credit hours will be extracted]',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gridChild({
    required String title,
    required String body,
    required String btnText,
    required String image,
    bool color = false,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: CustomCard(
        addBorder: true,
        decoration: BoxDecoration(
          color: color ? AppTheme.iceBlue : null,
          border: Border.all(
            color: color ? AppTheme.paleBlue : AppTheme.lightGray,
          ),
        ),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedChild(
              size: 48,
              decoration: BoxDecoration(
                color: color ? AppTheme.paleBlue : AppTheme.lightAsh,
                shape: BoxShape.circle,
              ),
              child: SVGImagePlaceHolder(
                imagePath: image,
                size: 20,
                color: color ? AppTheme.vividBlue : AppTheme.steelMist,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 18.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              body,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AppButton.text(
                onTap: onTap,
                text: btnText,
                suffix: Icon(Icons.arrow_forward, color: AppTheme.vividBlue),
                style: AppTheme.text.copyWith(
                  color: AppTheme.vividBlue,
                  fontSize: 16.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
