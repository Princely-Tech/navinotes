import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/choose_board/header.dart';
import 'package:navinotes/screens/main/choose_board/main.dart';
import 'package:navinotes/screens/main/choose_board/side_drawer.dart';
import 'package:navinotes/screens/main/choose_board/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class ChooseBoardScreen extends StatelessWidget {
  ChooseBoardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChooseBoardVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        endDrawer: CustomDrawer(child: ChooseBoardAside()),
        backgroundColor: Apptheme.paleBlue,
        body: Column(
          children: [
            ChooseBoardHeader(),
            Expanded(
              child: ResponsiveSection(
                mobile: ChooseBoardMain(),
                desktop: Row(
                  children: [
                    Expanded(child: ChooseBoardMain()),
                    WidthLimiter(
                      mobile: 280,
                      largeDesktop: 360,
                      child: ChooseBoardAside(),
                    ),
                  ],
                ),
              ),
            ),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _footer() {
    return Consumer<ChooseBoardVm>(
      builder: (context, vm, _) {
        return Container(
          decoration: BoxDecoration(color: Apptheme.white),
          child: ScrollableRow(
            padding: EdgeInsets.all(15),
            child: Container(
              constraints: BoxConstraints(minWidth: screenWidth(context)),
              child: Row(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: vm.saveAsFavoriteStyle,
                        onChanged: vm.updateSaveAsFavoriteStyle,
                      ),
                      Text(
                        'Save as Favorite Style',
                        style: Apptheme.text.copyWith(
                          color: Apptheme.persianBlue,
                          fontWeight: getFontWeight(500),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 20,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton.secondary(
                        wrapWithFlexible: true,
                        mainAxisSize: MainAxisSize.min,
                        onTap: vm.skipAndUseDefault,
                        textColor: Apptheme.electricIndigo,
                        color: Apptheme.softSkyBlue,
                        text: 'Skip & Use Default',
                      ),
                      AppButton(
                        color: Apptheme.primaryColor,
                        wrapWithFlexible: true,
                        mainAxisSize: MainAxisSize.min,
                        onTap: vm.createBoard,
                        text: 'Create Board',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
