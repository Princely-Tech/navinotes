import 'mind_map_documents.dart';
import 'mind_map_header.dart';
import 'mind_map_styling.dart';

import 'main.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class MindMapScreen extends StatelessWidget {
  MindMapScreen({super.key, required this.contentId});

  final String contentId;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MindMapVm(scaffoldKey: _scaffoldKey, contentId: contentId),
      child: Consumer<MindMapVm>(
        builder: (_, vm, _) {
          // Show loading while baseContent is being loaded
          if (vm.isLoading || vm.baseContent == null) {
            return Scaffold(
              backgroundColor: AppTheme.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading mind map...',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            );
          }

          // Show error if baseContent is still null after loading
          if (!vm.isLoading && vm.baseContent == null) {
            return Scaffold(
              backgroundColor: AppTheme.white,
              appBar: AppBar(
                title: Text('Mind Map'),
                backgroundColor: AppTheme.white,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error loading mind map',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The mind map could not be found or loaded.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            );
          }

          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            backgroundColor: vm.boardTheme.values.backgroundColor == AppTheme.transparent 
                ? AppTheme.white 
                : vm.boardTheme.values.backgroundColor,
            endDrawer: CustomDrawer(
              child: MindMapStyling(boardTheme: vm.boardTheme, vm: vm),
            ),
            drawer: CustomDrawer(
              child: MindMapDocuments(boardTheme: vm.boardTheme),
            ),
            body: Column(
              children: [
                MindMapHeader(
                  openDrawer: vm.openDrawer,
                  boardTheme: vm.boardTheme,
                  openEndDrawer: vm.openEndDrawer,
                  toggleDocumentPanel: vm.toggleDocumentPanel,
                  isDocumentPanelVisible: vm.isDocumentPanelVisible,
                  mindMapVm: vm,
                ),
                Expanded(
                  child: Row(
                    children: [
                      if (vm.isDocumentPanelVisible)
                        VisibleController(
                          mobile: false,
                          desktop: true,
                          child: WidthLimiter(
                            mobile: 256,
                            child: MindMapDocuments(
                              boardTheme: vm.boardTheme,
                            ),
                          ),
                        ),
                      Expanded(child: MindMapMain()),
                      VisibleController(
                        mobile: false,
                        laptop: true,
                        child: WidthLimiter(
                          mobile: 256,
                          child: MindMapStyling(
                            boardTheme: vm.boardTheme,
                            vm: vm,
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
}
