import 'package:navinotes/packages.dart';
import 'vm.dart';

class DarkAcademiaCreateNoteAppBar extends StatelessWidget {
  const DarkAcademiaCreateNoteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkAcademiaCreateNoteVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Apptheme.royalGold.withAlpha(0x4C),
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ResponsiveHorizontalPadding(
            child: Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ResponsiveSection(
                  mobile: _leading(),
                  desktop: Flexible(child: _leading()),
                ),
                ResponsiveSection(
                  mobile: Expanded(child: _searchField()),
                  desktop: WidthLimiter(mobile: 512, child: _searchField()),
                ),

                ResponsiveSection(
                  mobile: MenuButton(
                    onPressed: vm.openEndDrawer,
                    decoration: BoxDecoration(color: Apptheme.royalGold),
                  ),
                  desktop: _actions(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _actions() {
    return Row(
      spacing: 15,
      children: [
        SVGImagePlaceHolder(
          imagePath: Images.settings,
          size: 16,
          color: Apptheme.royalGold,
        ),
        SVGImagePlaceHolder(
          imagePath: Images.filter,
          size: 18,
          color: Apptheme.royalGold,
        ),
        ProfilePic(borderColor: Apptheme.royalGold),
      ],
    );
  }

  Widget _searchField() {
    return CustomInputField(
      suffixIcon: Icon(Icons.search, color: Apptheme.royalGold, size: 16),
      hintText: 'Search notes...',
      fillColor: Apptheme.burntLeather,
      side: BorderSide(color: Apptheme.royalGold),
      style: Apptheme.text.copyWith(
        color: Apptheme.royalGold,
        fontSize: 16.0,
        fontFamily: Apptheme.fontCrimsonPro,
        height: 1.50,
      ),
      hintStyle: Apptheme.text.copyWith(
        color: Apptheme.slateGray,
        fontSize: 16.0,
        fontFamily: Apptheme.fontCrimsonPro,
        height: 1.50,
      ),
    );
  }

  Widget _leading() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        InkWell(
          onTap: NavigationHelper.pop,
          child: Icon(Icons.arrow_back, size: 24, color: Apptheme.royalGold),
        ),
        VisibleController(
          mobile: false,
          tablet: true,
          child: Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Text(
                  'N',
                  style: Apptheme.text.copyWith(
                    color: Apptheme.royalGold,
                    fontSize: 24.0,
                    fontFamily: Apptheme.fontPlayfairDisplay,
                    fontWeight: getFontWeight(700),
                    height: 1.33,
                  ),
                ),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${AppStrings.appName} /',
                          style: Apptheme.text.copyWith(
                            color: const Color(0xE5F5F5DC),
                            fontSize: 16.0,
                            fontFamily: Apptheme.fontPlayfairDisplay,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'Physics 101',
                          style: Apptheme.text.copyWith(
                            color: Apptheme.royalGold,
                            fontSize: 16.0,
                            fontFamily: Apptheme.fontPlayfairDisplay,
                            height: 1.50,
                          ),
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
    );
  }
}
