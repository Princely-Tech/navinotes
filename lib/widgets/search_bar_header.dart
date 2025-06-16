import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class SearchBarHeader extends StatelessWidget {
  const SearchBarHeader({
    super.key,
    required this.openDrawer,
    this.borderBottom = false,
  });
  final VoidCallback openDrawer;
  final bool borderBottom;
  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          decoration: BoxDecoration(
            color: borderBottom ? Apptheme.white : Apptheme.transparent,
            border: Border(
              bottom: BorderSide(
                color: borderBottom ? Apptheme.lightGray : Colors.transparent,
              ),
            ),
          ),
          child: ResponsivePadding(
            mobile: EdgeInsets.all(10),
            tablet: EdgeInsets.symmetric(
              horizontal: defaultHorizontalPadding,
              vertical: 10,
            ),
            child: Row(
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
                            onTap: openDrawer,
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
                                fontSize: 16.0,
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
                   ProfilePic(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
