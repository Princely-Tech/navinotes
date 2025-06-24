import 'header.dart';
import 'left.dart';
import 'right.dart';
import 'main.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class BoardNatureMindMapScreen extends StatelessWidget {
  BoardNatureMindMapScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardNatureMindMapVm(scaffoldKey: _scaffoldKey),
      child: Consumer<BoardNatureMindMapVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            backgroundColor: AppTheme.sageMist.withAlpha(0x7F),
            drawer: CustomDrawer(child: BoardNatureMindMapLeft()),
            endDrawer: CustomDrawer(child: BoardNatureMindMapRight()),
            body: Row(
              children: [
                VisibleController(
                  mobile: false,
                  desktop: true,
                  child: WidthLimiter(
                    mobile: 256,
                    child: BoardNatureMindMapLeft(),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      BoardNatureMindMapHeader(),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: BoardNatureMindMapMain()),
                            VisibleController(
                              mobile: false,
                              laptop: true,
                              child: WidthLimiter(
                                mobile: 256,
                                child: BoardNatureMindMapRight(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _footer(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _footer() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.linen,
        border: Border(
          top: BorderSide(color: AppTheme.burntLeather.withAlpha(0x33)),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ScrollableController(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        'Export',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.darkMossGreen,
                          height: 1.43,
                          fontFamily: AppTheme.fontCrimsonText,
                        ),
                      ),
                      AppButton(
                        mainAxisSize: MainAxisSize.min,
                        color: AppTheme.darkMossGreen,
                        minHeight: 28,
                        onTap: () {},
                        text: 'Export Mind Map',
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.upload, //TODO bring icon in
                          color: AppTheme.white,
                          size: 14,
                        ),
                        style: AppTheme.text.copyWith(
                          color: AppTheme.white,
                          fontFamily: AppTheme.fontCrimsonText,
                        ),
                      ),
                      ...['PNG', 'SVG', 'PDF'].map(
                        (str) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.burntLeather.withAlpha(0x33),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          child: Text(
                            str,
                            textAlign: TextAlign.center,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.coffee,
                              fontSize: 12.0,
                              fontFamily: AppTheme.fontCrimsonText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //TODO bring in the plus,minus buttons
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
