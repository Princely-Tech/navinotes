import 'package:flutter/material.dart';

class BoardLightAcadPopupScreen extends StatelessWidget {
  const BoardLightAcadPopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: const Color(0xFFCED4DA)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: 1440,
            height: 67,
            decoration: ShapeDecoration(
              color: const Color(0xFFFAF7F0),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: const Color(0x4CFFB347)),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 80),
              child: Row(
                children: [
                  // Course Title
                  // Expanded(
                  //   child: Row(
                  //     children: [
                  //       IconButton(onPressed: () {

                  //       }, icon: Icon(Icons.arrow_back)
                  //       ), // Replace with actual icon
                  //       SizedBox(width: 16),
                  //       IconButton(icon: Icon(Icons.home)), // Replace with actual icon
                  //       SizedBox(width: 38),
                  //       Text(
                  //         'BIOLOGY 101 - Fall Semester',
                  //         style: TextStyle(
                  //           color: const Color(0xFF654321),
                  //           fontSize: 16,
                  //           fontFamily: 'EB Garamond',
                  //           fontWeight: FontWeight.w400,
                  //           height: 1.50,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Navigation Tabs
                  // Container(
                  //   width: 309.50,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Container(
                  //         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(width: 2, color: const Color(0xFFD4AF37)),
                  //         child: Text('Overview', style: TextStyle(color: const Color(0xFFD4AF37)))),
                  //       Text('Uploads', style: TextStyle(color: const Color(0xFF8B4513))),
                  //       Text('Assignments', style: TextStyle(color: const Color(0xFF8B4513))),
                  //     ],
                  //   ),
                  // ),

                  // User Actions
                  Container(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.search),
                        ), // Replace with actual icon
                        Stack(
                          children: [
                            IconButton(icon: Icon(Icons.notifications)),
                            Positioned(
                              top: -4,
                              right: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4AF37),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.settings),
                        ), // Replace with actual icon
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            "https://placehold.co/32x32",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              width: 1440,
              decoration: ShapeDecoration(
                color: const Color(0xFFF5F2E8),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: const Color(0xFFE5E7EB)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),

                      // Course Title and Description
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Explore Cell Biology & Genetics',
                                  style: TextStyle(
                                    color: const Color(0xFF654321),
                                    fontSize: 36,
                                    fontFamily: 'EB Garamond',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Dive into the fascinating world of cellular structures and genetic mechanisms...',
                                  style: TextStyle(
                                    color: const Color(0xFF8B4513),
                                    fontSize: 16,
                                    fontFamily: 'Open Sans',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Next Session Card
                          Container(
                            width: 416,
                            height: 256,
                            decoration: BoxDecoration(
                              color: const Color(0x19FFB347),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0x4CFFB347),
                              ),
                            ),
                            padding: EdgeInsets.all(21),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Next Session',
                                  style: TextStyle(
                                    color: const Color(0xFF654321),
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'DNA Replication Mechanisms',
                                  style: TextStyle(
                                    color: const Color(0xFF2F2F2F),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Dr. Eleanor Blackwood',
                                  style: TextStyle(
                                    color: const Color(0xFF2F2F2F),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 14),
                                    SizedBox(width: 8),
                                    Text('Tuesday, October 12th'),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 14),
                                    SizedBox(width: 8),
                                    Text('10:30 AM - 12:00 PM'),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 14),
                                    SizedBox(width: 8),
                                    Text('Science Hall, Room 305'),
                                  ],
                                ),
                                SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Prepare Materials'),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF8B4513),
                                    onPrimary: const Color(0xFFD4AF37),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 48),

                      // Course Actions Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Course Actions',
                            style: TextStyle(
                              color: const Color(0xFF654321),
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Create and manage your study materials',
                            style: TextStyle(color: const Color(0xFF8B4513)),
                          ),
                          SizedBox(height: 24),

                          Row(
                            children: [
                              // Create Note Card
                              _buildActionCard(
                                icon: Icons.edit,
                                title: 'Create Note',
                                description:
                                    'Start a new study note with customizable templates and formatting options.',
                                actionText: 'Create a new note',
                              ),
                              SizedBox(width: 24),

                              // Import PDF Card
                              _buildActionCard(
                                icon: Icons.picture_as_pdf,
                                title: 'Import PDF',
                                description:
                                    'Upload and annotate PDF documents from your course materials or research.',
                                actionText: 'Import document',
                              ),
                              SizedBox(width: 24),

                              // Import Files Card
                              _buildActionCard(
                                icon: Icons.attach_file,
                                title: 'Import Files',
                                description:
                                    'Upload multiple files including images, documents, and presentations.',
                                actionText: 'Upload files',
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 48),

                      // File Uploads Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'File Uploads',
                            style: TextStyle(
                              color: const Color(0xFF654321),
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Recently uploaded study materials',
                            style: TextStyle(color: const Color(0xFF8B4513)),
                          ),
                          SizedBox(height: 24),

                          Row(
                            children: [
                              _buildFileCard(
                                'Cell_Membrane_Notes.pdf',
                                '2.4 MB',
                                'Oct 8, 2023',
                              ),
                              SizedBox(width: 24),
                              _buildFileCard(
                                'DNA_Structure_Lecture.pptx',
                                '5.7 MB',
                                'Oct 5, 2023',
                              ),
                              SizedBox(width: 24),
                              _buildFileCard(
                                'Cell_Microscopy_Images.zip',
                                '18.2 MB',
                                'Oct 2, 2023',
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 48),

                      // Study Templates Section
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xC99A8634),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Study Templates',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pre-designed formats for effective studying',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 24),

                            Row(
                              children: [
                                _buildTemplateCard(
                                  icon: Icons.description,
                                  title: 'Lab Report',
                                  description:
                                      'Structured template for documenting laboratory experiments and findings.',
                                  usedBy: '127 students',
                                ),
                                SizedBox(width: 24),
                                _buildTemplateCard(
                                  icon: Icons.analytics,
                                  title: 'Research Analysis',
                                  description:
                                      'Framework for analyzing scientific papers and research findings.',
                                  usedBy: '89 students',
                                ),
                                SizedBox(width: 24),
                                _buildTemplateCard(
                                  icon: Icons.summarize,
                                  title: 'Scientific Summary',
                                  description:
                                      'Template for concise summaries of complex scientific concepts.',
                                  usedBy: '104 students',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 48),

                      // Course Timeline Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xC99A8634),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Course Timeline',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Weekly course progression and assignments',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),

                          // Timeline Items
                          _buildTimelineItem(
                            week: 'Week 1-2: Cell Structure & Function',
                            assignment: 'Cell Structure Lab Report',
                            status: 'In Progress',
                            progress: 0.65,
                            tags: [
                              'Cell Membrane',
                              'Cytoplasm',
                              'Organelles',
                              'Microscopy',
                            ],
                          ),
                          SizedBox(height: 24),
                          _buildTimelineItem(
                            week: 'Week 3-4: Genetics & DNA',
                            assignment: 'Genetic Inheritance Quiz',
                            status: 'Due Oct 15',
                            tags: [
                              'DNA Structure',
                              'Inheritance',
                              'Genes',
                              'Mutations',
                            ],
                          ),
                          SizedBox(height: 24),
                          _buildTimelineItem(
                            week: 'Week 5-6: Evolution & Natural Selection',
                            assignment: 'Evolution Case Study',
                            status: 'Not Started',
                            tags: [
                              'Natural Selection',
                              'Adaptation',
                              'Speciation',
                              'Fossil Record',
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Footer Section
          Container(
            width: 1440,
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 80),
            decoration: BoxDecoration(color: const Color(0xFF654321)),
            child: Row(
              children: [
                // Course Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Course Details',
                        style: TextStyle(
                          color: const Color(0xFFFFB347),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildDetailItem('Instructor:', 'Dr. Eleanor Blackwood'),
                      _buildDetailItem('Email:', 'e.blackwood@academia.edu'),
                      _buildDetailItem('Office Hours:', 'Mon/Wed 2:00-4:00 PM'),
                      _buildDetailItem('Phone:', '(555) 123-4567'),
                    ],
                  ),
                ),

                // Class Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Class Information',
                        style: TextStyle(
                          color: const Color(0xFFFFB347),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildDetailItem(
                        'Schedule:',
                        'Tue/Thu 10:30 AM - 12:00 PM',
                      ),
                      _buildDetailItem('Location:', 'Science Hall, Room 305'),
                      _buildDetailItem('Semester:', 'Fall 2025'),
                      SizedBox(height: 16),
                      Text(
                        'Quick Links',
                        style: TextStyle(color: const Color(0xFFFFB347)),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        children: [
                          Text(
                            'Syllabus',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Academic Calendar',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Library Resources',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Footer Image
                Container(
                  width: 272,
                  height: 272,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/272x272"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildActionCard({
    IconData icon,
    String title,
    String description,
    String actionText,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(21),
        decoration: BoxDecoration(
          color: const Color(0x33A67C52),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x4C8B4513)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0x338B4513),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF654321)),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF654321),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(description, style: TextStyle(color: const Color(0xFF8B4513))),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  actionText,
                  style: TextStyle(color: const Color(0xFF948247)),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: const Color(0xFF948247),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileCard(String fileName, String size, String date) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0x19A67C52),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 4, color: const Color(0xFFD4AF37)),
        ),
        child: Row(
          children: [
            Icon(Icons.insert_drive_file, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(color: const Color(0xFF654321)),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        size,
                        style: TextStyle(
                          color: const Color(0xFF8B4513),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        date,
                        style: TextStyle(
                          color: const Color(0xFF8B4513),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.more_vert),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard({
    IconData icon,
    String title,
    String description,
    String usedBy,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(21),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x338B4513)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0x33FFB347),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF654321)),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF654321),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(description, style: TextStyle(color: const Color(0xFF8B4513))),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.people, size: 12),
                SizedBox(width: 8),
                Text(
                  'Used by $usedBy',
                  style: TextStyle(
                    color: const Color(0xFF8B4513),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Use Template'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFF0EBE0),
                onPrimary: const Color(0xFF654321),
                minimumSize: Size(double.infinity, 42),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    String week,
    String assignment,
    String status,
    double progress = 0,
    List<String> tags = const [],
  }) {
    return Stack(
      children: [
        Positioned(
          left: 16,
          top: 0,
          child: Container(
            width: 2,
            height: 208,
            color: const Color(0x99FFB347),
          ),
        ),
        Container(
          padding: EdgeInsets.all(24),
          margin: EdgeInsets.only(left: 48),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF7F0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0x338B4513)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                week,
                style: TextStyle(color: const Color(0xFF654321), fontSize: 20),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0x7FF0EBE0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x198B4513)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          assignment,
                          style: TextStyle(color: const Color(0xFF654321)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                status == 'In Progress'
                                    ? const Color(0x33FFB347)
                                    : status == 'Due Oct 15'
                                    ? const Color(0x33D4AF37)
                                    : const Color(0xFFF5F2E8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: const Color(0xFF8B4513),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (progress > 0) ...[
                      SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFFF5F2E8),
                        color: const Color(0xFFD4AF37),
                      ),
                    ],

                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          tags
                              .map(
                                (tag) => Chip(
                                  label: Text(
                                    tag,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: const Color(0xFFF5F2E8),
                                  labelStyle: TextStyle(
                                    color: const Color(0xFF8B4513),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 4,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                color: const Color(0xFFD4AF37),
                fontSize: 16,
                fontFamily: 'Open Sans',
              ),
            ),
            TextSpan(
              text: ' $value',
              style: TextStyle(
                color: const Color(0xFFFAF7F0),
                fontSize: 16,
                fontFamily: 'Open Sans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
