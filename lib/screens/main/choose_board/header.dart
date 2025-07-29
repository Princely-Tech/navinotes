import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/main/choose_board/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class ChooseBoardHeader extends StatelessWidget {
  const ChooseBoardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<ChooseBoardVm>(
          builder: (_, vm, _) {
            return Container(
              padding: EdgeInsets.all(15),
              color: AppTheme.white,
              child: Row(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: NavigationHelper.pop,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: AppTheme.vividRose,
                                ),
                                VisibleController(
                                  mobile: false,
                                  tablet: true,
                                  child: Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        spacing: 8,
                                        children: [
                                          Text(
                                            AppStrings.appName,
                                            style: AppTheme.text.copyWith(
                                              overflow: TextOverflow.ellipsis,
                                              color: AppTheme.vividRose,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            'Choose Board Style',
                                            style: AppTheme.text.copyWith(
                                              color: AppTheme.vividRose,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // VisibleController(
                        //   mobile: true,
                        //   largeDesktop: false,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 5),
                        //     child: MenuButton(onPressed: vm.openDrawer),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  AppIconButton(
                    onPressed: NavigationHelper.navigateToProfile,
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.pastelBloom,
                      ),
                      child: Icon(Icons.person, color: AppTheme.vividRose),
                    ),
                  ),
                  // Row(
                  //   children: [

                  //     // VisibleController(
                  //     //   mobile: getMenuVisible(layoutVm.deviceType),
                  //     //   child: Padding(
                  //     //     padding: const EdgeInsets.only(left: 10),
                  //     //     child: InkWell(
                  //     //       onTap: vm.openEndDrawer,
                  //     //       child: Icon(
                  //     //         Icons.precision_manufacturing_outlined,
                  //     //         size: 24,
                  //     //         color: AppTheme.steelMist,
                  //     //       ),
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
