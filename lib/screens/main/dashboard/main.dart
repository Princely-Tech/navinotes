import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/dashboard/boards.dart';
import 'package:navinotes/screens/main/dashboard/header.dart';
import 'package:navinotes/screens/main/dashboard/recent_activity.dart';
import 'package:navinotes/settings/ui_helpers.dart';
import 'package:navinotes/widgets/components.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultHorizontalPadding,
        vertical: 10,
      ),
      child: Column(
        spacing: 10,
        children: [
          DashboardHeader(),
          Expanded(
            child: ScrollableController(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                spacing: 30,
                children: [YourBoards(), RecentActivity()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
