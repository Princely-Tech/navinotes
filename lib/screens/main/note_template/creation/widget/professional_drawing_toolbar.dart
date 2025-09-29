import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import '../models/drawing_tools.dart';
import '../vm.dart';
import 'custom_paint_contents.dart';

class ProfessionalDrawingToolbar extends StatefulWidget {
  final NoteCreationVm vm;

  const ProfessionalDrawingToolbar({
    Key? key,
    required this.vm,
  }) : super(key: key);

  @override
  State<ProfessionalDrawingToolbar> createState() => _ProfessionalDrawingToolbarState();
}

class _ProfessionalDrawingToolbarState extends State<ProfessionalDrawingToolbar>
    with TickerProviderStateMixin {
  DrawingToolCategory? _expandedCategory;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  StrokeStyle _strokeStyle = StrokeStyle.solid;
  bool _fillEnabled = false;
  DrawingToolType _selectedTool = DrawingToolType.simpleLine;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleCategory(DrawingToolCategory category) {
    setState(() {
      if (_expandedCategory == category) {
        _expandedCategory = null;
        _animationController.reverse();
      } else {
        _expandedCategory = category;
        _animationController.forward();
      }
    });
  }

  void _selectTool(DrawingToolType toolType) {
    setState(() {
      _selectedTool = toolType;
      _expandedCategory = null;
      _animationController.reverse();
    });

    final config = DrawingTools.getToolConfig(toolType);
    if (config != null) {
      _selectedColor = config.defaultColor;
      _strokeWidth = config.defaultStrokeWidth;
      _strokeStyle = config.defaultStrokeStyle;
      _fillEnabled = config.fillEnabled;
    }

    // Set the drawing tool based on type
    _setPaintContent(toolType);
  }

  void _setPaintContent(DrawingToolType toolType) {
    final controller = widget.vm.getCurrentPageDrawingController();
    
    switch (toolType) {
      case DrawingToolType.simpleLine:
        controller.setPaintContent(SimpleLine());
        break;
      case DrawingToolType.smoothLine:
        controller.setPaintContent(SmoothLine());
        break;
      case DrawingToolType.straightLine:
        controller.setPaintContent(StraightLine());
        break;
      case DrawingToolType.rectangle:
        controller.setPaintContent(Rectangle());
        break;
      case DrawingToolType.circle:
        controller.setPaintContent(Circle());
        break;
      case DrawingToolType.triangle:
        controller.setPaintContent(Triangle());
        break;
      case DrawingToolType.diamond:
        controller.setPaintContent(Diamond());
        break;
      case DrawingToolType.pentagon:
        controller.setPaintContent(Pentagon());
        break;
      case DrawingToolType.hexagon:
        controller.setPaintContent(Hexagon());
        break;
      case DrawingToolType.star:
        controller.setPaintContent(Star());
        break;
      case DrawingToolType.heart:
        controller.setPaintContent(Heart());
        break;
      case DrawingToolType.arrowStraight:
        controller.setPaintContent(ArrowStraight());
        break;
      case DrawingToolType.highlighter:
        controller.setPaintContent(Highlighter());
        break;
      case DrawingToolType.marker:
        controller.setPaintContent(SmoothLine()); // Use smooth line for marker
        break;
      case DrawingToolType.eraser:
        controller.setPaintContent(Eraser());
        break;
      // Placeholder implementations for future features
      case DrawingToolType.arrowCurved:
      case DrawingToolType.arrowDouble:
      case DrawingToolType.arrowBent:
        controller.setPaintContent(ArrowStraight()); // Use straight arrow for now
        break;
      case DrawingToolType.dottedLine:
      case DrawingToolType.dashedLine:
        controller.setPaintContent(StraightLine()); // Use straight line for now
        break;
      case DrawingToolType.textBox:
      case DrawingToolType.textCallout:
        // Text tools will be implemented in future updates
        controller.setPaintContent(SimpleLine());
        break;
      default:
        controller.setPaintContent(SimpleLine());
    }

    // Update stroke properties
    controller.setStyle(
      strokeWidth: _strokeWidth,
      color: _selectedColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMainToolbar(),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _animation,
                child: _buildExpandedToolbar(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainToolbar() {
    return Container(
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick access tools
            _buildQuickToolButton(DrawingToolType.simpleLine),
            _buildQuickToolButton(DrawingToolType.smoothLine),
            _buildQuickToolButton(DrawingToolType.eraser),
            
            const SizedBox(width: 16),
            
            // Category buttons
            ...DrawingTools.getAllCategories().map((category) => 
              _buildCategoryButton(category)
            ),
            
            const SizedBox(width: 16),
            
            // Color picker
            _buildColorPicker(),
            
            const SizedBox(width: 8),
            
            // Stroke width
            _buildStrokeWidthSlider(),
            
            const SizedBox(width: 8),
            
            // Undo/Redo
            _buildUndoRedoButtons(),
            
            // Add some padding at the end
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickToolButton(DrawingToolType toolType) {
    final config = DrawingTools.getToolConfig(toolType);
    if (config == null) return const SizedBox.shrink();

    final isSelected = _selectedTool == toolType;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: isSelected ? config.category.color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _selectTool(toolType),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isSelected 
                ? Border.all(color: config.category.color, width: 2)
                : null,
            ),
            child: Icon(
              config.icon,
              color: isSelected ? config.category.color : Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(DrawingToolCategory category) {
    final isExpanded = _expandedCategory == category;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: isExpanded ? category.color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _toggleCategory(category),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isExpanded 
                ? Border.all(color: category.color, width: 2)
                : Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  category.icon,
                  size: 18,
                  color: isExpanded ? category.color : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  category.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isExpanded ? category.color : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 16,
                  color: isExpanded ? category.color : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return GestureDetector(
      onTap: _showColorPicker,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _selectedColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrokeWidthSlider() {
    return Container(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_strokeWidth.round()}px',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            ),
            child: Slider(
              value: _strokeWidth,
              min: 1,
              max: 20,
              divisions: 19,
              onChanged: (value) {
                setState(() {
                  _strokeWidth = value;
                });
                widget.vm.getCurrentPageDrawingController().setStyle(strokeWidth: value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUndoRedoButtons() {
    final controller = widget.vm.getCurrentPageDrawingController();
    
    return Row(
      children: [
        IconButton(
          icon: Icon(
            CupertinoIcons.arrow_turn_up_left,
            color: controller.canUndo() ? Colors.grey[700] : Colors.grey[400],
          ),
          onPressed: controller.canUndo() ? () => controller.undo() : null,
          tooltip: 'Undo',
        ),
        IconButton(
          icon: Icon(
            CupertinoIcons.arrow_turn_up_right,
            color: controller.canRedo() ? Colors.grey[700] : Colors.grey[400],
          ),
          onPressed: controller.canRedo() ? () => controller.redo() : null,
          tooltip: 'Redo',
        ),
      ],
    );
  }

  Widget _buildExpandedToolbar() {
    if (_expandedCategory == null) return const SizedBox.shrink();

    final tools = DrawingTools.getToolsByCategory(_expandedCategory!);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _expandedCategory!.displayName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tools.map((config) => _buildExpandedToolButton(config)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedToolButton(DrawingToolConfig config) {
    final isSelected = _selectedTool == config.type;
    
    return Material(
      color: isSelected ? config.category.color.withOpacity(0.2) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 2 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _selectTool(config.type),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected 
              ? Border.all(color: config.category.color, width: 2)
              : Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                config.icon,
                size: 24,
                color: isSelected ? config.category.color : Colors.grey[600],
              ),
              const SizedBox(height: 4),
              Text(
                config.name,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? config.category.color : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildColorPickerSheet(),
    );
  }

  Widget _buildColorPickerSheet() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Choose Color',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Basic colors
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Basic Colors',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: DrawingColorPalette.basicColors.map((color) => 
                    _buildColorOption(color)
                  ).toList(),
                ),
                const SizedBox(height: 16),
                
                // Extended colors
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Extended Colors',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: DrawingColorPalette.extendedColors.map((color) => 
                    _buildColorOption(color, size: 32)
                  ).toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color, {double size = 40}) {
    final isSelected = _selectedColor == color;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
        widget.vm.getCurrentPageDrawingController().setStyle(color: color);
        Navigator.pop(context);
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isSelected 
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )
          : null,
      ),
    );
  }
}
