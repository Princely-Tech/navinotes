import 'package:navinotes/packages.dart';
import 'vm.dart';

class NoteKanbanScreen extends StatelessWidget {
  NoteKanbanScreen({super.key});

  //TODO complete and match design

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteKanbanVm(),
      child: Consumer<NoteKanbanVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            backgroundColor: AppTheme.white,
            body: Column(
              spacing: 15,
              children: [
                _header(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    spacing: 15,
                    children: [
                      _titleSection(),
                      TextRowSelect(
                        items: [
                          'Board View',
                          'Timeline',
                          'Calendar',
                          'Analytics',
                        ],
                        inActiveBorderColor: AppTheme.lightGray,
                        borderColor: const Color(0xFF0284C7),
                        selected: 'Board View',
                        fillWidth: true,
                        selectedTextStyle: TextStyle(
                          color: const Color(0xFF0284C7),
                          fontSize: 16.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        style: TextStyle(
                          color: const Color(0xFF6B7280),
                          fontSize: 16.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      _buttonsSection(),
                      Expanded(
                        child: Container(
                          color: const Color(0xFFF3F4F6),
                          child: ScrollableController(
                            largeDesktop: false,
                            mobilePadding: EdgeInsets.all(15),
                            child: LayoutBuilder(
                              builder: (_, constraint) {
                                return CustomGrid(
                                  tablet: 2,
                                  laptop: 3,
                                  desktop: 4,
                                  largeDesktop: 5,
                                  wrapWithIntrinsicHeight: false,
                                  children: [
                                    _taskList(
                                      count: 3,
                                      title: 'Backlog',
                                      tag: KanbanTaskTag.notStarted,
                                      constraint: constraint,
                                    ),
                                    _taskList(
                                      count: 4,
                                      title: 'To Do',
                                      tag: KanbanTaskTag.ready,
                                      constraint: constraint,
                                    ),
                                    _taskList(
                                      count: 2,
                                      title: 'In Progress',
                                      tag: KanbanTaskTag.inProgress,
                                      constraint: constraint,
                                    ),
                                    _taskList(
                                      count: 1,
                                      title: 'Review',
                                      tag: KanbanTaskTag.needsReview,
                                      constraint: constraint,
                                    ),
                                    _taskList(
                                      count: 3,
                                      title: 'Done',
                                      tag: KanbanTaskTag.completed,
                                      constraint: constraint,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _taskList({
    required String title,
    required int count,
    required KanbanTaskTag tag,
    required BoxConstraints constraint,
  }) {
    double height = 500;
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          constraints: BoxConstraints(
            minHeight: getDeviceResponsiveValue(
              deviceType: layoutVm.deviceType,
              mobile: height,
              largeDesktop: 0.0,
            ),
            maxHeight: getDeviceResponsiveValue(
              deviceType: layoutVm.deviceType,
              mobile: height,
              largeDesktop: constraint.maxHeight,
            ),
          ),
          child: Column(
            children: [
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 4,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                        OutlinedChild(
                          size: 23,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE5E7EB),
                          ),
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(Icons.more_vert, size: 24, color: AppTheme.steelMist),
                ],
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray.withAlpha(150),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        child: ScrollableController(
                          mobilePadding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            spacing: 10,
                            children:
                                List.generate(
                                  count,
                                  (_) => _taskItem(tag),
                                ).toList(),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: CustomCard(
                          dottedDecoration: DottedDecoration(),
                          decoration: BoxDecoration(
                            color: AppTheme.transparent,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          child: Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 24,
                                color: const Color(0xFF6B7280),
                              ),
                              Flexible(
                                child: Text(
                                  'Add Task',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF6B7280),
                                    fontSize: 16.0,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  Widget _taskItem(KanbanTaskTag tag) {
    Color tagColor = Color(0xFFF3F4F6);
    Color tagTextColor = Color(0xFF4B5563);
    Color borderColor = Color(0xFFD1D5DB);
    TextDecoration? titleDecoration;
    switch (tag) {
      case KanbanTaskTag.completed:
        titleDecoration = TextDecoration.lineThrough;
        borderColor = const Color(0xFF22C55E);
        tagColor = const Color(0xFF22C55E);
        tagTextColor = AppTheme.white;
      case KanbanTaskTag.needsReview:
        borderColor = const Color(0xFFF97316);
        tagColor = const Color(0xFFFFEDD5);
        tagTextColor = const Color(0xFFEA580C);
      // case KanbanTaskTag.completed:
      //   borderColor = const Color(0xFF22C55E);
      //   tagColor = const Color(0xFF22C55E);
      //   tagTextColor = AppTheme.white;
      // case KanbanTaskTag.completed:
      //   borderColor = const Color(0xFF22C55E);
      //   tagColor = const Color(0xFF22C55E);
      //   tagTextColor = AppTheme.white;
      // case KanbanTaskTag.completed:
      //   borderColor = const Color(0xFF22C55E);
      //   tagColor = const Color(0xFF22C55E);
      //   tagTextColor = AppTheme.white;
      default:
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(width: 4, color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10,
              runSpacing: 5,
              children: [
                Text(
                  'Define research question',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    decoration: titleDecoration,
                  ),
                ),
                CustomTag(
                  borderRadius: BorderRadius.circular(4),
                  tag.toString(),
                  color: tagColor,
                  textColor: tagTextColor,
                ),
              ],
            ),
          ),

          Text(
            'Develop clear, focused research question for psychology paper',
            style: TextStyle(
              fontSize: 14.0,
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w400,
            ),
          ),

          // Tags
          Wrap(
            spacing: 8,
            children: [
              _tagChip(
                label: 'Planning',
                color: Color(0xFFDBEAFE),
                textColor: Color(0xFF1D4ED8),
              ),
              _tagChip(
                label: 'High Priority',
                color: Color(0xFFFEE2E2),
                textColor: Color(0xFFB91C1C),
              ),
            ],
          ),

          // Due info and Estimate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: Color(0xFF6B7280)),
                  SizedBox(width: 4),
                  Text(
                    'Due in 2 days',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.schedule, size: 12, color: Color(0xFF6B7280)),
                  SizedBox(width: 4),
                  Text(
                    'Est. 2 hours',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tagChip({
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.0,
          color: textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buttonsSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: AppTheme.lightGray),
        ),
      ),
      child: Row(
        spacing: 15,
        children: [
          Expanded(
            child: Row(
              spacing: 15,
              children: [
                AppButton(
                  onTap: () {},
                  text: 'Add Task',
                  wrapWithFlexible: true,
                  mainAxisSize: MainAxisSize.min,
                  color: const Color(0xFF0284C7),
                  prefix: Icon(Icons.add, color: AppTheme.white),
                  minHeight: 38,
                ),
                AppButton.secondary(
                  onTap: () {},
                  text: 'Filter',
                  minHeight: 38,
                  wrapWithFlexible: true,
                  mainAxisSize: MainAxisSize.min,
                  color: AppTheme.lightGray,
                  textColor: AppTheme.darkSlateGray,
                  prefix: SVGImagePlaceHolder(
                    imagePath: Images.filter,
                    color: AppTheme.darkSlateGray,
                    size: 16,
                  ),
                ),
                AppButton.secondary(
                  onTap: () {},
                  text: 'Sort',
                  minHeight: 38,
                  wrapWithFlexible: true,
                  mainAxisSize: MainAxisSize.min,
                  color: AppTheme.lightGray,
                  textColor: AppTheme.darkSlateGray,
                  prefix: SVGImagePlaceHolder(
                    imagePath: Images.arrowVer,
                    color: AppTheme.darkSlateGray,
                    size: 16,
                  ),
                ),
                AppButton.secondary(
                  onTap: () {},
                  text: 'View',
                  minHeight: 38,
                  wrapWithFlexible: true,
                  mainAxisSize: MainAxisSize.min,
                  color: AppTheme.lightGray,
                  textColor: AppTheme.darkSlateGray,
                  prefix: SVGImagePlaceHolder(
                    imagePath: Images.eye,
                    color: AppTheme.darkSlateGray,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),

          VisibleController(
            mobile: false,
            laptop: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                spacing: 15,
                children: [
                  Builder(
                    builder: (context) {
                      final richStyle = TextStyle(
                        color: const Color(0xFF4B5563),
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.43,
                      );
                      final style = TextStyle(
                        color: const Color(0xFF4B5563),
                        fontSize: 14.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      );
                      return Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '14 ', style: richStyle),
                            TextSpan(text: 'tasks • ', style: style),
                            TextSpan(text: '5 ', style: richStyle),
                            TextSpan(text: 'completed', style: style),
                          ],
                        ),
                      );
                    },
                  ),
                  AppButton.text(
                    onTap: () {},
                    text: 'Switch Template',
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.refresh2,
                      color: const Color(0xFF0284C7),
                      size: 16,
                    ),
                    color: const Color(0xFF0284C7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelText(
    String text, {
    Color color = const Color(0xFF6B7280),
    required String icon,
  }) {
    return Flexible(
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          SVGImagePlaceHolder(imagePath: icon, color: color, size: 12),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 7,
            children: [
              Text(
                'Psychology Research Paper',
                style: TextStyle(
                  color: const Color(0xFF1F2937),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                spacing: 16,
                children: [
                  _labelText('Academic Project', icon: Images.cap),
                  _labelText('Psychology 101', icon: Images.book),
                  _labelText(
                    'Due in 14 days',
                    color: Color(0xFFEF4444),
                    icon: Images.clock,
                  ),
                ],
              ),
            ],
          ),
        ),

        VisibleController(
          mobile: false,
          laptop: true,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              spacing: 16,
              children: [
                OverlappingAvatars(
                  avatars: [
                    _avatar(initials: 'JD', color: Color(0xFF3B82F6)),
                    _avatar(initials: 'KL', color: Color(0xFFA855F7)),
                    _avatar(initials: 'TS', color: Color(0xFF22C55E)),
                    _avatar(color: Color(0xFFF3F4F6)),
                  ],
                ),

                // Divider
                Container(width: 1, height: 32, color: Color(0xFFD1D5DB)),

                AppButton.text(
                  onTap: () {},
                  text: 'Board Settings',
                  color: Color(0xFF4B5563),
                  prefix: SVGImagePlaceHolder(
                    imagePath: Images.pref,
                    color: const Color(0xFF4B5563),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatar({String? initials, required Color color}) {
    return OutlinedChild(
      size: 32,

      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      // alignment: Alignment.center,
      child:
          isNotNull(initials)
              ? Text(
                initials!,
                style: TextStyle(color: Colors.white, fontSize: 14),
              )
              : Icon(Icons.add, color: AppTheme.darkSlateGray),
    );
  }

  // Widget IconBox({double size = 12.25}) {
  //   return Container(
  //     width: size,
  //     height: size,
  //     decoration: BoxDecoration(
  //       border: Border.all(color: const Color(0xFFE5E7EB)),
  //       borderRadius: BorderRadius.circular(2),
  //     ),
  //   );
  // }

  Widget _header() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppButton.text(
                  text: 'Study Tools',
                  onTap: NavigationHelper.pop,
                  color: Color(0xFF4B5563),
                  prefix: Icon(Icons.arrow_back, color: AppTheme.darkSlateGray),
                ),
                Container(width: 1, height: 24, color: Color(0xFFD1D5DB)),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kanban Board',
                        style: TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.56,
                        ),
                      ),

                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Research Paper Project',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                              ),
                            ),
                            TextSpan(
                              text: ' • ',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                              ),
                            ),
                            TextSpan(
                              text: 'Academic Project Management',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14.0,
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
              ],
            ),
          ),

          VisibleController(
            mobile: false,
            laptop: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                spacing: 16,
                children: [
                  Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: const Color(0xFF22C55E),
                        size: 16,
                      ),
                      Text(
                        'Auto-saved',
                        style: TextStyle(
                          color: const Color(0xFF6B7280),
                          fontSize: 14.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  AppButton.secondary(
                    onTap: () {},
                    mainAxisSize: MainAxisSize.min,
                    text: 'Export Board',
                    color: AppTheme.lightGray,
                    textColor: AppTheme.darkSlateGray,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.exportFile,
                      size: 16,
                      color: AppTheme.darkSlateGray,
                    ),
                  ),

                  AppButton.secondary(
                    onTap: () {},
                    color: AppTheme.lightGray,
                    child: SVGImagePlaceHolder(
                      imagePath: Images.settings,
                      size: 16,
                      color: AppTheme.darkSlateGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
