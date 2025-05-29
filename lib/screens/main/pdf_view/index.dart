import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/pdf_view/aside.dart';
import 'package:navinotes/screens/main/pdf_view/main.dart';
import 'package:navinotes/screens/main/pdf_view/overlay/index.dart';
import 'package:navinotes/screens/main/pdf_view/vm.dart';
import 'package:navinotes/settings/index.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/widgets/index.dart';

class PdfViewScreen extends StatelessWidget {
  PdfViewScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PdfViewVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        endDrawer: CustomDrawer(child: PdfViewAside()),
        backgroundColor: Apptheme.white,
        body: Stack(
          children: [
            ResponsiveSection(
              mobile: PdfViewMain(),
              desktop: Row(
                children: [
                  Expanded(child: PdfViewMain()),
                  WidthLimiter(mobile: 288, child: PdfViewAside()),
                ],
              ),
            ),
            PdfViewOverlay(),
          ],
        ),
      ),
    );
  }
}
