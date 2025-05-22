import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/main/note_template/vm.dart';
import 'package:navinotes/settings/app_strings.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/screen_dimensions.dart';
import 'package:navinotes/widgets/buttons.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/inputs.dart';
import 'package:provider/provider.dart';

class NoteTemplateHeader extends StatelessWidget {
  const NoteTemplateHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteTemplateVm>(
      builder: (context, vm, _) {
        return Container(
          color: Apptheme.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 5,
                  children: [_leading(), _actions(vm)],
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Apptheme.lightGray),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 15,
                  children: [_searchBar(), _sortBy()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sortBy() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 5,
      children: [
        Text(
          'Sort by:',
          style: Apptheme.text.copyWith(color: Apptheme.stormGray),
        ),
        WidthLimiter(
          mobile: 160,
          child: CustomInputField(
            hintText: 'Sort by...',
            constraints: BoxConstraints(maxHeight: 40),
            controller: TextEditingController(text: 'Most Popular'),
            selectItems: ['Most Popular', 'Date Created', 'Date Modified'],
          ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Flexible(
      child: WidthLimiter(
        mobile: 662,
        child: CustomInputField(
          hintText: 'Search templates...',
          constraints: BoxConstraints(maxHeight: 40),
          prefixIcon: Icon(Icons.search, color: Apptheme.slateGray, size: 20),
          hintStyle: Apptheme.text.copyWith(
            color: Apptheme.slateGray,
            fontSize: 16,
            height: 1.50,
          ),
        ),
      ),
    );
  }

  Widget _actions(NoteTemplateVm vm) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        VisibleController(
          mobile: false,
          laptops: true,
          child: Flexible(
            child: Container(
              decoration: ShapeDecoration(
                color: Apptheme.paleBlue,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Apptheme.lightGray),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  SVGImagePlaceHolder(imagePath: Images.logoRounded, size: 24),
                  Flexible(
                    child: Text(
                      AppStrings.appName,
                      style: Apptheme.text.copyWith(
                        color: Apptheme.electricIndigo,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AppButton(
          onTap: () {},
          shape: CircleBorder(),
          color: Apptheme.lightGray,
          padding: EdgeInsets.zero,
          minHeight: 32,
          child: Icon(Icons.more_vert, color: Apptheme.stormGray),
        ),
        MenuButton(onPressed: vm.openDrawer),
      ],
    );
  }

  Widget _leading() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        bool isMobile = layoutVm.deviceType == DeviceType.mobile;
        return Expanded(
          child: Row(
            spacing: 10,
            children: [
              AppButton.text(
                onTap: NavigationHelper.pop,
                color: Apptheme.strongBlue,
                text: isMobile ? 'Back' : 'Back to Board View',
                prefix: Icon(Icons.arrow_back, color: Apptheme.strongBlue),
              ),
              Expanded(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Note Template',
                      style: Apptheme.text.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Board: ',
                            style: Apptheme.text.copyWith(
                              color: Apptheme.steelMist,
                            ),
                          ),
                          TextSpan(
                            text: 'Advanced Biology - Semester 2',
                            style: Apptheme.text.copyWith(
                              color: Apptheme.strongBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
