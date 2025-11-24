import 'package:navinotes/packages.dart';

class OnBoardingFrame extends StatelessWidget {
  const OnBoardingFrame({
    super.key,
    required this.title,
    required this.body,
    required this.index,
    required this.image,
  });
  final String title, body, image;
  final int index;
  Color gradientColor() {
    switch (index) {
      case 1:
        return HexColor('#eefac3');
      case 2:
        return HexColor('#f7cd75');
      default:
        return HexColor('#aae5d6');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, gradientColor()],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(),
                        child: Column(
                          spacing: 30,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                spacing: 15,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 55,
                                      fontFamily: 'Codec Pro',
                                      fontWeight: FontWeight.w500,
                                      height: 1.23,
                                      letterSpacing: 0.03,
                                    ),
                                  ),
                                  // SizedBox(height: Helper().getHeight(9)),
                                  Text(
                                    body,
                                    style: TextStyle(
                                      fontSize: 31,
                                      fontFamily: 'Codec Pro',
                                      fontWeight: FontWeight.w300,
                                      height: 1.21,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            AppButton(
                              onTap: () => NavigationHelper.push(Routes.auth),
                              text: 'Let go',
                            ),
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
      ),
    );
  }

  Widget _currentIndicator() {
    return Row(
      spacing: 10,
      children: List.generate(3, (index) {
        bool isActive = index + 1 == index;
        double size = 13;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            // color: isActive ? AppTheme.darkGreenColor : const Color(0x7F264740),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
