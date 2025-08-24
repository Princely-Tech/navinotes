import 'package:navinotes/packages.dart';
import 'left.dart';
import 'main.dart';
import 'right.dart';
import 'vm.dart';

class FlashCardAiCreationScreen extends StatelessWidget {
  FlashCardAiCreationScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FlashCardAiCreationVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        backgroundColor: const Color(0xFFF9FAFB),
        scaffoldKey: _scaffoldKey,
        endDrawer: CustomDrawer(child: FlashCardAiCreationRight()),
        drawer: CustomDrawer(child: FlashCardAiCreationLeft()),
        body: Column(
          children: [
            _header(),
            Expanded(
              child: Row(
                children: [
                  VisibleController(
                    mobile: false,
                    largeDesktop: true,
                    child: WidthLimiter(
                      mobile: 288,
                      child: FlashCardAiCreationLeft(),
                    ),
                  ),
                  Expanded(child: FlashCardAiCreationMain()),
                  VisibleController(
                    mobile: false,
                    desktop: true,
                    child: WidthLimiter(
                      largeDesktop: 320,
                      mobile: 288,
                      child: FlashCardAiCreationRight(),
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

  Widget _header() {
    return Consumer<FlashCardAiCreationVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            spacing: 15,
            children: [
              /// Left section
              Expanded(
                child: Row(
                  children: [
                    VisibleController(
                      mobile: true,
                      largeDesktop: false,
                      child: AppIconButton(
                        onPressed: vm.openDrawer,
                        icon: Icon(Icons.menu),
                      ),
                    ),
                    AppIconButton(
                      onPressed: NavigationHelper.pop,
                      icon: Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Row(
                        spacing: 10,
                        children: [
                          SVGImagePlaceHolder(imagePath: Images.logo, size: 29),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "NaviNotes",
                                  style: TextStyle(
                                    color: Color(0xFF00555A),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter",
                                  ),
                                ),
                                TextSpan(
                                  text: " | Create FlashCards",
                                  style: TextStyle(
                                    color: Color(0xFF1F2937),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Right section (two icons)
              Row(
                children: [
                  AppIconButton(
                    onPressed: NavigationHelper.navigateToSettings,
                    icon: SVGImagePlaceHolder(
                      imagePath: Images.settings,
                      size: 16,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                  AppIconButton(
                    onPressed: NavigationHelper.navigateToTutorial,
                    icon: SVGImagePlaceHolder(
                      imagePath: Images.alertI,
                      size: 16,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                  VisibleController(
                    mobile: true,
                    desktop: false,
                    child: AppIconButton(
                      onPressed: vm.openEndDrawer,
                      icon: Icon(Icons.menu),
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
}
