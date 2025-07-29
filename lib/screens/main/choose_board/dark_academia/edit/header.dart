import 'package:navinotes/packages.dart';

// List<String> darkAcadEditLinks = ['Overview', 'Uploads', 'Assignments'];
// String selectedLink = darkAcadEditLinks.first;

class DarkAcademiaEditHeader extends StatelessWidget {
  const DarkAcademiaEditHeader({super.key, required this.board});
  final Board board;
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiServiceProvider>(
      builder: (_, apiServiceProvider, _) {
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
                                onPressed: vm.openDrawer,
                                decoration: BoxDecoration(
                                  color: AppTheme.ivoryGlow,
                                ),
                              ),
                              AppIconButton(
                                onPressed: NavigationHelper.pop,
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: AppTheme.white,
                                  size: 18,
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
                                items:
                                    EditBoardTab.values
                                        .map((item) => item.toString())
                                        .toList(),
                                onSelected: (value) {
                                  vm.updateSelectedTab(
                                    stringToEnum<EditBoardTab>(
                                      value,
                                      EditBoardTab.values,
                                    ),
                                  );
                                },
                              ),
                              AppButton(
                                mainAxisSize: MainAxisSize.min,
                                color: AppTheme.caramelMist,
                                loading: vm.uploadingSyllabus,
                                onTap:
                                    () => vm.uploadSyllabus(
                                      context: context,
                                      apiServiceProvider: apiServiceProvider,
                                    ),
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
      },
    );
  }
}
