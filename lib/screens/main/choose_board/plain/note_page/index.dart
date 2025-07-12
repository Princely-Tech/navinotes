import 'package:flutter/material.dart';
import 'aside.dart';
import 'appbar.dart';
import 'main.dart';
import 'vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/widgets/index.dart';
import 'package:navinotes/models/board.dart';
import 'package:navinotes/settings/navigation_helper.dart';

class BoardPlainNotePageScreen extends StatelessWidget {
   BoardPlainNotePageScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Extract board from route arguments
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final Board? board =
        routeArgs is Map<String, dynamic>
            ? Board.fromMap(routeArgs)
            : routeArgs is Board
            ? routeArgs
            : null;

    return ChangeNotifierProvider(
      create:
          (context) =>
              BoardPlainNotePageVm(scaffoldKey: _scaffoldKey, board: board),
      child: Consumer<BoardPlainNotePageVm>(
        builder: (_, vm, __) {
          // Show error if no board is provided
          if (vm.board == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Error: No board data found',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => NavigationHelper.pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            endDrawer: CustomDrawer(child: BoardPlainNotePageAside()),
            body: Column(
              children: [
                BoardPlainNotePageAppBar(),
                Expanded(
                  child: ResponsiveSection(
                    mobile: const BoardPlainNotePageMain(),
                    desktop: Row(
                      children: [
                        const Expanded(child: BoardPlainNotePageMain()),
                        WidthLimiter(
                          mobile: 288,
                          child: BoardPlainNotePageAside(),
                        ),
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
