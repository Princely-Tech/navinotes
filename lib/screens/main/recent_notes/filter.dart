import 'package:navinotes/packages.dart';
import 'vm.dart';

class RecentNotesFilter extends StatelessWidget {
  const RecentNotesFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentNotesVm>(
      builder: (_, vm, _) {
        return Row(
          children: [
            ExpandableController(
              mobile: true,
              laptop: false,
              child: Text(
                'Recent Notes ${vm.hasData ? '(12)' : ''}',
                style: AppTheme.text.copyWith(
                  fontSize: 24.0,
                  fontWeight: getFontWeight(600),
                ),
              ),
            ),

            VisibleController(
              mobile: false,
              laptop: vm.hasData,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IntrinsicHeight(
                    child: Row(
                      spacing: 15,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _sortBy(),
                        AppButton(
                          wrapWithFlexible: true,
                          mainAxisSize: MainAxisSize.min,
                          prefix: SVGImagePlaceHolder(imagePath: Images.filter),
                          onTap: () {},
                          color: AppTheme.white,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.stormGray,
                          ),
                          minHeight: 35,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(color: AppTheme.coolGray),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          text: 'Filter',
                        ),
                        _searchRecent(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _searchRecent() {
    return WidthLimiter(
      mobile: 210,
      child: CustomInputField(
        hintText: 'Search recent notes...',
        hintStyle: AppTheme.text.copyWith(color: AppTheme.slateGray),
        constraints: BoxConstraints(maxHeight: 35),
        prefixIcon: Icon(Icons.search, color: AppTheme.slateGray),
      ),
    );
  }

  Widget _sortBy() {
    return WidthLimiter(
      mobile: 205,
      child: CustomInputField(
        hintText: 'Most Recent',
        controller: TextEditingController(text: 'Most Recent'),
        selectItems: ['Most Recent', 'Date Created'],
        style: AppTheme.text.copyWith(color: AppTheme.darkSlateGray),
        constraints: BoxConstraints(maxHeight: 35),
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sort by:',
              textAlign: TextAlign.center,
              style: AppTheme.text.copyWith(color: AppTheme.darkSlateGray),
            ),
          ],
        ),
      ),
    );
  }
}
