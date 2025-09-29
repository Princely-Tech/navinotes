import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:navinotes/screens/main/note_template/creation/models/stylus_settings.dart';
import '../models/drawing_tools.dart';
import '../vm.dart';
import 'custom_paint_contents.dart';
import 'stylus_settings_dialog.dart';

class ProfessionalDrawingToolbar extends StatefulWidget {
  final NoteCreationVm vm;

  const ProfessionalDrawingToolbar({Key? key, required this.vm})
    : super(key: key);

  @override
  State<ProfessionalDrawingToolbar> createState() =>
      _ProfessionalDrawingToolbarState();
}

class _ProfessionalDrawingToolbarState extends State<ProfessionalDrawingToolbar>
    with TickerProviderStateMixin {
  DrawingToolCategory? _expandedCategory;
  late AnimationController _animationController;
  late Animation<double> _animation;

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
      _expandedCategory = null;
    });
    _animationController.reverse();

    // Update ViewModel with selected tool
    widget.vm.setSelectedDrawingTool(toolType);

    final config = DrawingTools.getToolConfig(toolType);
    if (config != null) {
      widget.vm.setSelectedColor(config.defaultColor);
      widget.vm.setStrokeWidth(config.defaultStrokeWidth);
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
      case DrawingToolType.arrowDouble:
      case DrawingToolType.arrowBent:
        controller.setPaintContent(
          ArrowStraight(),
        ); // Use straight arrow for now
        break;
      case DrawingToolType.dottedLine:
      case DrawingToolType.dashedLine:
        controller.setPaintContent(StraightLine()); // Use straight line for now
        break;
      case DrawingToolType.textBox:
      case DrawingToolType.textCallout:
      case DrawingToolType.textBold:
      case DrawingToolType.textItalic:
      case DrawingToolType.textUnderline:
        // Text tools are handled by the text box system, not drawing controller
        widget.vm.selectTextBoxTool(toolType.toString());

        // Automatically add a text box at the center of the canvas
        _addTextBoxAtCenter(toolType);
        return; // Don't update drawing controller for text tools
      default:
        controller.setPaintContent(SimpleLine());
    }

    // Exit text box mode when selecting non-text tools
    widget.vm.exitTextBoxMode();

    // Update stroke properties
    controller.setStyle(
      strokeWidth: widget.vm.strokeWidth,
      color: widget.vm.selectedColor,
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
            ...DrawingTools.getAllCategories().map(
              (category) => _buildCategoryButton(category),
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

            const SizedBox(width: 8),

            // Stylus Controls (if stylus is connected)
            if (widget.vm.isStylusConnected) ...[
              const SizedBox(width: 8),
              _buildStylusToolbar(),
            ],

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

    final isSelected = widget.vm.selectedDrawingTool == toolType;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color:
            isSelected
                ? config.category.color.withOpacity(0.2)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _selectTool(toolType),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border:
                  isSelected
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
        color:
            isExpanded ? category.color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _toggleCategory(category),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border:
                  isExpanded
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
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
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
          color: widget.vm.selectedColor,
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
            '${widget.vm.strokeWidth.round()}px',
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            ),
            child: Slider(
              value: widget.vm.strokeWidth,
              min: 1,
              max: 20,
              divisions: 19,
              onChanged: (value) {
                widget.vm.setStrokeWidth(value);
                widget.vm.getCurrentPageDrawingController().setStyle(
                  strokeWidth: value,
                );
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
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
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
            children:
                tools
                    .map((config) => _buildExpandedToolButton(config))
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedToolButton(DrawingToolConfig config) {
    final isSelected =
        widget.vm.selectedDrawingTool == config.type ||
        (config.category == DrawingToolCategory.text &&
            widget.vm.isTextBoxMode &&
            widget.vm.selectedTextBoxTool == config.type.toString());

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
            border:
                isSelected
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
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                const Text(
                  'Choose Color',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      DrawingColorPalette.basicColors
                          .map((color) => _buildColorOption(color))
                          .toList(),
                ),
                const SizedBox(height: 16),

                // Extended colors
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Extended Colors',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      DrawingColorPalette.extendedColors
                          .map((color) => _buildColorOption(color, size: 32))
                          .toList(),
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
    final isSelected = widget.vm.selectedColor == color;

    return GestureDetector(
      onTap: () {
        widget.vm.setSelectedColor(color);
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
        child:
            isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
      ),
    );
  }

  /// Automatically add a text box at the center of the canvas
  void _addTextBoxAtCenter(DrawingToolType toolType) {
    // Get canvas dimensions (assuming standard A4 dimensions as fallback)
    const double canvasWidth = 595.0;
    const double canvasHeight = 842.0;

    // Calculate center position
    const double centerX = canvasWidth / 2;
    const double centerY = canvasHeight / 2;

    // Offset the text box so it's centered (text box is 120x40 by default)
    const double textBoxWidth = 120.0;
    const double textBoxHeight = 40.0;
    final Offset centerPosition = Offset(
      centerX - (textBoxWidth / 2),
      centerY - (textBoxHeight / 2),
    );

    // Determine text content based on tool type
    String defaultText = 'Text';
    switch (toolType) {
      case DrawingToolType.textBox:
        defaultText = 'Text';
        break;
      case DrawingToolType.textCallout:
        defaultText = 'Callout';
        break;
      case DrawingToolType.textBold:
        defaultText = 'Bold Text';
        break;
      case DrawingToolType.textItalic:
        defaultText = 'Italic Text';
        break;
      case DrawingToolType.textUnderline:
        defaultText = 'Underlined Text';
        break;
      default:
        defaultText = 'Text';
    }

    debugPrint(
      'Adding text box at center: $centerPosition with text: $defaultText',
    );

    // Add the text box to the canvas
    widget.vm.addTextBox(centerPosition, text: defaultText);

    // Automatically start editing the new text box with a slight delay for smooth transition
    Future.delayed(const Duration(milliseconds: 100), () {
      final textBoxManager = widget.vm.textBoxManager;
      if (textBoxManager.selectedTextBoxId != null) {
        widget.vm.startEditingTextBox(textBoxManager.selectedTextBoxId!);
      }
    });
  }

  /// Build stylus settings button
  Widget _buildStylusSettingsButton() {
    return Container(
      decoration: BoxDecoration(
        color:
            widget.vm.stylusSettings.pressureSensitivityEnabled
                ? Colors.blue.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              widget.vm.stylusSettings.pressureSensitivityEnabled
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            debugPrint('InkWell onTap triggered for stylus settings');
            _showStylusSettingsDialog();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit,
                  size: 16,
                  color:
                      widget.vm.stylusSettings.pressureSensitivityEnabled
                          ? Colors.blue
                          : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                if (widget.vm.stylusSettings.pressureSensitivityEnabled)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'P',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show stylus settings dialog
  void _showStylusSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        debugPrint('Building StylusSettingsDialog...');
        return StylusSettingsDialog(
          initialSettings: widget.vm.stylusSettings,
          onSettingsChanged: (settings) {
            debugPrint('Stylus settings changed: $settings');
            widget.vm.updateStylusSettings(settings);
            widget.vm.saveStylusSettings();
          },
        );
      },
    );
  }

  /// Build compact stylus toolbar with essential controls
  Widget _buildStylusToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stylus type indicator
          _buildStylusTypeIndicator(),

          const SizedBox(width: 8),

          // Pressure sensitivity toggle
          _buildPressureToggle(),

          const SizedBox(width: 8),

          // Palm rejection level indicator
          _buildPalmRejectionIndicator(),

          const SizedBox(width: 8),

          // Settings button
          _buildCompactSettingsButton(),
        ],
      ),
    );
  }

  /// Build stylus type indicator
  Widget _buildStylusTypeIndicator() {
    final stylusType = widget.vm.detectedStylusType;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            stylusType.icon,
            size: 12,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            stylusType == StylusInputType.applePencil
                ? 'Pencil'
                : stylusType == StylusInputType.samsungSPen
                ? 'S Pen'
                : 'Stylus',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Build pressure sensitivity toggle
  Widget _buildPressureToggle() {
    final isEnabled = widget.vm.stylusSettings.pressureSensitivityEnabled;
    return GestureDetector(
      onTap: () {
        final newSettings = widget.vm.stylusSettings.copyWith(
          pressureSensitivityEnabled: !isEnabled,
        );
        widget.vm.updateStylusSettings(newSettings);
        widget.vm.saveStylusSettings();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color:
              isEnabled
                  ? Theme.of(context).primaryColor.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color:
                isEnabled
                    ? Theme.of(context).primaryColor.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.speed,
              size: 12,
              color:
                  isEnabled ? Theme.of(context).primaryColor : Colors.grey[600],
            ),
            const SizedBox(width: 2),
            Text(
              'P',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color:
                    isEnabled
                        ? Theme.of(context).primaryColor
                        : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build palm rejection level indicator
  Widget _buildPalmRejectionIndicator() {
    final level = widget.vm.stylusSettings.palmRejectionLevel;
    final isActive = level != PalmRejectionLevel.off;

    return GestureDetector(
      onTap: () => _cyclePalmRejectionLevel(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color:
              isActive
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color:
                isActive
                    ? Colors.orange.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.back_hand,
              size: 12,
              color: isActive ? Colors.orange[700] : Colors.grey[600],
            ),
            const SizedBox(width: 2),
            Text(
              _getPalmRejectionLevelText(level),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.orange[700] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build compact settings button
  Widget _buildCompactSettingsButton() {
    return GestureDetector(
      onTap: () => _showStylusSettingsDialog(),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
        ),
        child: Icon(Icons.tune, size: 14, color: Colors.blue[700]),
      ),
    );
  }

  /// Cycle through palm rejection levels
  void _cyclePalmRejectionLevel() {
    final currentLevel = widget.vm.stylusSettings.palmRejectionLevel;
    PalmRejectionLevel nextLevel;

    switch (currentLevel) {
      case PalmRejectionLevel.off:
        nextLevel = PalmRejectionLevel.low;
        break;
      case PalmRejectionLevel.low:
        nextLevel = PalmRejectionLevel.medium;
        break;
      case PalmRejectionLevel.medium:
        nextLevel = PalmRejectionLevel.high;
        break;
      case PalmRejectionLevel.high:
        nextLevel = PalmRejectionLevel.maximum;
        break;
      case PalmRejectionLevel.maximum:
        nextLevel = PalmRejectionLevel.off;
        break;
    }

    final newSettings = widget.vm.stylusSettings.copyWith(
      palmRejectionLevel: nextLevel,
    );
    widget.vm.updateStylusSettings(newSettings);
    widget.vm.saveStylusSettings();
  }

  /// Get palm rejection level text
  String _getPalmRejectionLevelText(PalmRejectionLevel level) {
    switch (level) {
      case PalmRejectionLevel.off:
        return 'Off';
      case PalmRejectionLevel.low:
        return 'L';
      case PalmRejectionLevel.medium:
        return 'M';
      case PalmRejectionLevel.high:
        return 'H';
      case PalmRejectionLevel.maximum:
        return 'Max';
    }
  }
}
