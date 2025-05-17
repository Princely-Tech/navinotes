import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/main/choose_board/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:provider/provider.dart';

class ChooseBoardHeader extends StatelessWidget {
  const ChooseBoardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (context, layoutVm, child) {
        return Consumer<ChooseBoardVm>(
          builder: (context, vm, child) {
            return Container(
              padding: EdgeInsets.all(15),
              color: Apptheme.white,
              child: Row(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: NavigationHelper.pop,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Icon(Icons.arrow_back, color: Apptheme.strongBlue),
                          Column(
                            spacing: 8,
                            children: [
                              Text(
                                'NeuroNotes',
                                style: TextStyle(
                                  color: const Color(0xFF1E3A8A),
                                  fontSize: 24,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  height: 1,
                                ),
                              ),
                              Text(
                                'Choose Board Style',
                                style: TextStyle(
                                  color: const Color(0xFF2563EB),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Apptheme.paleBlue,
                        ),
                        child: Icon(Icons.person, color: Apptheme.strongBlue),
                      ),
                      VisibleController(
                        visible: vm.getMenuVisible(layoutVm.deviceType),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: InkWell(
                            onTap: vm.openDrawer,
                            child: Icon(
                              Icons.precision_manufacturing_outlined,
                              size: 24,
                              color: Apptheme.steelMist,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
