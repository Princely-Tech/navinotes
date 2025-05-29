import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/board_notes/aside.dart';
import 'package:navinotes/screens/main/board_notes/appbar.dart';
import 'package:navinotes/screens/main/board_notes/main.dart';
import 'package:navinotes/screens/main/board_notes/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/widgets/index.dart';

class BoardNotesScreen extends StatelessWidget {
  BoardNotesScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoardNotesVm(scaffoldKey: _scaffoldKey),
      child: Consumer<BoardNotesVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            endDrawer: CustomDrawer(child: BoardNotesAside()),
            body: Column(
              children: [
                BoardNotesAppBar(),
                Expanded(
                  child: ResponsiveSection(
                    mobile: BoardNotesMain(),
                    desktop: Row(
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
