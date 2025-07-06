import 'package:flutter/material.dart';
import 'aside.dart';
import 'appbar.dart';
import 'main.dart';
import 'vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/widgets/index.dart';

class BoardPlainNotePageScreen extends StatelessWidget {
  BoardPlainNotePageScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoardPlainNotePageVm(scaffoldKey: _scaffoldKey),
      child: Consumer<BoardPlainNotePageVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            endDrawer: CustomDrawer(child: BoardPlainNotePageAside()),
            body: Column(
              children: [
                BoardPlainNotePageAppBar(),
                Expanded(
                  child: ResponsiveSection(
                    mobile: BoardPlainNotePageMain(),
                    desktop: Row(
                      children: [
                        Expanded(child: BoardPlainNotePageMain()),
                        WidthLimiter(mobile: 288, child: BoardPlainNotePageAside()),
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
