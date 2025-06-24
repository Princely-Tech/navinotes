import 'package:navinotes/packages.dart';

class PdfViewScreen extends StatelessWidget {
  PdfViewScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ComPdfVm(),
      child: Consumer<ComPdfVm>(
        builder: (_, comPdfVm, _) {
          return ChangeNotifierProvider(
            create: (context) {
              final vm = PdfViewVm(
                scaffoldKey: GlobalKey(),
                comPdfVm: comPdfVm,
              );
              vm.initialize(context);
              return vm;
            },
            child: ScaffoldFrame(
              scaffoldKey: _scaffoldKey,
              endDrawer: CustomDrawer(child: PdfViewAside()),
              backgroundColor: AppTheme.white,
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
        },
      ),
    );
  }
}
