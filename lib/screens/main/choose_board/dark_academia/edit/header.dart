import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/choose_board/common/edit_vm.dart';


List<String> darkAcadEditLinks = ['Overview', 'Uploads', 'Assignments'];
String selectedLink = darkAcadEditLinks.first;

class DarkAcademiaEditHeader extends StatelessWidget {
  const DarkAcademiaEditHeader({super.key, required this.board});
  final Board board;
  //TODO work on mobil responsive sidebar
  @override
  Widget build(BuildContext context) {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return Consumer<LayoutProviderVm>(
          builder: (_, layoutVm, _) {
            return Container(
              color: AppTheme.espressoBrown,
              child: ResponsivePadding(
                mobile: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                tablet: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          MenuButton(
                            onPressed: () {},
                            decoration: BoxDecoration(
                              color: AppTheme.ivoryGlow,
                            ),
                          ),
                          AppButton.text(
                            wrapWithFlexible: true,
                            mainAxisSize: MainAxisSize.min,
                            prefix: Icon(
                              Icons.arrow_back,
                              color: AppTheme.white,
                              size: 18,
                            ),
                            onTap: NavigationHelper.pop,
                            text: '',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.white,
                              fontWeight: getFontWeight(300),
                              height: 1.43,
                              letterSpacing: 0.70,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              board.name,
                              style: AppTheme.text.copyWith(
                                color: AppTheme.white,
                                fontSize: getDeviceResponsiveValue(
                                  deviceType: layoutVm.deviceType,
                                  mobile: 20.0,
                                  desktop: 30.0,
                                ),
                                fontFamily: AppTheme.fontPlayfairDisplay,
                                height: 1.20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    VisibleController(
                      mobile: false,
                      laptop: true,
                      child: Row(
                        children: [
                          TextRowSelect(
                            items: darkAcadEditLinks,
                            selected: selectedLink,
                          ),
                          AppButton(
                            mainAxisSize: MainAxisSize.min,
                            color: AppTheme.caramelMist,
                            onTap: () {},
                            minHeight: 40,
                            prefix: SVGImagePlaceHolder(
                              imagePath: Images.upload,
                              size: 16.0,
                              color: AppTheme.espressoBrown,
                            ),
                            text: 'Upload Syllabus',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.espressoBrown,
                              fontSize: 16.0,
                              fontWeight: getFontWeight(500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
