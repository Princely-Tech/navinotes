import 'package:navinotes/packages.dart';

class ScaffoldFrame extends StatelessWidget {
  const ScaffoldFrame({
    super.key,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.scaffoldKey,
    this.floatingActionButton,
    this.backgroundColor,
    this.bottomNavigationBar,
  });
  final Widget body;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final Key? scaffoldKey;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        bottomNavigationBar: bottomNavigationBar,
        body: body,
        drawer: drawer,
        endDrawer: endDrawer,
        backgroundColor: backgroundColor ?? AppTheme.lightGray,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
