import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/import_pdf/appbar.dart';
import 'package:navinotes/screens/main/import_pdf/aside.dart';
import 'package:navinotes/screens/main/import_pdf/main.dart';
import 'package:navinotes/screens/main/import_pdf/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/frames.dart';
import 'package:provider/provider.dart';

class UploadPdfScreen extends StatelessWidget {
  UploadPdfScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImportPdfVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        backgroundColor: Apptheme.white,
        drawer: Drawer(
          backgroundColor: Apptheme.white,
          shape: RoundedRectangleBorder(),
          child: ImportPdfAside(),
        ),
        body: Column(
          children: [
            ImportPdfAppBar(),
            Expanded(
              child: ResponsiveSection(
                mobile: ImportPdfMain(),
                desktops: Row(
                  children: [
                    WidthLimiter(mobile: 256, child: ImportPdfAside()),
                    Expanded(child: ImportPdfMain()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
