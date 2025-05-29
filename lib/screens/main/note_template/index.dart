import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/aside.dart';
import 'package:navinotes/screens/main/note_template/footer.dart';
import 'package:navinotes/screens/main/note_template/header.dart';
import 'package:navinotes/screens/main/note_template/main.dart';
import 'package:navinotes/screens/main/note_template/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/widgets/index.dart';

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
            endDrawer: CustomDrawer(child: NoteTemplateAside()),
            body: Column(
              children: [
                NoteTemplateHeader(),
                Expanded(
                  child: ResponsiveSection(
                    mobile: NoteTemplateMain(),
                    desktop: Row(
                      children: [
                        Expanded(child: NoteTemplateMain()),
                        WidthLimiter(
                          mobile: 280,
                          largeDesktop: 320,
                          child: NoteTemplateAside(),
                        ),
                      ],
                    ),
                  ),
                ),
                NoteTemplateFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}
