import 'package:navinotes/packages.dart';

class BoardDarkAcademiaEditOverview extends StatelessWidget {
  const BoardDarkAcademiaEditOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _pic(),
        _courseTimeLine(),
        Column(
          spacing: 50,
          children: [_actions(), _upcomingAssignment(), _coarseMaterial()],
        ),
        _footer(),
      ],
    );
  }

  Widget _footerItem({required String title, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.white,
            fontSize: 24.0,
            fontFamily: AppTheme.fontPlayfairDisplay,
            height: 1.33,
          ),
        ),
        ...items.map(
          (str) => Text(
            str,
            style: AppTheme.text.copyWith(
              color: Colors.white.withAlpha(178),
              fontSize: 16.0,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _footer() {
    return Container(
      decoration: BoxDecoration(color: AppTheme.espressoBrown),
      margin: EdgeInsets.only(top: 40),
      child: ResponsiveHorizontalPadding(
        child: ResponsivePadding(
          mobile: EdgeInsets.symmetric(vertical: mobileHorPadding),
          tablet: EdgeInsets.symmetric(vertical: laptopHorPadding),
          desktop: EdgeInsets.symmetric(vertical: desktopHorPadding),
          child: CustomGrid(
            largeDesktop: 2,
            spacing: 30,
            children: [
              _footerItem(
                title: 'Course Details',
                items: [
                  'Professor: [Will be extracted from syllabus]',
                  'Email: [Contact info will appear here]',
                  'Office Hours: [Schedule will be populated]',
                ],
              ),
              _footerItem(
                title: 'Class Information',
                items: [
                  'Schedule: [Class times from syllabus]',
                  'Location: [Classroom info will appear]',
                  'Duration: [Semester dates will populate]',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coarseMaterial() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return _section(
          title: 'Course Materials',
          child: LoadingIndicator(
            loading: vm.savingFiles,
            child: InkWell(
              onTap: () => vm.importFiles(context),
              child: Container(
                decoration: DottedDecoration(
                  color: AppTheme.espressoBrown.withAlpha(0x4C),
                  shape: Shape.box,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomCard(
                  decoration: BoxDecoration(color: AppTheme.transparent),
                  child: Column(
                    spacing: 15,
                    children: [
                      Column(
                        spacing: 5,
                        children: [
                          SVGImagePlaceHolder(
                            imagePath: Images.upload2,
                            size: 60,
                            color: AppTheme.espressoBrown.withAlpha(76),
                          ),
                          Text(
                            'Upload and organize your study materials',
                            textAlign: TextAlign.center,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.espressoBrown,
                              fontSize: 20.0,
                              height: 1.40,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Drag and drop files here',
                        textAlign: TextAlign.center,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.espressoBrown.withAlpha(0xB2),
                          fontSize: 16.0,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _upcomingAssignment() {
    return _section(
      title: 'Upcoming Assignments',
      child: CustomCard(
        child: Column(
          spacing: 10,
          children: [
            SVGImagePlaceHolder(imagePath: Images.calender3, size: 60),
            Text(
              'Assignment tracking will appear after syllabus upload',
              textAlign: TextAlign.center,
              style: AppTheme.text.copyWith(
                color: AppTheme.espressoBrown,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required Widget child, required String title}) {
    return ResponsiveHorizontalPadding(
      child: Column(
        spacing: 25,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.text.copyWith(
              color: AppTheme.espressoBrown,
              fontSize: 30.0,
              fontFamily: AppTheme.fontPlayfairDisplay,
              height: 1.20,
            ),
          ),
          child,
        ],
      ),
    );
  }

 

  Widget _actionCard({
    required String title,
    required String body,
    required String icon,
    bool loading = false,
    required Future Function() onTap,
    bool isCaramelMist = false,
  }) {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return LoadingIndicator(
          loading: loading,
          child: InkWell(
            onTap: onTap,
            child: CustomCard(
              decoration: BoxDecoration(
                color: isCaramelMist ? AppTheme.caramelMist : AppTheme.white,
                boxShadow: boxShadows,
              ),
              child: Column(
                spacing: 5,
                children: [
                  SVGImagePlaceHolder(
                    imagePath: icon,
                    size: 36,
                    color: AppTheme.espressoBrown,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTheme.text.copyWith(
                      color:
                          isCaramelMist
                              ? AppTheme.white
                              : AppTheme.espressoBrown,
                      fontSize: 24.0,
                      fontFamily: AppTheme.fontPlayfairDisplay,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      body,
                      textAlign: TextAlign.center,
                      style: AppTheme.text.copyWith(
                        color:
                            isCaramelMist
                                ? Colors.white.withAlpha(204)
                                : AppTheme.espressoBrown,
                        fontSize: 16.0,
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

  Widget _actions() {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.espressoBrown,
                      border: Border.all(color: AppTheme.transparent),
                    ),
                  ),
                ),
                ResponsiveHorizontalPadding(
                  child: CustomGrid(
                    children: [
                      _actionCard(
                        icon: Images.upload3,
                        title: 'Upload Syllabus',
                        body: 'Start here to unlock AI features',
                        isCaramelMist: true,
                        loading: vm.uploadingSyllabus,
                        onTap: () {
                          return vm.uploadSyllabus(
                            context: context,
                            apiServiceProvider: apiServiceProvider,
                          );
                        },
                      ),
                      _actionCard(
                        icon: Images.pen2,
                        title: 'Create Note',
                        body: 'Begin taking notes right away',
                        onTap: vm.goToBoardNotes,
                      ),
                      _actionCard(
                        icon: Images.folder,
                        title: 'Import Files',
                        body: 'Add your course materials',
                        loading: vm.savingFiles,
                        onTap: () {
                          return vm.importFiles(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _courseTimeLine() {
    return Consumer<ApiServiceProvider>(
      builder: (_, apiServiceProvider, _) {
        return Consumer<BoardEditVm>(
          builder: (context, vm, _) {
            return Container(
              width: double.infinity,
              color: AppTheme.espressoBrown,
              child: ResponsivePadding(
                mobile: EdgeInsets.fromLTRB(
                  mobileHorPadding,
                  20,
                  mobileHorPadding,
                  40,
                ),
                laptop: EdgeInsets.fromLTRB(
                  laptopHorPadding,
                  20,
                  laptopHorPadding,
                  50,
                ),
                desktop: EdgeInsets.fromLTRB(
                  desktopHorPadding,
                  20,
                  desktopHorPadding,
                  80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 25,
                  children: [
                    Text(
                      'Course Timeline',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.white,
                        fontSize: 30.0,
                        fontFamily: AppTheme.fontPlayfairDisplay,
                        height: 1.20,
                      ),
                    ),
                    CustomCard(
                      decoration: BoxDecoration(
                        color: AppTheme.white.withAlpha(25),
                        border: Border.all(color: AppTheme.transparent),
                      ),
                      child: Column(
                        spacing: 20,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppTheme.caramelMist,
                            size: 50,
                          ),
                          Text(
                            'Your course schedule will appear here',
                            textAlign: TextAlign.center,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.white,
                              fontSize: 20.0,
                            ),
                          ),
                          AppButton.secondary(
                            mainAxisSize: MainAxisSize.min,
                            color: AppTheme.caramelMist,
                            prefix: SVGImagePlaceHolder(
                              imagePath: Images.upload,
                              size: 16,
                              color: AppTheme.caramelMist,
                            ),
                            loading: vm.uploadingSyllabus,
                            onTap:
                                () => vm.uploadSyllabus(
                                  context: context,
                                  apiServiceProvider: apiServiceProvider,
                                ),
                            text: 'Upload syllabus to generate timeline',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.caramelMist,
                              fontSize: 16.0,
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
      },
    );
  }

  Widget _pic() {
    return Stack(
      children: [
        ResponsiveAspectRatio(
          mobile: 2.3,
          laptop: 3,
          largeDesktop: 4,
          child: ImagePlaceHolder(
            imagePath: Images.boardDarkAcadEditHeader,
            borderRadius: BorderRadius.zero,
          ),
        ),
        Positioned(
          bottom: -100,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidthLimiter(
                mobile: 300,
                child: ImagePlaceHolder(
                  imagePath: Images.boardDarkAcadPaper,
                  borderRadius: BorderRadius.zero,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
