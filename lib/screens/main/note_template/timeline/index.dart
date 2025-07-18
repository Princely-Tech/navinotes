import 'package:navinotes/packages.dart';
import 'vm.dart';

final labelStyle = TextStyle(
  color: const Color(0xFF374151),
  fontSize: 14,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
);

class NoteTimelineScreen extends StatelessWidget {
  NoteTimelineScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteTimelineVm(),
      child: Consumer<NoteTimelineVm>(
        builder: (context, vm, child) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            body: Column(
              children: [
                _header(),
                Expanded(
                  child: ScrollableController(
                    mobilePadding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: ResponsiveHorizontalPadding(
                            child: WidthLimiter(
                              mobile: largeDesktopSize,
                              child: Column(
                                children: [
                                  _builderForm(),
                                  //
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _builderForm() {
    return CustomCard(
      addBorder: true,
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleOne('Timeline Project Builder'),
          CustomGrid(
            largeDesktop: 2,
            wrapWithIntrinsicHeight: false,
            children: [_projectInfo(), _styleSelection()],
          ),
          _contentSourceIntegration(),
        ],
      ),
    );
  }

  Widget _contentSourceIntegration() {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleTwo('Content Source Integration'),
        CustomGrid(
          largeDesktop: 4,
          children: [
            _sourceItem(
              body: 'Direct event creation',
              icon: Images.keyboard,
              title: 'Manual Entry',
              isActive: true,
            ),
            _sourceItem(
              body: 'Pull from course notes',
              icon: Images.file,
              title: 'Import from Notes',
            ),
            _sourceItem(
              body: 'Add from external sources',
              icon: Images.search,
              title: 'Research Integration',
            ),
            _sourceItem(
              body: 'Team-based building',
              icon: Images.people,
              title: 'Collaborative Input',
            ),
          ],
        ),
      ],
    );
  }

  Widget _sourceItem({
    required String title,
    required String body,
    required String icon,
    bool isActive = false,
  }) {
    final textColor =
        isActive ? const Color(0xFF0369A1) : const Color(0xFF374151);
    return Container(
      decoration: ShapeDecoration(
        color: isActive ? const Color(0xFFF0F9FF) : null,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isActive ? Color(0xFF0EA5E9) : AppTheme.lightGray,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        spacing: 8, // spacing between elements
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SVGImagePlaceHolder(
            imagePath: icon,
            color: isActive ? const Color(0xFF0369A1) : const Color(0xFF374151),
            size: 20,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _styleSelection() {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleTwo('Visual Style Selection'),

        CustomGrid(
          largeDesktop: 2,
          laptop: 1,
          children: [
            CustomInputField(label: 'Layout Options', labelStyle: labelStyle),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CustomInputField()],
            ),
            CustomInputField(),
            CustomInputField(),
          ],
        ),

        CustomInputField(label: 'Design Theme', labelStyle: labelStyle),

        CustomGrid(
          laptop: 1,
          children: [
            CustomInputField(label: 'Color Scheme', labelStyle: labelStyle),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CustomInputField()],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CustomInputField()],
            ),
          ],
        ),

        CustomInputField(label: 'Scale Options', labelStyle: labelStyle),
      ],
    );
  }

  Widget _projectInfo() {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleTwo('Project Information'),
        CustomInputField(
          label: 'Timeline Title',
          hintText: 'Major Events of World War II',
          labelStyle: labelStyle,
        ),
        CustomInputField(label: 'Subject/Category', labelStyle: labelStyle),

        CustomGrid(
          largeDesktop: 2,
          laptop: 1,
          children: [CustomInputField(), CustomInputField()],
        ),

        CustomGrid(
          largeDesktop: 2,
          laptop: 1,
          children: [
            CustomInputField(label: 'Timeline Type', labelStyle: labelStyle),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CustomInputField()],
            ),
            CustomInputField(),
            CustomInputField(),
          ],
        ),
      ],
    );
  }

  Widget _titleTwo(String text) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF374151),
        fontSize: 18,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        height: 1.56,
      ),
    );
  }

  Widget _titleOne(String text) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF1F2937),
        fontSize: 20,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ResponsiveHorizontalPadding(
              child: WidthLimiter(
                mobile: largeDesktopSize,
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            spacing: 15,
                            children: [
                              AppButton.text(
                                onTap: NavigationHelper.pop,
                                text: 'Study Tools',
                                color: const Color(0xFF4B5563),
                                prefix: Icon(
                                  Icons.arrow_back,
                                  color: AppTheme.darkSlateGray,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Timeline Builder',
                                  style: TextStyle(
                                    color: const Color(0xFF1F2937),
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1.40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        VisibleController(
                          mobile: false,
                          tablet: true,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              spacing: 20,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      'Auto-saved',
                                      style: TextStyle(
                                        color: const Color(0xFF6B7280),
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.43,
                                      ),
                                    ),
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF22C55E),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),

                                AppButton(
                                  onTap: () {},
                                  mainAxisSize: MainAxisSize.min,
                                  color: const Color(0xFF0284C7),
                                  prefix: SVGImagePlaceHolder(
                                    imagePath: Images.exportFile,
                                    color: AppTheme.white,
                                    size: 16,
                                  ),
                                  text: 'Export Timeline',
                                ),

                                SVGImagePlaceHolder(
                                  imagePath: Images.settings,
                                  color: AppTheme.darkSlateGray,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Current project: ',
                            style: TextStyle(
                              color: const Color(0xFF4B5563),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          TextSpan(
                            text: 'World War II Timeline',
                            style: TextStyle(
                              color: const Color(0xFF4B5563),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                          TextSpan(
                            text: ' • ',
                            style: TextStyle(
                              color: const Color(0xFF4B5563),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),

                          TextSpan(
                            text: 'Type: ',
                            style: TextStyle(
                              color: const Color(0xFF4B5563),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),

                          TextSpan(
                            text: 'Historical Analysis',
                            style: TextStyle(
                              color: const Color(0xFF4B5563),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
