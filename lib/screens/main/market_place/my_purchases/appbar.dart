import 'package:navinotes/packages.dart';
import 'vm.dart';

class MyPurchasesAppBar extends StatelessWidget {
  const MyPurchasesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.iceBlue,
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: WidthLimiter(
              mobile: largeDesktopSize,
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return Consumer<MyPurchasesVm>(
                    builder: (_, vm, _) {
                      return ScrollableController(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 20,
                              children: [_leading(), _trailing(vm)],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leading() {
    return AppButton.text(
      onTap: NavigationHelper.pop,
      child: Row(
        children: [
          Icon(Icons.arrow_back, color: AppTheme.vividRose, size: 20),
          VisibleController(
            mobile: false,
            tablet: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                spacing: 10,
                children: [
                  SVGImagePlaceHolder(imagePath: Images.logo, size: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        'NaviNotes',
                        style: TextStyle(
                          color: const Color(0xFF00555A),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      Text(
                        'My Purchases',
                        style: TextStyle(
                          color: const Color(0xFF00555A),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trailing(MyPurchasesVm vm) {
    return Row(
      children: [
        Row(
          spacing: 10,
          children: [
            Icon(Icons.question_mark_rounded, color: AppTheme.vividRose),
            Icon(Icons.notifications, color: AppTheme.vividRose),
            ProfilePic(size: 32),
          ],
        ),
        VisibleController(
          mobile: true,
          desktop: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: MenuButton(onPressed: vm.openDrawer),
          ),
        ),
      ],
    );
  }
}
