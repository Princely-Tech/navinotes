import 'package:flutter/material.dart';
import 'package:navinotes/providers/layout.dart';
import 'package:navinotes/screens/main/note_template/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/index.dart';

class NoteTemplateHeader extends StatelessWidget {
  const NoteTemplateHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteTemplateVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(color: AppTheme.vividRose),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 15,
                children: [_leading(vm), _trailing(vm)],
              ),
            ),
            Container(
              decoration: ShapeDecoration(
                color: AppTheme.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: AppTheme.lightGray),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _searchBar(),
                  VisibleController(
                    mobile: false,
                    tablet: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: _sortBy(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sortBy() {
    return WidthLimiter(
      mobile: 250,
      child: CustomInputField(
        prefixIcon: Text(
          'Sort by:',
          style: AppTheme.text.copyWith(color: AppTheme.stormGray),
        ),
        controller: TextEditingController(text: 'Most Popular'),
        selectItems: ['Most Popular', 'Date Created', 'Date Modified'],
      ),
    );
  }

  Widget _searchBar() {
    return Flexible(
      child: WidthLimiter(
        mobile: 256,
        child: CustomInputField(
          hintText: 'Search templates...',
          constraints: BoxConstraints(maxHeight: 40),
          prefixIcon: Icon(Icons.search, color: AppTheme.slateGray, size: 20),
          hintStyle: AppTheme.text.copyWith(
            color: AppTheme.slateGray,
            fontSize: 16.0,
            height: 1.50,
          ),
        ),
      ),
    );
  }

  Widget _trailing(NoteTemplateVm vm) {
    return Row(
      children: [
        VisibleController(
          mobile: false,
          tablet: true,
          child: Text(
            'NaviNotes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        VisibleController(
          mobile: true,
          desktop: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: MenuButton(
              onPressed: vm.openDrawer,
              decoration: BoxDecoration(color: AppTheme.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _leading(NoteTemplateVm vm) {
    final subtitleTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      height: 1.43,
    );
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Expanded(
          child: Row(
            spacing: 10,
            children: [
              AppButton.text(
                onTap: NavigationHelper.pop,
                prefix: Icon(Icons.arrow_back, color: AppTheme.white),
                wrapWithFlexible: true,
                spacing: 15,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Note Template',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Opacity(
                        opacity: 0.7,
                        child: Text.rich(
                          overflow: TextOverflow.ellipsis,
                          TextSpan(
                            children: [
                              TextSpan(text: 'Board', style: subtitleTextStyle),
                              TextSpan(
                                text: ' > ',
                                style: subtitleTextStyle.copyWith(fontSize: 20),
                              ),
                              TextSpan(
                                text:
                                    '${vm.board?.subject} - ${vm.board?.level}',
                                style: subtitleTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
