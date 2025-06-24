import 'package:navinotes/packages.dart';
import 'vm.dart';

class DarkAcademiaEditHeader extends StatelessWidget {
  const DarkAcademiaEditHeader({super.key});
  //TODO work on mobil responsive sidebar
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkAcademiaEditVM>(
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
                          Expanded(
                            child: Text(
                              'HISTORY 1302 - Semester 2',
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
                            selected: vm.selectedLink,
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
