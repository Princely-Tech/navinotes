import 'package:flutter/material.dart';
import 'package:navinotes/models/notebook_page.dart';
import 'package:navinotes/models/paper_template.dart';
import 'package:navinotes/widgets/handwriting_canvas.dart';
import 'package:navinotes/packages.dart';

/// Main notebook page viewer - GoodNotes-like experience
class NotebookPageViewer extends StatefulWidget {
  final Content content;
  final List<NotebookPage> pages;
  final int initialPageIndex;
  final Function(Content) onContentChanged;

  const NotebookPageViewer({
    super.key,
    required this.content,
    required this.pages,
    this.initialPageIndex = 0,
    required this.onContentChanged,
  });

  @override
  State<NotebookPageViewer> createState() => _NotebookPageViewerState();
}

class _NotebookPageViewerState extends State<NotebookPageViewer>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _toolbarAnimationController;
  late Animation<double> _toolbarAnimation;

  int _currentPageIndex = 0;
  double _scale = 1.0;
  Offset _panOffset = Offset.zero;
  DrawingTool _currentTool = DrawingTool.pen;
  Color _currentColor = Colors.black;
  double _currentStrokeWidth = 2.0;

  // Zoom and pan
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initialPageIndex;
    _pageController = PageController(initialPage: _currentPageIndex);

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
    _pageController.dispose();
    _toolbarAnimationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Main page viewer
          _buildPageViewer(),
          
          // Top toolbar
          _buildTopToolbar(),
          
          // Bottom toolbar
          _buildBottomToolbar(),
          
          // Page thumbnails sidebar (optional)
          if (MediaQuery.of(context).size.width > 768)
            _buildPageThumbnails(),
        ],
      ),
    );
  }

  Widget _buildPageViewer() {
    // Handle empty notebook case
    if (widget.pages.isEmpty) {
      return Positioned.fill(
        top: 80,
        bottom: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Empty Notebook',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the + button to add your first page',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Positioned.fill(
      top: 80,
      bottom: 100,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        itemCount: widget.pages.length,
        itemBuilder: (context, index) {
          final page = widget.pages[index];
          return _buildSinglePage(page);
        },
      ),
    );
  }

  Widget _buildSinglePage(NotebookPage page) {
    return Container(
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
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.5,
          maxScale: 3.0,
          onInteractionUpdate: (details) {
            setState(() {
              _scale = _transformationController.value.getMaxScaleOnAxis();
              _panOffset = Offset(
                _transformationController.value.getTranslation().x,
                _transformationController.value.getTranslation().y,
              );
            });
          },
          child: AspectRatio(
            aspectRatio: page.template.size.dimensions.width /
                page.template.size.dimensions.height,
            child: HandwritingCanvas(
              paperTemplate: page.template,
              initialStrokes: _parseHandwritingData(page.handwritingData),
              onStrokesChanged: (strokes) => _onStrokesChanged(page, strokes),
              currentTool: _currentTool,
              currentColor: _currentColor,
              currentStrokeWidth: _currentStrokeWidth,
              scale: _scale,
              panOffset: _panOffset,
            ),
          ),
        ),
      ),
    );
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
            offset: Offset(0, -80 * (1 - _toolbarAnimation.value)),
            child: Container(
              height: 80,
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
                child: Row(
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    
                    // Notebook title
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
                    
                    // Page counter
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.pages.isEmpty 
                          ? '0 / 0' 
                          : '${_currentPageIndex + 1} / ${widget.pages.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    // More options
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: _showMoreOptions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomToolbar() {
    return AnimatedBuilder(
      animation: _toolbarAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, 100 * (1 - _toolbarAnimation.value)),
            child: Container(
              height: 100,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Drawing tools
                    _buildToolButton(DrawingTool.pen, Icons.edit),
                    _buildToolButton(DrawingTool.pencil, Icons.create),
                    _buildToolButton(DrawingTool.marker, Icons.brush),
                    _buildToolButton(DrawingTool.highlighter, Icons.highlight),
                    _buildToolButton(DrawingTool.eraser, Icons.auto_fix_high),
                    
                    // Divider
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    
                    // Color picker
                    _buildColorPicker(),
                    
                    // Stroke width
                    _buildStrokeWidthPicker(),
                    
                    // Divider
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    
                    // Undo
                    IconButton(
                      icon: const Icon(Icons.undo),
                      onPressed: _undoLastStroke,
                    ),
                    
                    // Add page
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addNewPage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolButton(DrawingTool tool, IconData icon) {
    final isSelected = _currentTool == tool;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTool = tool;
        });
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [
      Colors.black,
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => _buildColorPickerSheet(colors),
        );
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _currentColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildColorPickerSheet(List<Color> colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose Color',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: colors.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentColor = color;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _currentColor == color
                          ? Colors.blue
                          : Colors.grey[300]!,
                      width: _currentColor == color ? 3 : 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStrokeWidthPicker() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => _buildStrokeWidthSheet(),
        );
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: _currentStrokeWidth * 2,
            height: _currentStrokeWidth * 2,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrokeWidthSheet() {
    final widths = [1.0, 2.0, 4.0, 6.0, 8.0, 12.0];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Stroke Width',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...widths.map((width) {
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: width * 2,
                    height: width * 2,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              title: Text('${width.toInt()}pt'),
              trailing: _currentStrokeWidth == width
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() {
                  _currentStrokeWidth = width;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPageThumbnails() {
    return Positioned(
      left: 0,
      top: 80,
      bottom: 100,
      width: 120,
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: widget.pages.length,
          itemBuilder: (context, index) {
            final page = widget.pages[index];
            final isSelected = index == _currentPageIndex;

            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AspectRatio(
                  aspectRatio: page.template.size.dimensions.width /
                      page.template.size.dimensions.height,
                  child: Container(
                    color: page.template.color.backgroundColor,
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<HandwritingStroke> _parseHandwritingData(String? data) {
    if (data == null || data.isEmpty) return [];
    
    try {
      final List<dynamic> strokesJson = jsonDecode(data);
      return strokesJson
          .map((s) => HandwritingStroke.fromMap(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  void _onStrokesChanged(NotebookPage page, List<HandwritingStroke> strokes) {
    final strokesData = jsonEncode(strokes.map((s) => s.toMap()).toList());
    final updatedPage = page.copyWith(
      handwritingData: strokesData,
      hasContent: strokes.isNotEmpty,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    // Update the page in the database
    DatabaseHelper.instance.updateNotebookPage(updatedPage);
    
    // Update the content's updated timestamp
    final updatedContent = widget.content.getUpdatedContent(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    
    widget.onContentChanged(updatedContent);
  }

  void _undoLastStroke() {
    // This would need to be implemented in the HandwritingCanvas
    // For now, we'll just show a placeholder
  }

  void _addNewPage() {
    // Create a default paper template
    final defaultTemplate = PaperTemplates.getDefault();
    
    final newPage = NotebookPage(
      notebookId: widget.content.id,
      pageNumber: widget.pages.length + 1,
      template: defaultTemplate,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    // Insert the new page into the database
    DatabaseHelper.instance.insertNotebookPage(newPage);
    
    // Update the content's updated timestamp
    final updatedContent = widget.content.getUpdatedContent(
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    
    widget.onContentChanged(updatedContent);

    // Navigate to the new page
    Future.delayed(const Duration(milliseconds: 100), () {
      _pageController.animateToPage(
        widget.pages.length, // New page will be at the end
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
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
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete Page'),
              onTap: () {
                Navigator.pop(context);
                _deletePage();
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
    // Implementation for paper template selection
  }

  void _deletePage() {
    // Implementation for page deletion
  }

  void _exportPage() {
    // Implementation for page export
  }
}
