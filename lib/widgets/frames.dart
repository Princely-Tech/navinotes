import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';

class ScaffoldFrame extends StatelessWidget {
  const ScaffoldFrame({
    super.key,
    required this.body,
    this.drawer,
    this.scaffoldKey,
    this.floatingActionButton,
  });

  final Widget body;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Key? scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: body,
        drawer: drawer,
        backgroundColor: Apptheme.lightGray,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
