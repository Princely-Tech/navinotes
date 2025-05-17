import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/dashboard/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/inputs.dart';
import 'package:provider/provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (context, layoutVm, child) {
        return Consumer<DashboardVm>(
          builder: (context, vm, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 30,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      VisibleController(
                        visible: vm.getMenuVisible(layoutVm.deviceType),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: vm.openDrawer,
                            child: Icon(
                              Icons.menu,
                              size: 24,
                              color: Apptheme.steelMist,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: WidthLimiter(
                            maxWidth: 512,
                            child: CustomInputField(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Apptheme.slateGray,
                                size: 20,
                              ),
                              hintText:
                                  'Search your notes, boards, and more...',
                              hintStyle: Apptheme.text.copyWith(
                                color: Apptheme.slateGray,
                                fontSize: 16,
                                height: 1.50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  spacing: 20,
                  children: [
                    SVGImagePlaceHolder(imagePath: Images.bell, size: 16),
                    SVGImagePlaceHolder(
                      imagePath: Images.settings,
                      size: 16,
                      color: Apptheme.steelMist,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
