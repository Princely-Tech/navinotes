import 'package:navinotes/packages.dart';
import 'vm.dart';

class NoteKanbanScreen extends StatelessWidget {
  NoteKanbanScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteKanbanVm(),
      child: Consumer<NoteKanbanVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            body: Column(
              children: [_header(), Expanded(child: Column(children: [
                      
                    ],
                  ))],
            ),
          );
        },
      ),
    );
  }

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
              spacing: 8, // spacing between all horizontal items
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppButton.text(

                  text: 'Study Tools',
                  onTap: NavigationHelper.pop,
                  color: Color(0xFF4B5563),
                  prefix: Icon(Icons.arrow_back, color: AppTheme.darkSlateGray),
                ),

                // Vertical divider
                Container(
                  width: 1,
                  height: 24,
                  color: Color(0xFFD1D5DB)
                  // decoration: const BoxDecoration(
                  //   border: Border(
                  //     left: BorderSide(width: 1, ),
                  //   ),
                  // ),
                ),
                // Right content: "Kanban Board" and subtitle
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
                      
                      Row(
                        spacing: 8,
                        children: const [
                          Text(
                            'Research Paper Project',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                          Text(
                            '•',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                          Text(
                            'Academic Project Management',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
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
        ],
      ),
    );
  }
}
