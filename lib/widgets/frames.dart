import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';

class ScaffoldFrame extends StatelessWidget {
  const ScaffoldFrame({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: body, backgroundColor: Apptheme.white),
    );
  }
}
