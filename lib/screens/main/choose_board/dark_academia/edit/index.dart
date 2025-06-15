import 'header.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

double mobileHorPadding = 20;
double laptopHorPadding = 30;
double desktopHorPadding = 40;

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
                        _courseTimeLine(),
                        Column(children: [_actions()]),
                        //
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

  Widget _horizontalPadding({required Widget child}) {
    return ResponsivePadding(
      mobile: EdgeInsets.symmetric(horizontal: mobileHorPadding),
      laptop: EdgeInsets.symmetric(horizontal: laptopHorPadding),
      desktop: EdgeInsets.symmetric(horizontal: desktopHorPadding),
      child: child,
    );
  }

  Widget _actionCard() {
    return CustomCard();
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
              _actionCard(),
              //
            ],
          ),
        ),
      ],
    );
  }

  Widget _courseTimeLine() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Apptheme.espressoBrown,
        border: Border.all(color: Apptheme.transparent),
      ),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w400,
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
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
                    style: TextStyle(color: Apptheme.caramelMist, fontSize: 16),
                  ),
                  //
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
