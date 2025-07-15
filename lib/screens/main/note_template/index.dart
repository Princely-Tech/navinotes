import 'package:navinotes/packages.dart';
import 'aside.dart';
import 'main.dart';
import 'vm.dart';

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
            body: ResponsiveSection(
              mobile: WidthLimiter(
                mobile: 325,
                // mobile: 280,
                largeDesktop: 320,
                child: NoteTemplateAside(),
              ),
              // mobile: NoteTemplateMain(),
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
          );
        },
      ),
    );
  }
}
