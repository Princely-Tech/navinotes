import 'package:navinotes/packages.dart';

class PdfViewScreen extends StatelessWidget {
  PdfViewScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Get contentId from route arguments
    final String contentId =
        ModalRoute.of(context)?.settings.arguments as String;

    return ChangeNotifierProvider(
      create: (_) => ComPdfVm(),
      child: Consumer<ComPdfVm>(
        builder: (_, comPdfVm, _) {
          return ChangeNotifierProvider(
            create: (context) {
              final vm = PdfViewVm(
                scaffoldKey: GlobalKey(),
                comPdfVm: comPdfVm,
                contentId: contentId,
              );
              vm.initialize(context);
              return vm;
            },
            child: ScaffoldFrame(
              scaffoldKey: _scaffoldKey,
              backgroundColor: AppTheme.white,
              body: Stack(
                children: [
                  ResponsiveSection(
                    mobile: PdfViewMain(),
                    desktop: Row(children: [Expanded(child: PdfViewMain())]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
