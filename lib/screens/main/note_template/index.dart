import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/aside.dart';
import 'package:navinotes/screens/main/note_template/header.dart';
import 'package:navinotes/screens/main/note_template/main.dart';
import 'package:navinotes/screens/main/note_template/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/frames.dart';
import 'package:provider/provider.dart';

class NoteTemplateScreen extends StatelessWidget {
  NoteTemplateScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteTemplateVm(scaffoldKey: _scaffoldKey),
      child: Consumer<NoteTemplateVm>(
        builder: (context, vm, child) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            endDrawer: Drawer(
              backgroundColor: Apptheme.white,
              shape: RoundedRectangleBorder(),
              child: NoteTemplateAside(),
            ),
            body: Column(
              children: [
                NoteTemplateHeader(),
                Expanded(
                  child: ResponsiveSection(
                    mobile: NoteTemplateMain(),
                    desktops: Row(
                      children: [
                        Expanded(child: NoteTemplateMain()),
                        WidthLimiter(
                          mobile: 280,
                          largeDesktops: 320,
                          child: NoteTemplateAside(),
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO add the footer
              ],
            ),
          );
        },
      ),
    );
  }
}
