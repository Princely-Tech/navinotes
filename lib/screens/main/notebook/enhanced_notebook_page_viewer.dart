import 'package:navinotes/models/notebook_page.dart';
import 'package:navinotes/models/paper_template.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/notebook/notebook_page_vm.dart';
import 'package:navinotes/screens/main/notebook/widgets/draggable_text_box.dart';
import 'package:navinotes/screens/main/notebook/widgets/notebook_drawing_board.dart';
import 'package:navinotes/screens/main/notebook/widgets/notebook_voice_recorder.dart';
import 'package:navinotes/widgets/paper_background_painter.dart';

/// Enhanced notebook page viewer with note-like functionality
class EnhancedNotebookPageViewer extends StatefulWidget {
  final NotebookPage notebookPage;
  final Content content;
  final Function(Content) onContentChanged;

  const EnhancedNotebookPageViewer({
    super.key,
    required this.notebookPage,
    required this.content,
    required this.onContentChanged,
  });

  @override
  State<EnhancedNotebookPageViewer> createState() => _EnhancedNotebookPageViewerState();
}

class _EnhancedNotebookPageViewerState extends State<EnhancedNotebookPageViewer>
    with TickerProviderStateMixin {
  late NotebookPageVm vm;
  late AnimationController _toolbarAnimationController;
  late Animation<double> _toolbarAnimation;

  @override
  void initState() {
    super.initState();
    vm = NotebookPageVm(
      notebookPage: widget.notebookPage,
      content: widget.content,
      onContentChanged: widget.onContentChanged,
    );

    _toolbarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _toolbarAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _toolbarAnimationController,
      curve: Curves.easeInOut,
    ));

    _toolbarAnimationController.forward();
  }

  @override
  void dispose() {
    _toolbarAnimationController.dispose();
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
            // Main content area
            _buildMainContent(),
            
            // Top toolbar with mode selector
            _buildTopToolbar(),
            
            // Bottom toolbar (mode-specific)
            _buildBottomToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Consumer<NotebookPageVm>(
      builder: (context, vm, child) {
        return Positioned.fill(
          top: 120, // Space for top toolbar + mode selector
          bottom: vm.currentMode == NotebookPageMode.voice ? 0 : 80, // Space for bottom toolbar
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildPageContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageContent() {
    return Consumer<NotebookPageVm>(
      builder: (context, vm, child) {
        return Stack(
          children: [
            // Paper background
            CustomPaint(
              painter: PaperBackgroundPainter(
                template: widget.notebookPage.template,
              ),
              size: Size.infinite,
            ),
            
            // Content based on current mode
            if (vm.currentMode == NotebookPageMode.voice)
              NotebookVoiceRecorder(vm: vm)
            else
              _buildTextAndDrawingContent(),
          ],
        );
      },
    );
  }

  Widget _buildTextAndDrawingContent() {
    return Consumer<NotebookPageVm>(
      builder: (context, vm, child) {
        return Stack(
          children: [
            // Drawing layer (always present but interactive based on mode)
            Positioned.fill(
              child: NotebookDrawingBoard(
                vm: vm,
                isInteractive: vm.currentMode == NotebookPageMode.drawing,
              ),
            ),
            
            // Text boxes layer
            ...vm.textBoxes.map((textBox) {
              return DraggableTextBox(
                key: ValueKey(textBox.id),
                textBox: textBox,
                vm: vm,
                isInteractive: vm.currentMode == NotebookPageMode.text,
              );
            }).toList(),
            
            // Add text box gesture detector (only in text mode)
            if (vm.currentMode == NotebookPageMode.text)
              Positioned.fill(
                child: GestureDetector(
                  onDoubleTap: () => _handleDoubleTap(context),
                  onTap: () => vm.selectTextBox(null), // Deselect all text boxes
                  child: Container(color: Colors.transparent),
                ),
              ),
          ],
        );
      },
    );
  }

  void _handleDoubleTap(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.globalToLocal(
      renderBox.localToGlobal(Offset.zero),
    );
    
    // Add some offset to avoid placing text box at the very edge
    final adjustedPosition = Offset(
      position.dx + 50,
      position.dy + 50,
    );
    
    vm.addTextBox(adjustedPosition);
  }

  Widget _buildTopToolbar() {
    return AnimatedBuilder(
      animation: _toolbarAnimation,
      builder: (context, child) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, -120 * (1 - _toolbarAnimation.value)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header with title and actions
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Expanded(
                            child: Text(
                              widget.content.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: _showMoreOptions,
                          ),
                        ],
                      ),
                    ),
                    
                    // Mode selector
                    _buildModeSelector(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeSelector() {
    return Consumer<NotebookPageVm>(
      builder: (context, vm, child) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildModeButton(
                icon: Icons.text_fields,
                label: 'Text',
                isActive: vm.currentMode == NotebookPageMode.text,
                onTap: () => vm.setMode(NotebookPageMode.text),
              ),
              _buildModeButton(
                icon: Icons.brush,
                label: 'Draw',
                isActive: vm.currentMode == NotebookPageMode.drawing,
                onTap: () => vm.setMode(NotebookPageMode.drawing),
              ),
              _buildModeButton(
                icon: Icons.mic,
                label: 'Voice',
                isActive: vm.currentMode == NotebookPageMode.voice,
                onTap: () => vm.setMode(NotebookPageMode.voice),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Theme.of(context).primaryColor : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Theme.of(context).primaryColor : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Consumer<NotebookPageVm>(
      builder: (context, vm, child) {
        if (vm.currentMode == NotebookPageMode.voice) {
          return const SizedBox.shrink(); // No bottom toolbar for voice mode
        }

        return AnimatedBuilder(
          animation: _toolbarAnimation,
          builder: (context, child) {
            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(0, 80 * (1 - _toolbarAnimation.value)),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: _buildModeSpecificToolbar(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModeSpecificToolbar() {
    return Consumer<NotebookPageVm>(
      builder: (context, vm, child) {
        if (vm.currentMode == NotebookPageMode.text) {
          return _buildTextToolbar();
        } else if (vm.currentMode == NotebookPageMode.drawing) {
          return _buildDrawingToolbar();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTextToolbar() {
    return Consumer<NotebookPageVm>(
      builder: (context, vm, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.add_box),
              onPressed: () {
                // Add text box at center of screen
                final size = MediaQuery.of(context).size;
                vm.addTextBox(Offset(size.width / 2 - 100, size.height / 2 - 50));
              },
              tooltip: 'Add Text Box',
            ),
            if (vm.selectedTextBoxId != null) ...[
              IconButton(
                icon: const Icon(Icons.format_bold),
                onPressed: () {
                  // Toggle bold for selected text box
                  // This would be implemented in the text box widget
                },
                tooltip: 'Bold',
              ),
              IconButton(
                icon: const Icon(Icons.format_italic),
                onPressed: () {
                  // Toggle italic for selected text box
                },
                tooltip: 'Italic',
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  if (vm.selectedTextBoxId != null) {
                    vm.deleteTextBox(vm.selectedTextBoxId!);
                  }
                },
                tooltip: 'Delete Text Box',
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildDrawingToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Switch to pen tool
          },
          tooltip: 'Pen',
        ),
        IconButton(
          icon: const Icon(Icons.brush),
          onPressed: () {
            // Switch to brush tool
          },
          tooltip: 'Brush',
        ),
        IconButton(
          icon: const Icon(Icons.highlight),
          onPressed: () {
            // Switch to highlighter tool
          },
          tooltip: 'Highlighter',
        ),
        IconButton(
          icon: const Icon(Icons.auto_fix_high),
          onPressed: () {
            // Switch to eraser tool
          },
          tooltip: 'Eraser',
        ),
        IconButton(
          icon: const Icon(Icons.undo),
          onPressed: () {
            // Undo last stroke
          },
          tooltip: 'Undo',
        ),
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            // Clear all drawings
          },
          tooltip: 'Clear',
        ),
      ],
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Change Paper Template'),
              onTap: () {
                Navigator.pop(context);
                _showPaperTemplateSelector();
              },
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text('Save Page'),
              onTap: () {
                Navigator.pop(context);
                // Save functionality is automatic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Page saved automatically')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Export Page'),
              onTap: () {
                Navigator.pop(context);
                _exportPage();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPaperTemplateSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Paper Template',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: PaperTemplates.defaultTemplates.take(6).map((template) {
                return GestureDetector(
                  onTap: () {
                    // Update page template
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CustomPaint(
                      painter: PaperBackgroundPainter(template: template),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _exportPage() {
    // Implementation for page export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }
}
