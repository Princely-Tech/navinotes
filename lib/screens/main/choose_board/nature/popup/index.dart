import 'package:navinotes/packages.dart';

class BoardNaturePopupScreen extends StatelessWidget {
  const BoardNaturePopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      backgroundColor: const Color(0xFFF8F6F0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSection(),
            _heroSection(),
            _courseActions(),
            _fileUploadsSection(),
            _studyTemplateSection(),
            _semesterJourney(),
            // Semester Journey Section
            Container(
              color: const Color(0xFF2D5016),
              padding: EdgeInsets.symmetric(vertical: 64, horizontal: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Semester Journey',
                        style: TextStyle(
                          color: const Color(0xFFF8F6F0),
                          fontSize: 30,
                          fontFamily: 'Crimson Text',
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                  Divider(color: Colors.white.withValues(alpha: 0.5)),
                  SizedBox(height: 32),
                  _buildTimelineItem(
                    title: 'Week 1-2: Ecosystem Foundations',
                    description:
                        'Examine the building blocks of natural systems',
                    assignment: 'Assignment: Local Ecosystem Analysis',
                    dueDate: 'Due: September 15, 2025',
                    color: const Color(0xFF4A7C59),
                    alignment: CrossAxisAlignment.start,
                  ),
                  SizedBox(height: 32),
                  _buildTimelineItem(
                    title: 'Week 3-4: Climate Science',
                    description:
                        'Understanding atmospheric and oceanic systems',
                    assignment: 'Assignment: Climate Data Research Project',
                    dueDate: 'Due: October 1, 2025',
                    color: const Color(0xFF8B7355),
                    alignment: CrossAxisAlignment.end,
                  ),
                  SizedBox(height: 32),
                  _buildTimelineItem(
                    title: 'Week 5-6: Conservation Biology',
                    description:
                        'Biodiversity preservation and restoration methods',
                    assignment: 'Assignment: Species Conservation Plan',
                    dueDate: 'Due: October 15, 2025',
                    color: const Color(0xFF9CAF88),
                    alignment: CrossAxisAlignment.start,
                  ),
                ],
              ),
            ),

            // Course Information Section
            Container(
              color: const Color(0xFF8B7355),
              padding: EdgeInsets.symmetric(vertical: 64, horizontal: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Course Information',
                        style: TextStyle(
                          color: const Color(0xFFF8F6F0),
                          fontSize: 30,
                          fontFamily: 'Crimson Text',
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                  Divider(color: Colors.white.withValues(alpha: 0.5)),
                  SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Professor Information',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Crimson Text',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              Row(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "https://placehold.co/60x60",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dr. Sarah Chen',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Environmental Sciences Department',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 14,
                                            color: Colors.white.withValues(
                                              alpha: 0.7,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'AI-populated from syllabus',
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.7,
                                              ),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              _buildInfoItem(
                                Icons.email,
                                's.chen@university.edu',
                              ),
                              _buildInfoItem(
                                Icons.location_on,
                                'Environmental Sciences Building, Room 304',
                              ),
                              _buildInfoItem(
                                Icons.schedule,
                                'Office Hours: Tuesdays & Thursdays, 2:00-4:00 PM',
                              ),
                              _buildInfoItem(Icons.phone, '(555) 123-4567'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 32),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.school, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Class Information',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Crimson Text',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              _buildInfoItem(
                                Icons.calendar_today,
                                'Schedule: MWF 10:00-11:30 AM',
                              ),
                              _buildInfoItem(
                                Icons.room,
                                'Location: Science Complex, Room 150',
                              ),
                              _buildInfoItem(
                                Icons.date_range,
                                'Semester: Spring 2025',
                              ),
                              _buildInfoItem(
                                Icons.credit_card,
                                'Credits: 4 credit hours',
                              ),
                              SizedBox(height: 24),
                              Text(
                                'Quick Links',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildQuickLinkButton(
                                    'Syllabus',
                                    Icons.description,
                                  ),
                                  _buildQuickLinkButton(
                                    'Academic Calendar',
                                    Icons.calendar_month,
                                  ),
                                  _buildQuickLinkButton(
                                    'Library Resources',
                                    Icons.library_books,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _semesterJourney(){
  return Container();
}
  Widget _studyTemplateSection() {
    return _section(
      title: 'Study Templates',
      child: CustomGrid(
        children: [
          _sectionCard(
            title: 'Observation Log',
            description:
                'Template for documenting environmental field research',
            lastUsed: 'Last used 3 days ago',
            color: const Color(0xFF2D5016),
            imageUrl: Images.boardNatureObservationLog,
          ),
          _sectionCard(
            title: 'Data Collection Sheet',
            description: 'Framework for assessing human impact on ecosystems',
            lastUsed: 'Last used 1 week ago',
            color: const Color(0xFF4A7C59),
            imageUrl: Images.boardNatureDataCollection,
          ),
          _sectionCard(
            title: 'Research Proposal',
            description:
                'Template for developing environmental conservation plans',
            lastUsed: 'Last used 2 weeks ago',
            color: const Color(0xFF8B7355),
            imageUrl: Images.boardNatureResearchPaper,
          ),
        ],
      ),
    );
  }

  Widget _fileUploadsSection() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Images.boardNatureFileUploadBg),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveHorizontalPadding(
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xE5F8F6F0),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 25,
                offset: Offset(0, 20),
              ),
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 10,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: Text(
                      'File Uploads',
                      style: TextStyle(
                        color: const Color(0xFF2D5016),
                        fontSize: 30,
                        fontFamily: 'Crimson Text',
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0x339CAF88),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: const Color(0xFF4A7C59),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'AI Organized',
                          style: TextStyle(
                            color: const Color(0xFF4A7C59),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              ScrollableController(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 16,
                  children: [
                    _buildFileCard(
                      title: 'Climate Change Module',
                      description:
                          'Comprehensive analysis of global warming impacts',
                      tag: 'Week 1-4 readings',
                      icon: Icons.description,
                      color: const Color(0xFF2D5016),
                    ),
                    _buildFileCard(
                      title: 'Ecosystem Dynamics',
                      description:
                          'Biodiversity and habitat conservation studies',
                      tag: 'Interactive simulations',
                      icon: Icons.science,
                      color: const Color(0xFF4A7C59),
                    ),
                    _buildFileCard(
                      title: 'Sustainability Practices',
                      description:
                          'Green technology and renewable energy research',
                      tag: 'Case study collection',
                      icon: Icons.eco,
                      color: const Color(0xFF8B7355),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({required Widget child, required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveHorizontalPadding(
        child: Column(
          spacing: 32,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF2D5016),
                    fontSize: 30,
                    fontFamily: 'Crimson Text',
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Divider(
                    color: const Color(0xFF9CAF88).withValues(alpha: 0.5),
                    height: 1,
                  ),
                ),
                SizedBox(width: 15),
                SVGImagePlaceHolder(imagePath: Images.leaf, size: 16),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _courseActions() {
    return _section(
      title: 'Course Actions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomGrid(
            children: [
              _sectionCard(
                title: 'Create Note',
                description:
                    'Create organized notes for your environmental studies',
                buttonText: 'New Note',
                color: const Color(0xFF2D5016),
                imageUrl: Images.boardNatureCreateNote,
              ),
              _sectionCard(
                title: 'Import PDF',
                description: 'Add research papers and reference materials',
                buttonText: 'Upload PDF',
                color: const Color(0xFF8B7355),
                imageUrl: Images.boardNatureImportPdf,
              ),
              _sectionCard(
                title: 'Import Files',
                description: 'Upload documents, images, and presentations',
                buttonText: 'Add Files',
                color: const Color(0xFF9CAF88),
                imageUrl: Images.boardNatureImportFiles,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroSection() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.boardNatureLandscape),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 40),
          child: ResponsiveHorizontalPadding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidthLimiter(
                  mobile: 800,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Environmental Systems & Sustainability',
                        style: TextStyle(
                          color: const Color(0xFFF8F6F0),
                          fontSize: getDeviceResponsiveValue(
                            deviceType: layoutVm.deviceType,
                            mobile: 30,
                            tablet: 35,
                            laptop: 40,
                            desktop: 48,
                          ),
                          fontFamily: 'Crimson Text',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Dive into the intricate relationships between natural systems and human impact, exploring conservation strategies and sustainable practices from local ecosystems to global climate patterns.',
                        style: TextStyle(
                          color: const Color(0xE5F8F6F0),
                          fontSize: 20,
                          fontFamily: 'Crimson Text',
                          fontWeight: FontWeight.w400,
                          height: 1.65,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 48),
                Row(
                  spacing: 16,
                  children: [
                    AppButton(
                      wrapWithFlexible: true,
                      onTap: () {},
                      text: 'View All Notes',
                      color: const Color(0xFF4A7C59),
                      mainAxisSize: MainAxisSize.min,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      minHeight: 40,
                      spacing: 10,
                      prefix: SVGImagePlaceHolder(
                        imagePath: Images.book2,
                        color: AppTheme.white,
                        size: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    AppButton(
                      wrapWithFlexible: true,
                      onTap: () {},
                      text: 'View Syllabus',
                      color: const Color(0xCC8B7355),
                      mainAxisSize: MainAxisSize.min,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      minHeight: 40,
                      spacing: 10,
                      prefix: SVGImagePlaceHolder(
                        imagePath: Images.file,
                        color: AppTheme.white,
                        size: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
                Container(
                  width: 448,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0x33F8F6F0),
                    border: Border.all(
                      width: 1,
                      color: const Color(0x4CF8F6F0),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7C59),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Icon(Icons.calendar_today, color: Colors.white),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next Class',
                            style: TextStyle(
                              color: const Color(0xFFF8F6F0),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                          Text(
                            'Wednesday, 10:00-11:30 AM',
                            style: TextStyle(
                              color: const Color(0xCCF8F6F0),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          Text(
                            'Science Complex, Room 150',
                            style: TextStyle(
                              color: const Color(0xCCF8F6F0),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ],
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
  }

  Widget _headerSection() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.boardNatureHeader),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              begin: Alignment(0.00, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [const Color(0xB22D5016), const Color(0x4C2D5016)],
            ),
          ),
          child: ResponsivePadding(
            mobile: EdgeInsets.symmetric(vertical: 32),
            laptop: EdgeInsets.only(top: 32, bottom: 50),
            desktop: EdgeInsets.only(top: 32, bottom: 80),
            child: ResponsiveHorizontalPadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            MenuButton(
                              onPressed: () {},
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F6F0),
                              ),
                            ),
                            AppIconButton(
                              onPressed: NavigationHelper.pop,
                              icon: Icon(
                                Icons.arrow_back,
                                color: const Color(0xFFF8F6F0),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'ENVIRONMENTAL SCIENCE 2401',
                                style: TextStyle(
                                  color: const Color(0xFFF8F6F0),
                                  fontSize: getDeviceResponsiveValue(
                                    deviceType: layoutVm.deviceType,
                                    mobile: 25,
                                    laptop: 30,
                                    desktop: 36,
                                  ),
                                  fontFamily: 'Crimson Text',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
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
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Dr. Sarah Chen',
                                    style: TextStyle(
                                      color: const Color(0xFFF8F6F0),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.50,
                                    ),
                                  ),
                                  Text(
                                    's.chen@university.edu',
                                    style: TextStyle(
                                      color: const Color(0xFFF8F6F0),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.43,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: const Color(0xFFF8F6F0),
                                  ),
                                  borderRadius: BorderRadius.circular(9999),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  // SizedBox(height: 60),
                  Text(
                    'Semester 1',
                    style: TextStyle(
                      color: const Color(0xE5F8F6F0),
                      fontSize: 20,
                      fontFamily: 'Crimson Text',
                      fontWeight: FontWeight.w400,
                      height: 1.40,
                    ),
                  ),
                  SizedBox(height: 25),
                  // SizedBox(height: 16),
                  TextRowSelect(
                    items:
                        EditBoardTab.values
                            .map((item) => item.toString())
                            .toList(),
                    borderColor: const Color(0xFFF8F6F0),
                    selectedTextStyle: TextStyle(
                      color: const Color(0xFFF8F6F0),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    style: TextStyle(
                      color: const Color(0xB2F8F6F0),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionCard({
    required String title,
    required String description,
    String? buttonText,
    String? lastUsed,
    required Color color,
    required String imageUrl,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0x339CAF88)),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 5 / 2,
                  child: ImagePlaceHolder(
                    imagePath: imageUrl,
                    isCardHeader: true,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          color.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontFamily: 'Crimson Text',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: const Color(0xFF4B5563),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (isNotNull(lastUsed))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            lastUsed!,
                            style: TextStyle(
                              color: color,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: color),
                      ],
                    ),
                  if (isNotNull(buttonText))
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            buttonText!,
                            style: TextStyle(
                              color: color,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: color),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileCard({
    required String title,
    required String description,
    required String tag,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color),
                  ),
                  SizedBox(width: 16),
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontFamily: 'Crimson Text',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              WidthLimiter(
                mobile: 250,
                child: Text(
                  description,
                  style: TextStyle(
                    color: const Color(0xFF4B5563),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SVGImagePlaceHolder(
                    imagePath: Images.upload4,
                    size: 16,
                    color: AppTheme.mossGreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String description,
    required String assignment,
    required String dueDate,
    required Color color,
    required CrossAxisAlignment alignment,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (alignment == CrossAxisAlignment.start)
          Expanded(flex: 2, child: Container()),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Crimson Text',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.assignment, size: 16, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            assignment,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      dueDate,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 32),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(width: 4, color: const Color(0xFF2D5016)),
          ),
        ),
        SizedBox(width: 32),
        if (alignment == CrossAxisAlignment.end)
          Expanded(flex: 2, child: Container()),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.8)),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinkButton(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x4C4A7C59),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
