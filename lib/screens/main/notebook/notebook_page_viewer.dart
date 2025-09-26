import 'package:navinotes/models/notebook_page.dart';
import 'package:navinotes/models/paper_template.dart';
import 'package:navinotes/screens/main/notebook/enhanced_notebook_page_viewer.dart';
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
    return EnhancedNotebookPageViewer(
      notebookPage: page,
      content: widget.content,
      onContentChanged: widget.onContentChanged,
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

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add New Page'),
              onTap: () {
                Navigator.pop(context);
                _addNewPage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Export Notebook'),
              onTap: () {
                Navigator.pop(context);
                _exportNotebook();
              },
            ),
          ],
        ),
      ),
    );
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

  void _exportNotebook() {
    // Implementation for notebook export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }
}
