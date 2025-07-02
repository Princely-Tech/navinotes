import 'package:navinotes/packages.dart';
import 'vm.dart';

class MyStoreAppBar extends StatelessWidget {
  const MyStoreAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.white,
        // border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: WidthLimiter(
              mobile: largeDesktopSize,
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return Consumer<MyStoreVm>(
                    builder: (_, vm, _) {
                      return ScrollableController(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 20,
                              children: [
                                RichTextHeader(title: 'My Store'),
                                _trailing(vm),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return CustomInputField(
      prefixIcon: Icon(Icons.search, color: AppTheme.blueGray, size: 20),
      hintText: 'Search store',
      fillColor: AppTheme.lightAsh,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide.none,
      ),
      hintStyle: AppTheme.text.copyWith(
        color: AppTheme.slateGray,
        height: 1.43,
      ),
    );
  }

  Widget _trailing(MyStoreVm vm) {
    return Row(
      children: [
        VisibleController(
          mobile: false,
          laptop: true,
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: WidthLimiter(mobile: 256, child: _searchField()),
          ),
        ),
        Row(
          spacing: 10,
          children: [
            Icon(Icons.notifications_none, color: AppTheme.darkSlateGray),
            ProfilePic(size: 32),
          ],
        ),
        VisibleController(
          mobile: true,
          desktop: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: MenuButton(onPressed: vm.openEndDrawer),
          ),
        ),
      ],
    );
  }
}
