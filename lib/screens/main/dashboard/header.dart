import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<DashboardVm>(
          builder: (_, vm, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 30,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      VisibleController(
                        mobile: getMenuVisible(layoutVm.deviceType),
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
                            mobile: 512,
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
                    ImagePlaceHolder.network(
                      imagePath:
                          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80",
                      size: 29,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    // Image.network(
                    //   "https://images.unsplash.com/photo-1438761681033-6461ffad8d80",
                    //   width: 29,
                    //   height: 29,
                    //   fit: BoxFit.cover,
                    //   // imagePath: Images.person,
                    //   // size: 16,
                    // ),
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
