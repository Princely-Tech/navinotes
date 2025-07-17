import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/compare_contrast/vm.dart';

class NoteCompareContrastHeader extends StatelessWidget {
  const NoteCompareContrastHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(color: AppTheme.white),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return ScrollableController(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _leading(),
                  SizedBox(width: 10),
                  _title(),
                  _trailing(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _trailing() {
    return Consumer<NoteCompareContrastVm>(
      builder: (_, vm, _) {
        return Row(
          children: [
            VisibleController(
              mobile: false,
              laptop: true,
              child: Row(
                spacing: 5,
                children: [
                  AppButton.secondary(
                    onTap: () {},
                    text: 'Export Comparison',
                    textColor: const Color(0xFF374151),
                    minHeight: 40,
                    color: AppTheme.lightGray,
                    mainAxisSize: MainAxisSize.min,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.exportFile,
                      color: AppTheme.darkSlateGray,
                      size: 16,
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: SVGImagePlaceHolder(
                      imagePath: Images.settings,
                      color: AppTheme.darkSlateGray,
                      size: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SVGImagePlaceHolder(
                      imagePath: Images.iIcon,
                      color: AppTheme.darkSlateGray,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            // VisibleController(
            //   mobile: true,
            //   largeDesktop: false,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 10),
            //     child: MenuButton(onPressed: vm.openDrawer),
            //   ),
            // ), //TODO Bring back
          ],
        );
      },
    );
  }

  Widget _title() {
    return Column(
      spacing: 5,
      children: [
        Text(
          'Compare & Contrast',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        Text(
          'Biology 101 - Cell Types',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
      ],
    );
  }

  Widget _leading() {
    return AppButton.text(
      onTap: NavigationHelper.pop,
      text: 'Study Tools',
      prefix: Icon(Icons.arrow_back, color: AppTheme.darkSlateGray),
      style: TextStyle(
        color: const Color(0xFF374151),
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
