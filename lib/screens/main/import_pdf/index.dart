import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/import_pdf/appbar.dart';
import 'package:navinotes/screens/main/import_pdf/aside.dart';
import 'package:navinotes/screens/main/import_pdf/footer.dart';
import 'package:navinotes/screens/main/import_pdf/main.dart';
import 'package:navinotes/screens/main/import_pdf/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class UploadPdfScreen extends StatelessWidget {
  UploadPdfScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ImportPdfVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        backgroundColor: AppTheme.white,
        drawer: CustomDrawer(child: ImportPdfAside()),
        body: Column(
          children: [
            ImportPdfAppBar(),
            Expanded(
              child: ResponsiveSection(
                mobile: ImportPdfMain(),
                desktop: Row(
                  children: [
                    WidthLimiter(mobile: 256, child: ImportPdfAside()),
                    Expanded(child: ImportPdfMain()),
                  ],
                ),
              ),
            ),
            UploadPdfFooter(),
          ],
        ),
      ),
    );
  }
}
