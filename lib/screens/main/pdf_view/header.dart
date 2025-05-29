import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/main/pdf_view/vm.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';
import 'package:provider/provider.dart';

class PdfViewHeader extends StatelessWidget {
  const PdfViewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<PdfViewVm>(
              builder: (_, vm, _) {
            return Container(
              padding: EdgeInsets.all(15),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Apptheme.lightGray),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 20,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: NavigationHelper.pop,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Icon(Icons.arrow_back, color: Apptheme.stormGray, size: 20),
                          Flexible(
                            child: Text(
                              'Cellular Biology - Chapter 4',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Apptheme.text.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        spacing: 15,
                        children: [
                          SVGImagePlaceHolder(imagePath: Images.recent, size: 16),
                          SVGImagePlaceHolder(imagePath: Images.share2, size: 16),
                          Icon(Icons.more_horiz, color: Apptheme.stormGray),
                        ],
                      ),
                      VisibleController(
                         mobile: getMenuVisible(layoutVm.deviceType),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MenuButton(onPressed: vm.openDrawer),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}
