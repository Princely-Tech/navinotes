import 'package:navinotes/screens/main/choose_board/dark_academia/edit/header.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/choose_board/dark_academia/edit/overview.dart';

double mobileHorPadding = 20;
double laptopHorPadding = 30;
double desktopHorPadding = 40;

class DarkAcademiaEditScreen extends StatelessWidget {
  DarkAcademiaEditScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Board? board = ModalRoute.of(context)?.settings.arguments as Board?;
    return ChangeNotifierProvider(
      create: (context) {
        final vm = BoardEditVm();
        if (isNotNull(board)) {
          vm.initialize(board!.id!);
        }
        return vm;
      },
      child: Consumer<BoardEditVm>(
        builder: (_, vm, _) {
          return ChooseBoardWrapper(
            //Essential; add loading until ready!!
            child: ScaffoldFrame(
              backgroundColor: AppTheme.warmSand,
              scaffoldKey: _scaffoldKey,
              drawer: CustomDrawer(child: NavigationSideBar()),
              body: ApiServiceComponent(
                child: Column(
                  children: [
                    DarkAcademiaEditHeader(board: vm.board!),
                    Expanded(
                      child: ScrollableController(
                        child: vm.returnSelectedTabItem(
                          BoardDarkAcademiaEditOverview(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
