// EXAMPLE: How to integrate SyllabusSection into board screens
// This shows the exact changes needed for each board type

// ============================================
// DARK ACADEMIA BOARD EXAMPLE
// File: lib/screens/main/choose_board/dark_academia/popup/index.dart
// ============================================

// 1. Add import at the top
import 'package:navinotes/widgets/board/syllabus_section.dart';

// 2. Replace the _courseTimeline() method with this:
Widget _courseTimeline() {
  return Consumer<BoardEditVm>(
    builder: (context, vm, _) {
      List<CourseTimeline> courseOutlines = vm.board.courseTimeLines ?? [];
      if (courseOutlines.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        color: const Color(0xFF2B1810),
        padding: EdgeInsets.only(top: 64),
        child: ResponsiveHorizontalPadding(
          child: SyllabusSection(
            board: vm.board,
            onUpdate: (updatedTimelines) async {
              final updatedBoard = vm.board.copyWith(
                courseTimeLines: updatedTimelines,
              );
              await DatabaseHelper.instance.updateBoard(updatedBoard);
              vm.initialize();
            },
            primaryColor: const Color(0xFFF7F3E9), // Light cream for dark bg
            backgroundColor: const Color(0xFF3D2818), // Slightly lighter brown
          ),
        ),
      );
    },
  );
}

// ============================================
// LIGHT ACADEMIA BOARD EXAMPLE
// File: lib/screens/main/choose_board/light_academia/popup/overview.dart
// ============================================

// 1. Add import
import 'package:navinotes/widgets/board/syllabus_section.dart';

// 2. Find where course timeline is displayed and replace with:
SyllabusSection(
  board: vm.board,
  onUpdate: (updatedTimelines) async {
    final updatedBoard = vm.board.copyWith(
      courseTimeLines: updatedTimelines,
    );
    await DatabaseHelper.instance.updateBoard(updatedBoard);
    vm.initialize();
  },
  primaryColor: AppTheme.vividRose,
  backgroundColor: Colors.white,
)

// ============================================
// MINIMALIST BOARD EXAMPLE
// File: lib/screens/main/choose_board/minimalist/popup/index.dart
// ============================================

// 1. Add import
import 'package:navinotes/widgets/board/syllabus_section.dart';

// 2. Replace timeline section with:
SyllabusSection(
  board: vm.board,
  onUpdate: (updatedTimelines) async {
    final updatedBoard = vm.board.copyWith(
      courseTimeLines: updatedTimelines,
    );
    await DatabaseHelper.instance.updateBoard(updatedBoard);
    vm.initialize();
  },
  primaryColor: AppTheme.graphite,
  backgroundColor: AppTheme.whiteSmoke,
)

// ============================================
// NATURE BOARD EXAMPLE
// File: lib/screens/main/choose_board/nature/popup/index.dart
// ============================================

// 1. Add import
import 'package:navinotes/widgets/board/syllabus_section.dart';

// 2. Replace timeline section with:
SyllabusSection(
  board: vm.board,
  onUpdate: (updatedTimelines) async {
    final updatedBoard = vm.board.copyWith(
      courseTimeLines: updatedTimelines,
    );
    await DatabaseHelper.instance.updateBoard(updatedBoard);
    vm.initialize();
  },
  primaryColor: AppTheme.forestGreen,
  backgroundColor: AppTheme.mintWhisper,
)

// ============================================
// PLAIN BOARD EXAMPLE
// File: lib/screens/main/choose_board/plain/popup/overview.dart
// ============================================

// 1. Add import
import 'package:navinotes/widgets/board/syllabus_section.dart';

// 2. Replace timeline section with:
SyllabusSection(
  board: vm.board,
  onUpdate: (updatedTimelines) async {
    final updatedBoard = vm.board.copyWith(
      courseTimeLines: updatedTimelines,
    );
    await DatabaseHelper.instance.updateBoard(updatedBoard);
    vm.initialize();
  },
  primaryColor: AppTheme.vividRose,
  backgroundColor: Colors.white,
)

// ============================================
// IMPORTANT NOTES
// ============================================

/*
1. The SyllabusSection widget handles:
   - Displaying all timeline items
   - Edit functionality (tap to edit)
   - Sync to calendar button
   - Date normalization
   - Error handling

2. The onUpdate callback:
   - Receives updated timelines
   - Updates the board in database
   - Refreshes the UI (vm.initialize())

3. Colors should match your board theme:
   - primaryColor: Main accent color
   - backgroundColor: Card background color

4. Date normalization happens automatically:
   - "April 30" → "2024-04-30"
   - "Nov 15" → "2024-11-15"
   - Sequential dates handled intelligently

5. Calendar sync:
   - Checks if calendar is connected
   - Creates events for assignments
   - Creates events for topics
   - Shows success/error messages

6. Error handling:
   - Invalid dates are skipped
   - Sync failures show helpful messages
   - App never crashes from bad data
*/
