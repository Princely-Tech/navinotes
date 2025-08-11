import 'package:navinotes/packages.dart';

class BoardPlainEditOverview extends StatelessWidget {
  const BoardPlainEditOverview(this.vm, {super.key});
  final BoardEditVm vm;
  @override
  Widget build(BuildContext context) {
    final board = vm.board!;
    return Consumer<ApiServiceProvider>(
      builder: (_, apiServiceProvider, _) {
        return Column(
          spacing: 30,
          children: [
            _welcome(board),
            _sectionCard(
              header: 'Course Timeline',
              color: AppTheme.lightAsh,
              title: 'Your learning journey will bloom here',
              body:
                  'After uploading your syllabus, we\'ll automatically generate a timeline of important dates, assignments, and events for your semester',
              button: AppButton.secondary(
                mainAxisSize: MainAxisSize.min,
                loading: vm.uploadingSyllabus,
                onTap: () {
                  vm.uploadSyllabus(
                    context: context,
                    apiServiceProvider: apiServiceProvider,
                  );
                },
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
                LoadingIndicator(
                  loading: vm.uploadingSyllabus,
                  child: _gridChild(
                    body: 'Start here to unlock AI features',
                    btnText: 'Upload now',
                    image: Images.file2,
                    title: 'Upload Syllabus',
                    color: true,
                    onTap: () {
                      vm.uploadSyllabus(
                        context: context,
                        apiServiceProvider: apiServiceProvider,
                      );
                    },
                  ),
                ),
                _gridChild(
                  body: 'Begin taking notes right away',
                  btnText: 'Create note',
                  image: Images.edit,
                  title: 'Create Note',
                  onTap: vm.createNoteHandler,
                ),
                LoadingIndicator(
                  loading: vm.savingFiles,
                  child: _gridChild(
                    body: 'Add your course materials',
                    btnText: 'Import now',
                    image: Images.folder,
                    title: 'Import Files',
                    onTap: () => vm.importFiles(context),
                  ),
                ),
              ],
            ),
            _sectionCard(
              header: 'Upcoming Assignments',
              color: AppTheme.lightAsh,
              img: Images.menu2,
              title: 'Assignment tracking will appear after syllabus upload',
              body:
                  'We\'ll automatically identify and track all your assignments, quizzes, and exams',
              button: AppButton.secondary(
                mainAxisSize: MainAxisSize.min,
                loading: vm.uploadingSyllabus,
                onTap:
                    () => vm.uploadSyllabus(
                      context: context,
                      apiServiceProvider: apiServiceProvider,
                    ),
                color: AppTheme.strongBlue,
                text: 'Upload syllabus to see assignments',
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
              title: 'Upload and organize your study materials',
              body: 'Drag and drop files here\nor',
              button: AppButton(
                mainAxisSize: MainAxisSize.min,
                color: AppTheme.white,
                borderColor: AppTheme.lightGray,
                onTap: () => vm.importFiles(context),
                loading: vm.savingFiles,
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
        );
      },
    );
  }

  Widget _welcome(Board board) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to ${board.name}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (board.description?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              board.description!,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
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
