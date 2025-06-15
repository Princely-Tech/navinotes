import 'header.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

double mobileHorPadding = 20;
double laptopHorPadding = 30;
double desktopHorPadding = 40;

Color shadowColor = Apptheme.black.withAlpha(0x19);
List<BoxShadow> boxShadows = [
  BoxShadow(
    color: shadowColor,
    blurRadius: 15,
    offset: Offset(0, 10),
    spreadRadius: 0,
  ),
  BoxShadow(
    color: shadowColor,
    blurRadius: 6,
    offset: Offset(0, 4),
    spreadRadius: 0,
  ),
];

class DarkAcademiaEditScreen extends StatelessWidget {
  const DarkAcademiaEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DarkAcademiaEditVM(),
      child: Consumer<DarkAcademiaEditVM>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: Apptheme.warmSand,
            body: Column(
              children: [
                DarkAcademiaEditHeader(),
                Expanded(
                  child: ScrollableController(
                    child: Column(
                      children: [
                        _pic(),
                        _courseTimeLine(), //TODO check the line thats drawn
                        Column(
                          spacing: 50,
                          children: [
                            _actions(),
                            _upcomingAssignment(),
                            _coarseMaterial(),
                          ],
                        ),
                        _footer(),
                      ],
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

  Widget _footerItem({required String title, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          title,
          style: Apptheme.text.copyWith(
            color: Apptheme.white,
            fontSize: 24.0,
            fontFamily: Apptheme.fontPlayfairDisplay,
            height: 1.33,
          ),
        ),
        ...items.map(
          (str) => Text(
            str,
            style: Apptheme.text.copyWith(
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
      decoration: BoxDecoration(color: Apptheme.espressoBrown),
      margin: EdgeInsets.only(top: 40),
      child: _horizontalPadding(
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
    return _section(
      title: 'Course Materials',
      child: Container(
        decoration: DottedDecoration(
          color: Apptheme.espressoBrown.withAlpha(0x4C),
          shape: Shape.box,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomCard(
          decoration: BoxDecoration(color: Apptheme.transparent),
          child: Column(
            spacing: 15,
            children: [
              Column(
                spacing: 5,
                children: [
                  SVGImagePlaceHolder(
                    imagePath: Images.upload2,
                    size: 60,
                    color: Apptheme.espressoBrown.withAlpha(76),
                  ),
                  Text(
                    'Upload and organize your study materials',
                    textAlign: TextAlign.center,
                    style: Apptheme.text.copyWith(
                      color: Apptheme.espressoBrown,
                      fontSize: 20.0,
                      height: 1.40,
                    ),
                  ),
                ],
              ),
              Text(
                'Drag and drop files here',
                textAlign: TextAlign.center,
                style: Apptheme.text.copyWith(
                  color: Apptheme.espressoBrown.withAlpha(0xB2),
                  fontSize: 16.0,
                  height: 1.50,
                ),
              ),
            ],
          ),
        ),
      ),
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
              style: Apptheme.text.copyWith(
                color: Apptheme.espressoBrown,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required Widget child, required String title}) {
    return _horizontalPadding(
      child: Column(
        spacing: 25,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Apptheme.text.copyWith(
              color: Apptheme.espressoBrown,
              fontSize: 30.0,
              fontFamily: Apptheme.fontPlayfairDisplay,
              height: 1.20,
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _horizontalPadding({required Widget child}) {
    return ResponsivePadding(
      mobile: EdgeInsets.symmetric(horizontal: mobileHorPadding),
      laptop: EdgeInsets.symmetric(horizontal: laptopHorPadding),
      desktop: EdgeInsets.symmetric(horizontal: desktopHorPadding),
      child: child,
    );
  }

  Widget _actionCard({
    required String title,
    required String body,
    required String icon,
    String? route, //TODO make required
    bool isCaramelMist = false,
  }) {
    return InkWell(
      onTap: () {
        if (isNotNull(route)) {
          NavigationHelper.push(route!);
        }
      },
      child: CustomCard(
        decoration: BoxDecoration(
          color: isCaramelMist ? Apptheme.caramelMist : Apptheme.white,
          boxShadow: boxShadows,
        ),
        child: Column(
          spacing: 5,
          children: [
            SVGImagePlaceHolder(
              imagePath: icon,
              size: 36,
              color: Apptheme.espressoBrown,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Apptheme.text.copyWith(
                color: isCaramelMist ? Apptheme.white : Apptheme.espressoBrown,
                fontSize: 24.0,
                fontFamily: Apptheme.fontPlayfairDisplay,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                body,
                textAlign: TextAlign.center,
                style: Apptheme.text.copyWith(
                  color:
                      isCaramelMist
                          ? Colors.white.withAlpha(204)
                          : Apptheme.espressoBrown,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actions() {
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
              color: Apptheme.espressoBrown,
              border: Border.all(color: Apptheme.transparent),
            ),
          ),
        ),
        _horizontalPadding(
          child: CustomGrid(
            children: [
              _actionCard(
                icon: Images.upload3,
                title: 'Upload Syllabus',
                body: 'Start here to unlock AI features',
                isCaramelMist: true,
              ),
              _actionCard(
                icon: Images.pen2,
                title: 'Create Note',
                body: 'Begin taking notes right away',
                route: Routes.boardNotes,
              ),
              _actionCard(
                icon: Images.folder,
                title: 'Import Files',
                body: 'Add your course materials',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _courseTimeLine() {
    return Container(
      width: double.infinity,
      color: Apptheme.espressoBrown,
      child: ResponsivePadding(
        mobile: EdgeInsets.fromLTRB(mobileHorPadding, 20, mobileHorPadding, 40),
        laptop: EdgeInsets.fromLTRB(laptopHorPadding, 20, laptopHorPadding, 50),
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
              style: Apptheme.text.copyWith(
                color: Apptheme.white,
                fontSize: 30.0,
                fontFamily: Apptheme.fontPlayfairDisplay,
                height: 1.20,
              ),
            ),
            CustomCard(
              decoration: BoxDecoration(
                color: Apptheme.white.withAlpha(25),
                border: Border.all(color: Apptheme.transparent),
              ),
              child: Column(
                spacing: 20,
                children: [
                  Icon(
                    Icons.access_time,
                    color: Apptheme.caramelMist,
                    size: 50,
                  ),
                  Text(
                    'Your course schedule will appear here',
                    textAlign: TextAlign.center,
                    style: Apptheme.text.copyWith(
                      color: Apptheme.white,
                      fontSize: 20.0,
                    ),
                  ),
                  AppButton.secondary(
                    mainAxisSize: MainAxisSize.min,
                    color: Apptheme.caramelMist,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.upload,
                      size: 16,
                      color: Apptheme.caramelMist,
                    ),
                    onTap: () {},
                    text: 'Upload syllabus to generate timeline',
                    style: Apptheme.text.copyWith(
                      color: Apptheme.caramelMist,
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
