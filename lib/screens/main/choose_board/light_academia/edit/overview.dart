import 'package:navinotes/packages.dart';

class BoardLightAcademiaEditOverview extends StatelessWidget {
  const BoardLightAcademiaEditOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        final board = vm.board!;
        return Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return Column(
              spacing: 30,
              children: [
                _welcome(board),
                _sectionCard(
                  header: 'Course Timeline',
                  color: AppTheme.almondCream,
                  img: Images.ques2,
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
                    color: AppTheme.lightBrown,
                    text: 'Upload syllabus to generate timeline',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.lightBrown,
                      fontSize: 16.0,
                      fontFamily: AppTheme.fontEBGaramond,
                    ),
                  ),
                ),
                Column(
                  spacing: 15,
                  children: [
                    _titleSection('Quick Actions'),
                    CustomGrid(
                      children: [
                        _gridChild(
                          body: 'Start here to unlock AI features',
                          btnText: 'Upload now',
                          image: Images.scroll,
                          title: 'Upload Syllabus',
                          loading: vm.uploadingSyllabus,
                          onTap: () {
                            return vm.uploadSyllabus(
                              context: context,
                              apiServiceProvider: apiServiceProvider,
                            );
                          },
                        ),
                        _gridChild(
                          body: 'Begin taking notes right away',
                          btnText: 'Create note',
                          image: Images.leaf2,
                          title: 'Create Note',
                          onTap: () {
                            return NavigationHelper.push(
                              Routes.boardLightAcademiaNotePage,
                            );
                          },
                        ),
                        _gridChild(
                          body: 'Add your course materials',
                          btnText: 'Import now',
                          image: Images.folder,
                          title: 'Import Files',
                          loading: vm.savingFiles,
                          onTap: () {
                            return vm.importFiles(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                _sectionCard(
                  header: 'Upcoming Assignments',
                  color: AppTheme.almondCream,
                  img: Images.menu,
                  title:
                      'Assignment tracking will appear after syllabus upload',
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

                    color: AppTheme.lightBrown,
                    minHeight: 35,
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                    text: 'Upload syllabus to see assignments',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.lightBrown,
                      fontSize: 16.0,
                      fontFamily: AppTheme.fontEBGaramond,
                    ),
                  ),
                ),
                _sectionCard(
                  header: 'Course Materials',
                  img: Images.cloudUpload,
                  title: 'Upload and organize your study materials',
                  body: 'Drag and drop files here',
                  button: Column(
                    spacing: 15,
                    children: [
                      Text(
                        'or',
                        textAlign: TextAlign.center,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.burntLeather.withAlpha(0xFF),
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: AppTheme.fontEBGaramond,
                        ),
                      ),
                      AppButton.secondary(
                        mainAxisSize: MainAxisSize.min,
                        loading: vm.savingFiles,
                        onTap: () => vm.importFiles(context),
                        text: 'Browse files',
                        color: AppTheme.yellowishOrange.withAlpha(0xFF),
                        style: AppTheme.text.copyWith(
                          color: AppTheme.burntLeather.withAlpha(0xFF),
                          fontSize: 16.0,
                          fontFamily: AppTheme.fontEBGaramond,
                        ),
                      ),
                    ],
                  ),
                ),
                _courseInformation(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _titleSection(String title) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.royalGold.withAlpha(0x4C)),
        ),
      ),
      padding: EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: AppTheme.text.copyWith(
          color: AppTheme.jetCharcoal,
          fontSize: 24.0,
          fontFamily: AppTheme.fontPlayfairDisplay,
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
            color: AppTheme.jetCharcoal,
            fontSize: 20.0,
            fontFamily: AppTheme.fontPlayfairDisplay,
            height: 1.40,
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
    final style = AppTheme.text.copyWith(
      color: AppTheme.sepiaBrown,
      fontSize: 16.0,
      fontFamily: AppTheme.fontEBGaramond,
      height: 1.50,
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: title, style: style),
          TextSpan(
            text: ' $value',
            style: style.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _courseInformation() {
    return CustomCard(
      addCardShadow: true,
      decoration: BoxDecoration(
        color: AppTheme.almondCream,
        border: Border.all(color: AppTheme.royalGold.withAlpha(0x4C)),
      ),
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

  void gridChildHandler({
    required BoardEditVm vm,
    required Future<void> Function() onTap,
  }) async {
    await onTap();
    if (isNotNull(vm.board)) {
      vm.loadFiles(vm.board!.id!);
    }
  }

  Widget _gridChild({
    required String title,
    required String body,
    required String btnText,
    required String image,
    bool loading = false,
    required Future Function() onTap,
  }) {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return LoadingIndicator(
          loading: loading,
          child: InkWell(
            onTap: () => gridChildHandler(vm: vm, onTap: onTap),
            child: CustomCard(
              addCardShadow: true,
              decoration: BoxDecoration(
                color: AppTheme.ivoryCream,
                border: Border.all(color: AppTheme.royalGold.withAlpha(0x66)),
              ),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SVGImagePlaceHolder(
                    imagePath: image,
                    size: 30,
                    color: AppTheme.yellowishOrange.withAlpha(0xFF),
                  ),
                  Text(
                    title,
                    style: AppTheme.text.copyWith(
                      color: AppTheme.jetCharcoal,
                      fontSize: 20.0,
                      fontFamily: AppTheme.fontEBGaramond,
                    ),
                  ),
                  Text(
                    body,
                    style: AppTheme.text.copyWith(
                      color: AppTheme.sepiaBrown,
                      fontSize: 16.0,
                      fontFamily: AppTheme.fontEBGaramond,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: AppButton.text(
                      onTap: () => gridChildHandler(vm: vm, onTap: onTap),
                      text: '$btnText →',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.yellowishOrange.withAlpha(0xFF),
                        fontSize: 16.0,
                        fontFamily: AppTheme.fontEBGaramond,
                      ),
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

  Widget _sectionCard({
    required String title,
    required String header,
    required String body,
    required Widget button,
    Color? color,
    required String img,
  }) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleSection(header),
        CustomCard(
          addCardShadow: true,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: AppTheme.royalGold.withAlpha(0x66)),
          ),
          child: Column(
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SVGImagePlaceHolder(
                  imagePath: img,
                  size: 34,
                  color: AppTheme.burntLeather.withAlpha(0xFF),
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.text.copyWith(
                  color: AppTheme.jetCharcoal,
                  fontSize: 20.0,
                  fontFamily: AppTheme.fontEBGaramond,
                  height: 1.40,
                ),
              ),
              Text(
                body,
                textAlign: TextAlign.center,
                style: AppTheme.text.copyWith(
                  color: AppTheme.sepiaBrown,
                  fontSize: 16.0,
                  fontFamily: AppTheme.fontEBGaramond,
                  height: 1.50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: button,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _welcomeText(String boardName) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        TextAlign textAlign = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: TextAlign.center,
          desktop: TextAlign.start,
        );
        return Column(
          spacing: 30,
          crossAxisAlignment: getDeviceResponsiveValue(
            deviceType: layoutVm.deviceType,
            mobile: CrossAxisAlignment.center,
            desktop: CrossAxisAlignment.start,
          ),
          children: [
            Text(
              'Welcome to your $boardName workspace',
              textAlign: textAlign,
              style: AppTheme.text.copyWith(
                color: AppTheme.jetCharcoal,
                fontSize: getDeviceResponsiveValue(
                  deviceType: layoutVm.deviceType,
                  mobile: 25.0,
                  laptop: 30.0,
                  desktop: 35.0,
                  largeDesktop: 48,
                ),
                fontFamily: AppTheme.fontPlayfairDisplay,
                height: 1.0,
              ),
            ),
            Text(
              'Upload your syllabus to unlock AI-powered course insights',
              textAlign: textAlign,
              style: AppTheme.text.copyWith(
                color: AppTheme.sepiaBrown,
                fontSize: 18.0,
                fontFamily: AppTheme.fontEBGaramond,
                height: 1.56,
              ),
            ),
            AppButton(
              mainAxisSize: MainAxisSize.min,
              color: AppTheme.lightBrown,
              onTap: () {},
              text: 'Get Started',
              style: AppTheme.text.copyWith(
                color: AppTheme.white,
                fontSize: 18.0,
                fontFamily: AppTheme.fontEBGaramond,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _welcomeImage() {
    return WidthLimiter(
      mobile: 600,
      child: ImagePlaceHolder(
        imagePath: Images.boardLightAcadScience,
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  Widget _welcome(Board board) {
    return ResponsiveSection(
      mobile: Column(
        spacing: 50,
        children: [_welcomeText(board.name), _welcomeImage()],
      ),
      desktop: Row(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: _welcomeText(board.name)), _welcomeImage()],
      ),
    );
  }
}
