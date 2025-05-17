import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';

class ScaffoldFrame extends StatelessWidget {
  const ScaffoldFrame({
    super.key,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.scaffoldKey,
    this.floatingActionButton,
    this.backgroundColor,
  });

  final Widget body;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final Key? scaffoldKey;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: body,
        drawer: drawer,
        endDrawer: endDrawer,
        backgroundColor: backgroundColor ?? Apptheme.lightGray,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
