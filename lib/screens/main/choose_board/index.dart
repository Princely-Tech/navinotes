import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/choose_board/header.dart';
import 'package:navinotes/screens/main/choose_board/main.dart';
import 'package:navinotes/screens/main/choose_board/side_drawer.dart';
import 'package:navinotes/screens/main/choose_board/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/widgets/buttons.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/frames.dart';
import 'package:provider/provider.dart';

class ChooseBoardScreen extends StatelessWidget {
  ChooseBoardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      scaffoldKey: _scaffoldKey,
      endDrawer: Drawer(
        backgroundColor: Apptheme.white,
        shape: RoundedRectangleBorder(),
        child: ChooseBoardAside(),
      ),
      backgroundColor: Apptheme.paleBlue,
      body: ChangeNotifierProvider(
        create: (context) => ChooseBoardVm(scaffoldKey: _scaffoldKey),
        child: Column(
          children: [
            ChooseBoardHeader(),
            Expanded(
              child: ResponsiveSection(
                mobile: ChooseBoardMain(),
                desktops: Row(
                  children: [
                    Expanded(child: ChooseBoardMain()),
                    WidthLimiter(
                      mobile: 280,
                      largeDesktops: 360,
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
      builder: (context, vm, child) {
        return Container(
          decoration: BoxDecoration(color: Apptheme.white),
          padding: EdgeInsets.all(15),
          child: Row(
            spacing: 30,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Switch(
                      value: vm.saveAsFavoriteStyle,
                      onChanged: vm.updateSaveAsFavoriteStyle,
                    ),
                    Expanded(
                      child: Text(
                        'Save as Favorite Style',
                        style: TextStyle(
                          color: const Color(0xFF1E40AF),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ),
                    //
                  ],
                ),
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
                    wrapWithFlexible: true,
                    mainAxisSize: MainAxisSize.min,
                    onTap: vm.createBoard,
                    text: 'Create Board',
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
