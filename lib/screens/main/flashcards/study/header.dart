import 'package:navinotes/packages.dart';
import 'vm.dart';

class FlashCardStudyHeader extends StatelessWidget {
  const FlashCardStudyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardStudyVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 1, color: Color(0xFFE5E7EB)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton.text(
                  spacing: 1,
                  onTap: NavigationHelper.pop,
                  text: 'Back to Decks',
                  style: TextStyle(
                    color: Color(0xFF00555A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  prefix: Icon(
                    Icons.keyboard_arrow_left,
                    size: 30,
                    color: Color(0xFF00555A),
                  ),
                ),

                VisibleController(
                  mobile: false,
                  tablet: true,
                  child: Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          SVGImagePlaceHolder(imagePath: Images.logo, size: 30),
                          Flexible(
                            child: Text.rich(
                              overflow: TextOverflow.ellipsis,
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'NaviNotes',
                                    style: TextStyle(
                                      color: Color(0xFF00555A),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '  |  ',
                                    style: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Physics 101 FlashCards',
                                    style: TextStyle(
                                      color: Color(0xFF374151),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      AppIconButton(
                        onPressed: NavigationHelper.navigateToSettings,
                        icon: SVGImagePlaceHolder(
                          imagePath: Images.settings,
                          size: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ProfilePic(),
                      ),
                      VisibleController(
                        mobile: true,
                        desktop: false,
                        child: AppIconButton(
                          onPressed: vm.openEndDrawer,
                          icon: Icon(Icons.menu, size: 25),
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
}
