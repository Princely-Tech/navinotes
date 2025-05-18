import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/board_notes/aside.dart';
import 'package:navinotes/screens/main/board_notes/appbar.dart';
import 'package:navinotes/screens/main/board_notes/main.dart';
import 'package:navinotes/screens/main/board_notes/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/frames.dart';
import 'package:provider/provider.dart';

class BoardNotesScreen extends StatelessWidget {
  BoardNotesScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoardNotesVm(scaffoldKey: _scaffoldKey),
      child: Consumer<BoardNotesVm>(
        builder: (context, vm, child) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            endDrawer: Drawer(
              backgroundColor: Apptheme.white,
              shape: RoundedRectangleBorder(),
              child: BoardNotesAside(),
            ),
            body: Column(
              children: [
                BoardNotesAppBar(),
                Expanded(
                  child: ResponsiveSection(
                    mobile: BoardNotesMain(),
                    desktops: Row(
                      children: [
                        Expanded(child: BoardNotesMain()),
                        WidthLimiter(mobile: 288, child: BoardNotesAside()),
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
}
