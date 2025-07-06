import 'package:navinotes/packages.dart';
import 'vm.dart';

class BoardPlainMindMapMain extends StatelessWidget {
  const BoardPlainMindMapMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardPlainMindMapVm>(
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
                    style: AppTheme.text.copyWith(
                      fontSize: 30.0,
                      color: AppTheme.asbestos,
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

  Widget _imgComponent({required String img}) {
    return SVGImagePlaceHolder(
      imagePath: img,
      color: AppTheme.asbestos,
      size: 16,
    );
  }

  Widget _searchField() {
    return WidthLimiter(
      mobile: 200,
      child: CustomInputField(
        suffixIcon: Icon(Icons.search, color: AppTheme.asbestos, size: 20),
        hintText: 'Search',
      ),
    );
  }

  Widget _header(BoardPlainMindMapVm vm) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
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
                            decoration: BoxDecoration(color: AppTheme.asbestos),
                            onPressed: vm.openDrawer,
                          ),
                        ),
                      ),
                      Row(
                        spacing: 15,
                        children: [
                          _imgComponent(img: Images.edit),
                          _imgComponent(img: Images.hook),
                          _imgComponent(img: Images.sdCard),
                          _searchField(),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AppButton.secondary(
                        mainAxisSize: MainAxisSize.min,
                        onTap: () {},
                        minHeight: 34,
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 15,
                        ),
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.share2,
                          color: AppTheme.black,
                          size: 16,
                        ),
                        text: 'Share',
                        color: AppTheme.lightGray,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.wetAsphalt,
                        ),
                      ),
                      VisibleController(
                        mobile: true,
                        laptop: false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MenuButton(
                            decoration: BoxDecoration(color: AppTheme.asbestos),
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
