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
              color: Apptheme.espressoBrown,
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
                              color: Apptheme.ivoryGlow,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'HISTORY 1302 - Semester 2',
                              style: Apptheme.text.copyWith(
                                color: Apptheme.white,
                                fontSize: getDeviceResponsiveValue(
                                  deviceType: layoutVm.deviceType,
                                  mobile: 20.0,
                                  desktop: 30.0,
                                ),
                                fontFamily: Apptheme.fontPlayfairDisplay,
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
                            color: Apptheme.caramelMist,
                            onTap: () {},
                            minHeight: 40,
                            prefix: SVGImagePlaceHolder(
                              imagePath: Images.upload,
                              size: 16.0,
                              color: Apptheme.espressoBrown,
                            ),
                            text: 'Upload Syllabus',
                            style: Apptheme.text.copyWith(
                              color: Apptheme.espressoBrown,
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
