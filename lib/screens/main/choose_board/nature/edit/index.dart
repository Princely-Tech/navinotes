import '../../common/edit_vm.dart';
import 'package:navinotes/packages.dart';

class BoardNatureEditScreen extends StatefulWidget {
  const BoardNatureEditScreen({super.key});

  @override
  State<BoardNatureEditScreen> createState() => _BoardNatureEditScreenState();
}

class _BoardNatureEditScreenState extends State<BoardNatureEditScreen> {
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

      _viewModel.initialize(boardId);
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
            backgroundColor: AppTheme.softLinen,
            body: _buildContent(vm),
          );
        },
      ),
    );
  }

  Column _buildContent(BoardEditVm vm) {
    final board = vm.board!;

    return Column(
      children: [
        _header(board),
        _selectRows(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, 0.50),
                end: Alignment(1.00, 0.50),
                colors: [
                  AppTheme.dustyOlive.withAlpha(0x4C),
                  AppTheme.softLinen,
                ],
              ),
            ),
            child: ScrollableController(
              mobilePadding: EdgeInsets.only(top: tabletPadding),
              tabletPadding: EdgeInsets.only(top: tabletPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: WidthLimiter(
                      mobile: largeDesktopSize,
                      child: Column(
                        spacing: 50,
                        children: [
                          ResponsivePadding(
                            mobile: EdgeInsets.symmetric(
                              horizontal: tabletPadding,
                            ),
                            tablet: EdgeInsets.symmetric(
                              horizontal: tabletPadding,
                            ),
                            child: Column(
                              spacing: 30,
                              children: [
                                _welcome(board),
                                _customCardSection(
                                  header: _aiSection(title: 'Course Timeline'),
                                  title:
                                      'Your learning journey will bloom here',
                                  body:
                                      'After uploading your syllabus, we\'ll automatically generate a timeline of important dates, assignments, and events for your semester',
                                  button: AppButton.text(
                                    onTap: () {},
                                    prefix: SVGImagePlaceHolder(
                                      imagePath: Images.upload,
                                      size: 16,
                                      color: AppTheme.sageMist,
                                    ),
                                    text:
                                        'Upload syllabus to generate timeline',
                                    style: AppTheme.text.copyWith(
                                      color: AppTheme.sageMist,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                CustomGrid(
                                  children: [
                                    _gridChild(
                                      body:
                                          'Start here to unlock AI features and organize your course automatically',
                                      btnText: 'Upload now',
                                      color: AppTheme.sageMist,
                                      image: Images.uploadFile,
                                      title: 'Upload Syllabus',
                                    ),
                                    _gridChild(
                                      body:
                                          'Begin taking notes right away with our nature-inspired note templates',
                                      btnText: 'Create note',
                                      color: AppTheme.walnutBronze,
                                      image: Images.edit,
                                      title: 'Create Note',
                                      route: Routes.boardNatureNotePage,
                                    ),
                                    _gridChild(
                                      body:
                                          'Add your course materials, readings, and research documents',
                                      btnText: 'Import now',
                                      color: AppTheme.mossGreen,
                                      image: Images.folder,
                                      title: 'Import Files',
                                    ),
                                  ],
                                ),

                                _customCardSection(
                                  header: _aiSection(
                                    title: 'Upcoming Assignments',
                                    img: Images.menu2,
                                  ),
                                  img: Images.checkRect,
                                  title: 'Track your academic growth',
                                  body:
                                      'We\'ll automatically identify and track all your assignments, quizzes, and exams after you upload your syllabus',
                                  button: AppButton.text(
                                    onTap: () {},
                                    prefix: SVGImagePlaceHolder(
                                      imagePath: Images.upload,
                                      size: 16,
                                      color: AppTheme.sageMist,
                                    ),
                                    text: 'Upload syllabus to see assignments',
                                    style: AppTheme.text.copyWith(
                                      color: AppTheme.sageMist,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                _customCardSection(
                                  header: _aiSection(
                                    title: 'Course Materials',
                                    img: Images.book,
                                    isAi: false,
                                  ),
                                  color: AppTheme.white.withAlpha(128),
                                  img: Images.upload2,
                                  title: 'Cultivate your resource library',
                                  body:
                                      'Drag and drop files here to upload and organize your study materials',
                                  button: AppButton.secondary(
                                    mainAxisSize: MainAxisSize.min,
                                    color: AppTheme.sageMist,
                                    onTap: () {},
                                    minHeight: 35,
                                    prefix: SVGImagePlaceHolder(
                                      imagePath: Images.folder,
                                      size: 16,
                                      color: AppTheme.sageMist,
                                    ),
                                    text: 'Browse files',
                                  ),
                                ),
                                _courseInformation(),
                                Column(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      'Upload your syllabus to complete your academic ecosystem',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.text.copyWith(
                                        fontSize: 20.0,
                                        height: 1.40,
                                      ),
                                    ),
                                    AppButton(
                                      mainAxisSize: MainAxisSize.min,
                                      color: AppTheme.sageMist,
                                      onTap: () {},
                                      text: 'Upload Syllabus',
                                      prefix: SVGImagePlaceHolder(
                                        imagePath: Images.upload,
                                        size: 16,
                                        color: AppTheme.white,
                                      ),
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      'Nurture your learning journey with organized, AI-powered insights',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.steelMist,
                                        fontSize: 16.0,
                                        height: 1.50,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _footer(board),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _footer(Board board) {
    return Container(
      color: const Color(0x339CAF88),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      child: Text(
        '${board.name} - ${board.subject} ${board.term}',
        textAlign: TextAlign.center,
        style: AppTheme.text.copyWith(
          color: AppTheme.stormGray,
          fontSize: 16.0,
          height: 1.50,
        ),
      ),
    );
  }

  Widget _aiPowered({bool isExtracted = false}) {
    Color color = isExtracted ? AppTheme.walnutBronze : AppTheme.sageMist;
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(0x33),
        borderRadius: BorderRadius.circular(9999),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          SVGImagePlaceHolder(imagePath: Images.robot, size: 16, color: color),
          Text(
            isExtracted ? 'AI-Extracted' : 'AI-Powered',
            style: AppTheme.text.copyWith(color: color, fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  Widget _courseItemHeader({required String title, String? img}) {
    return Row(
      spacing: 10,
      children: [
        if (isNotNull(img))
          SVGImagePlaceHolder(imagePath: img!, size: 20)
        else
          Icon(Icons.calendar_month, size: 20, color: AppTheme.walnutBronze),
        Text(
          title,
          style: AppTheme.text.copyWith(fontSize: 18.0, height: 1.56),
        ),
        _aiPowered(isExtracted: true),
      ],
    );
  }

  Widget _courseItem({required Widget header, required List<Widget> children}) {
    return CustomCard(
      child: Column(
        spacing: 15,
        children: [header, Column(spacing: 10, children: children)],
      ),
    );
  }

  Widget _keyVal({required String title, required String value}) {
    return Row(
      spacing: 5,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 130),
          child: Text(
            title,
            style: AppTheme.text.copyWith(
              color: AppTheme.steelMist,
              fontSize: 16.0,
              height: 1.50,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.text.copyWith(
              color: AppTheme.blueGray,
              fontSize: 16.0,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _courseInformation() {
    return CustomCard(
      decoration: BoxDecoration(color: AppTheme.walnutBronze.withAlpha(0x19)),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            'Course Information',
            style: AppTheme.text.copyWith(
              fontSize: 20.0,
              fontWeight: getFontWeight(600),
            ),
          ),
          CustomGrid(
            largeDesktop: 2,
            children: [
              _courseItem(
                header: _courseItemHeader(
                  title: 'Course Details',
                  img: Images.pers,
                ),
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
                header: _courseItemHeader(title: 'Class Information'),
                children: [
                  _keyVal(
                    title: 'Schedule:',
                    value: '[Class times from syllabus]',
                  ),
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
        ],
      ),
    );
  }

  Widget _aiSection({required String title, String? img, bool isAi = true}) {
    return Row(
      spacing: 10,
      children: [
        if (isNotNull(img))
          SVGImagePlaceHolder(
            imagePath: img!,
            size: 20,
            color: AppTheme.sageMist,
          )
        else
          Icon(Icons.calendar_month, color: AppTheme.sageMist),
        Flexible(
          child: Text(
            title,
            style: AppTheme.text.copyWith(
              fontSize: 20.0,
              fontWeight: getFontWeight(600),
              height: 1.40,
            ),
          ),
        ),
        if (isAi) _aiPowered(),
      ],
    );
  }

  Widget _gridChild({
    required String title,
    required String body,
    required String btnText,
    required String image,
    required Color color,
    String? route, //TODO make required
  }) {
    return InkWell(
      onTap: () {
        if (isNotNull(route)) {
          NavigationHelper.push(route!);
        }
      },
      child: CustomCard(
        decoration: BoxDecoration(color: color),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedChild(
              size: 48,
              decoration: BoxDecoration(
                color: AppTheme.white.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: SVGImagePlaceHolder(
                imagePath: image,
                size: 20,
                color: AppTheme.white,
              ),
            ),
            Text(
              title,
              style: AppTheme.text.copyWith(
                color: AppTheme.white,
                fontSize: 20.0,
                fontWeight: getFontWeight(600),
              ),
            ),
            Text(
              body,
              style: AppTheme.text.copyWith(
                color: AppTheme.white.withAlpha(229),
                fontSize: 16.0,
              ),
            ),
            AppButton.text(
              mainAxisSize: MainAxisSize.min,
              onTap: () {
                if (isNotNull(route)) {
                  NavigationHelper.push(route!);
                }
              },
              text: btnText,
              suffix: Icon(Icons.arrow_forward, color: AppTheme.white),
              style: AppTheme.text.copyWith(
                color: AppTheme.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customCardSection({
    required Widget header,
    required String title,
    required String body,
    required Widget button,
    Color? color,
    String? img,
  }) {
    return CustomCard(
      addShadow: !isNotNull(color),
      decoration: BoxDecoration(
        color: color,
        border:
            isNotNull(color)
                ? Border.all(color: AppTheme.sageMist.withAlpha(0x66))
                : null,
      ),
      child: Column(
        spacing: 30,
        children: [
          header,
          Column(
            spacing: 10,
            children: [
              OutlinedChild(
                size: 64,
                decoration: BoxDecoration(
                  color: AppTheme.sageMist.withAlpha(0x19),
                  shape: BoxShape.circle,
                ),
                child:
                    isNotNull(img)
                        ? SVGImagePlaceHolder(
                          imagePath: img!,
                          size: 24,
                          color: AppTheme.sageMist,
                        )
                        : Icon(
                          Icons.access_time,
                          color: AppTheme.sageMist,
                          size: 30,
                        ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTheme.text.copyWith(
                  fontSize: 18.0,
                  fontWeight: getFontWeight(500),
                  height: 1.56,
                ),
              ),
              WidthLimiter(
                mobile: 500,
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                  style: AppTheme.text.copyWith(
                    color: AppTheme.stormGray,
                    fontSize: 16.0,
                    height: 1.50,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: button,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _welcome(Board board) {
    return CustomCard(
      addShadow: true,
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to your ${board.name} sanctuary',
            style: AppTheme.text.copyWith(
              fontSize: 24.0,
              fontWeight: getFontWeight(600),
              height: 1.33,
            ),
          ),
          Text(
            'Upload your syllabus to unlock AI-powered course insights and organization tools tailored for your environmental studies',
            style: AppTheme.text.copyWith(
              color: AppTheme.stormGray,
              fontSize: 16.0,
              height: 1.50,
            ),
          ),

          AppButton(
            mainAxisSize: MainAxisSize.min,
            color: AppTheme.sageMist,
            onTap: () {},
            text: 'Upload Syllabus',
            style: AppTheme.text.copyWith(
              color: AppTheme.white,
              fontSize: 16.0,
              fontWeight: getFontWeight(500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectRows() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        double padding = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: mobilePadding,
          tablet: tabletPadding,
        );
        return Container(
          color: AppTheme.white,
          child: Padding(
            padding: EdgeInsets.only(top: 10, right: padding, left: padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: WidthLimiter(
                    mobile: largeDesktopSize,
                    child: TextRowSelect(
                      items: [
                        'Overview',
                        'Uploads',
                        'Assignments',
                        'Resources',
                      ],
                      selected: 'Overview',
                      selectedTextColor: AppTheme.sageMist,
                      borderColor: AppTheme.sageMist,
                      textColor: AppTheme.steelMist,
                      padding: EdgeInsets.symmetric(vertical: 10),
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

  Widget _header(Board board) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [AppTheme.sageMist, AppTheme.dustyOlive],
            ),
          ),
          child: ResponsivePadding(
            mobile: EdgeInsets.all(mobilePadding),
            tablet: EdgeInsets.all(tabletPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: AppTheme.white,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: WidthLimiter(
                    mobile: largeDesktopSize,
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                board.name,
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.white,
                                  fontSize: getDeviceResponsiveValue(
                                    deviceType: layoutVm.deviceType,
                                    mobile: 18.0,
                                    tablet: 22.0,
                                    laptop: 24.0,
                                    desktop: 30.0,
                                  ),
                                  fontWeight: getFontWeight(600),
                                  height: 1.20,
                                ),
                              ),
                              Text(
                                board.term ?? "",
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.white.withAlpha(204),
                                  fontSize: 16.0,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ),

                        AppButton(
                          mainAxisSize: MainAxisSize.min,
                          color: AppTheme.white,
                          text: 'Upload Syllabus',
                          prefix: SVGImagePlaceHolder(
                            imagePath: Images.upload,
                            color: AppTheme.sageMist,
                            size: 16,
                          ),
                          onTap: () {},
                          style: AppTheme.text.copyWith(
                            color: AppTheme.sageMist,
                            fontSize: 16.0,
                          ),
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
}
