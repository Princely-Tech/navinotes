import 'package:navinotes/packages.dart';
import 'vm.dart';

class MindMapHeader extends StatelessWidget {
  const MindMapHeader({
    super.key,
    required this.openDrawer,
    required this.openEndDrawer,
    required this.boardTheme,
    this.toggleDocumentPanel,
    this.isDocumentPanelVisible = true,
    required this.mindMapVm,
  });
  final VoidCallback openDrawer;
  final VoidCallback openEndDrawer;
  final BoardTheme boardTheme;
  final VoidCallback? toggleDocumentPanel;
  final bool isDocumentPanelVisible;
  final MindMapVm mindMapVm;

  @override
  Widget build(BuildContext context) {
    final themeValues = boardTheme.values;
    return Container(
      decoration: themeValues.mainHeaderDecoration.copyWith(
        color:
            themeValues.mainHeaderDecoration.color ??
            (themeValues.backgroundColor == AppTheme.transparent
                ? AppTheme.ghostWhite
                : themeValues.backgroundColor),
        border:
            themeValues.mainHeaderDecoration.border ??
            Border(bottom: BorderSide(color: themeValues.borderColor)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // BordThemeValues params = boardTheme.values;
          return ScrollableController(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (toggleDocumentPanel != null) _documentToggleButton(),
                  _menuButton(),
                  Row(
                    children: [
                      InkWell(
                        onTap: NavigationHelper.pop,
                        child: Icon(
                          Icons.arrow_back,
                          color: themeValues.color1,
                        ),
                      ),
                      SizedBox(width: 10),
                      _title(mindMapVm),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 16,
                          color: themeValues.color1,
                        ),
                        onPressed: () => _editTitle(context, mindMapVm),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      VisibleController(
                        mobile: true,
                        laptop: false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MenuButton(
                            decoration: BoxDecoration(
                              color: AppTheme.darkMossGreen,
                            ),
                            onPressed: openEndDrawer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _mindMapControlButtons(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _title(MindMapVm vm) {
    final themeValues = boardTheme.values;
    return Text(
      vm.title ?? 'Untitled',
      style: AppTheme.text.copyWith(
        color: themeValues.color1,
        fontSize: 20.0,
        fontFamily: themeValues.fontFamily,
        fontWeight: getFontWeight(500),
      ),
    );
  }

  void _editTitle(BuildContext context, MindMapVm vm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final controller = TextEditingController(text: vm.title ?? '');
        return AlertDialog(
          title: const Text('Edit Mind Map Title'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter title...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                vm.updateTitle(value);
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  vm.updateTitle(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _menuButton() {
    Color color = AppTheme.darkMossGreen;
    switch (boardTheme) {
      case BoardTheme.plain:
        color = AppTheme.black;
        break;
      default:
    }
    return VisibleController(
      mobile: true,
      desktop: false,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: MenuButton(
          decoration: BoxDecoration(color: color),
          onPressed: openDrawer,
        ),
      ),
    );
  }

  Widget _documentToggleButton() {
    Color color = AppTheme.darkMossGreen;
    switch (boardTheme) {
      case BoardTheme.plain:
        color = AppTheme.black;
        break;
      default:
    }
    return VisibleController(
      mobile: false,
      desktop: true,
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: MenuButton(
          decoration: BoxDecoration(color: color),
          onPressed: toggleDocumentPanel,
        ),
      ),
    );
  }

  Widget _mindMapControlButtons(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        // Add Node button
        ElevatedButton.icon(
          onPressed: () {
            // Add node at center of currently visible viewport
            final centerPosition = mindMapVm.getCurrentViewportCenter();
            mindMapVm.addNodeAt(
              text: 'New node',
              logicalPosition: centerPosition,
            );
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add node'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(0, 32),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            textStyle: TextStyle(fontSize: 12),
          ),
        ),

        // Zoom controls
        IconButton(
          tooltip: 'Zoom in',
          onPressed: mindMapVm.zoomIn,
          icon: const Icon(Icons.zoom_in, size: 18),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          tooltip: 'Zoom out',
          onPressed: mindMapVm.zoomOut,
          icon: const Icon(Icons.zoom_out, size: 18),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          tooltip: 'Reset zoom & pan',
          onPressed: mindMapVm.resetZoom,
          icon: const Icon(Icons.center_focus_strong, size: 18),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),

        // Save button
        ElevatedButton.icon(
          onPressed: () async {
            await mindMapVm.saveToDb();
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Mind map saved')));
            }
          },
          icon: const Icon(Icons.save, size: 16),
          label: const Text('Save'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(0, 32),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            textStyle: TextStyle(fontSize: 12),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () async {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF export in progress')),
              );
            }
            await mindMapVm.exportAsPdf(context);
          },
          icon: const Icon(Icons.picture_as_pdf, size: 16),
          label: const Text('PDF'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(0, 32),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            textStyle: TextStyle(fontSize: 12),
          ),
        ),

        SizedBox(width: 8),

        ElevatedButton.icon(
          onPressed: () async {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PNG export in progress')),
              );
            }
            await mindMapVm.exportAsPng(context);
          },
          icon: const Icon(Icons.image, size: 16),
          label: const Text('PNG'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(0, 32),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            textStyle: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
