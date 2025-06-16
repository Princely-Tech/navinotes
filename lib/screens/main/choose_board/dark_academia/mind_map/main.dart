import 'package:navinotes/packages.dart';
import 'vm.dart';

class DarkAcademiaMindMapMain extends StatelessWidget {
  const DarkAcademiaMindMapMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkAcademiaMindMapVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            _header(vm),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mind map coming soon...',
                    style: Apptheme.text.copyWith(
                      fontSize: 30.0,
                      fontFamily: Apptheme.fontPlayfairDisplay,
                      color: Apptheme.royalGold,
                      height: 1.33,
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

  Widget _outlinedChild({required String img}) {
    return OutlinedChild(
      size: 40,
      decoration: BoxDecoration(
        color: Apptheme.moltenBrown,
        shape: BoxShape.circle,
      ),
      child: SVGImagePlaceHolder(
        imagePath: img,
        color: Apptheme.goldenSaffron,
        size: 16,
      ),
    );
  }

  Widget _searchField() {
    return WidthLimiter(
      mobile: 256,
      child: CustomInputField(
        suffixIcon: Icon(Icons.search, color: Apptheme.walnutBronze, size: 20),
        hintText: 'Search...',
        fillColor: Apptheme.moltenBrown.withAlpha(0x99),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: Apptheme.walnutBronze.withAlpha(0x66)),
        ),
        style: Apptheme.text.copyWith(
          color: Apptheme.royalGold,
          fontSize: 16.0,
          fontFamily: Apptheme.fontCrimsonPro,
          height: 1.50,
        ),
        hintStyle: Apptheme.text.copyWith(
          color: Apptheme.slateGray,
          fontSize: 16.0,
          fontFamily: Apptheme.fontPlayfairDisplay,
          height: 1.50,
        ),
      ),
    );
  }

  Widget _header(DarkAcademiaMindMapVm vm) {
    return Container(
      decoration: BoxDecoration(color: Apptheme.burntClove.withAlpha(255)),
      padding: EdgeInsets.all(15),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ScrollableController(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      VisibleController(
                        mobile: true,
                        desktop: false,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MenuButton(
                            decoration: BoxDecoration(
                              color: Apptheme.royalGold,
                            ),
                            onPressed: vm.openDrawer,
                          ),
                        ),
                      ),
                      Row(
                        spacing: 15,
                        children: [
                          _outlinedChild(img: Images.feather),
                          _outlinedChild(img: Images.hook),
                          _outlinedChild(img: Images.compass),
                          _searchField(),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        spacing: 15,
                        children: [
                          AppButton(
                            mainAxisSize: MainAxisSize.min,
                            onTap: () {},
                            minHeight: 34,
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 15,
                            ),
                            text: 'Share',
                            color: Apptheme.goldenSaffron.withAlpha(0x33),
                            style: Apptheme.text.copyWith(
                              color: Apptheme.goldenSaffron,
                              fontFamily: Apptheme.fontPlayfairDisplay,
                            ),
                          ),
                          _outlinedChild(img: Images.paint),
                        ],
                      ),
                      VisibleController(
                        mobile: true,
                        laptop: false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MenuButton(
                            decoration: BoxDecoration(
                              color: Apptheme.royalGold,
                            ),
                            onPressed: vm.openEndDrawer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
