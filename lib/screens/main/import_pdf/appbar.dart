import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/import_pdf/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class ImportPdfAppBar extends StatelessWidget {
  const ImportPdfAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImportPdfVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: Apptheme.lightGray),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

          child: ResponsiveSection(
            mobile: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                _leading(),
                _importText(),
                MenuButton(onPressed: vm.openDrawer),
              ],
            ),
            laptop: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                _leading(),
                _importText(),
                Row(
                  children: [
                    _actions(),
                    VisibleController(
                      mobile: true,
                      desktop: false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: MenuButton(onPressed: vm.openDrawer),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _importText() {
    return Flexible(
      child: Text(
        'Import PDF',
        style: Apptheme.text.copyWith(
          fontSize: 20.0,
          fontWeight: getFontWeight(600),
        ),
      ),
    );
  }

  Widget _actions() {
    return Row(
      spacing: 10,
      children: [
        SVGImagePlaceHolder(
          imagePath: Images.ques,
          color: Apptheme.darkSlateGray,
          size: 16,
        ),
        OutlinedChild(
          decoration: BoxDecoration(
            color: Apptheme.strongBlue,
            shape: BoxShape.circle,
          ),
          size: 32,
          child: Text(
            'U',
            style: Apptheme.text.copyWith(
              color: Apptheme.white,
              fontSize: 16.0,
              fontWeight: getFontWeight(600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _leading() {
    return Flexible(
      child: InkWell(
        onTap: () => NavigationHelper.pop(),
        child: Row(
          spacing: 15,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back, color: Apptheme.darkSlateGray),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  OutlinedChild(
                    size: 32,
                    decoration: BoxDecoration(color: Apptheme.paleBlue),
                    child: Text(
                      'N',
                      style: Apptheme.text.copyWith(
                        color: Apptheme.persianBlue,
                        fontSize: 16.0,
                        fontWeight: getFontWeight(600),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      AppStrings.appName,
                      style: Apptheme.text.copyWith(
                        color: Apptheme.royalBlue,
                        fontSize: 16.0,
                        fontWeight: getFontWeight(600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
