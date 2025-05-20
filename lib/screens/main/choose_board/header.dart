import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/main/choose_board/vm.dart';
import 'package:navinotes/settings/app_strings.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/util_functions.dart';
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
                                AppStrings.appName,
                                style: Apptheme.text.copyWith(
                                  color: Apptheme.royalBlue,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Choose Board Style',
                                style: Apptheme.text.copyWith(
                                  color: Apptheme.strongBlue,
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
                        mobile: getMenuVisible(layoutVm.deviceType),
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
