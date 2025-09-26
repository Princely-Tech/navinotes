import 'package:flutter/material.dart';
import 'package:navinotes/models/page_format.dart';
import 'package:navinotes/packages.dart';

class PageSettingsDialog extends StatefulWidget {
  final PageFormat currentFormat;
  final Function(PageFormat) onFormatChanged;

  const PageSettingsDialog({
    Key? key,
    required this.currentFormat,
    required this.onFormatChanged,
  }) : super(key: key);

  @override
  State<PageSettingsDialog> createState() => _PageSettingsDialogState();
}

class _PageSettingsDialogState extends State<PageSettingsDialog> {
  late PageFormat _selectedFormat;
  final TextEditingController _customWidthController = TextEditingController();
  final TextEditingController _customHeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedFormat = widget.currentFormat;
    
    // Initialize custom size controllers if current format is custom
    if (_selectedFormat.size == PageSize.custom && _selectedFormat.customSize != null) {
      _customWidthController.text = _selectedFormat.customSize!.width.toInt().toString();
      _customHeightController.text = _selectedFormat.customSize!.height.toInt().toString();
    } else {
      // Default custom size (A4 dimensions in points)
      _customWidthController.text = '595';
      _customHeightController.text = '842';
    }
  }

  @override
  void dispose() {
    _customWidthController.dispose();
    _customHeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Page Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Page Size Section
            const Text(
              'Page Size',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildPageSizeGrid(),
            
            const SizedBox(height: 24),
            
            // Orientation Section
            const Text(
              'Orientation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildOrientationSelector(),
            
            const SizedBox(height: 24),
            
            // Preview Section
            const Text(
              'Preview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildPreview(),
            
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    widget.onFormatChanged(_selectedFormat);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageSizeGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PageSize.values.map((size) {
            final isSelected = _selectedFormat.size == size;
            return InkWell(
              onTap: () {
                setState(() {
                  if (size == PageSize.custom) {
                    _selectedFormat = _selectedFormat.copyWith(
                      size: size,
                      customSize: Size(
                        double.tryParse(_customWidthController.text) ?? 595,
                        double.tryParse(_customHeightController.text) ?? 842,
                      ),
                    );
                  } else {
                    _selectedFormat = _selectedFormat.copyWith(size: size);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  size.displayName,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).primaryColor : null,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        // Custom size input fields
        if (_selectedFormat.size == PageSize.custom) ...[
          const SizedBox(height: 16),
          const Text(
            'Custom Dimensions (in points)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customWidthController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Width',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    _updateCustomSize();
                  },
                ),
              ),
              const SizedBox(width: 12),
              const Text('×'),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _customHeightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    _updateCustomSize();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Reference: A4 = 595×842, Letter = 612×792',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Quick Presets:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              _buildPresetButton('Square', 595, 595),
              _buildPresetButton('Wide', 842, 595),
              _buildPresetButton('Tall', 420, 842),
            ],
          ),
        ],
      ],
    );
  }

  void _updateCustomSize() {
    if (_selectedFormat.size == PageSize.custom) {
      final width = double.tryParse(_customWidthController.text) ?? 595;
      final height = double.tryParse(_customHeightController.text) ?? 842;
      
      setState(() {
        _selectedFormat = _selectedFormat.copyWith(
          customSize: Size(width, height),
        );
      });
    }
  }

  Widget _buildPresetButton(String label, double width, double height) {
    return InkWell(
      onTap: () {
        _customWidthController.text = width.toInt().toString();
        _customHeightController.text = height.toInt().toString();
        _updateCustomSize();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildOrientationSelector() {
    return Row(
      children: PageOrientation.values.map((orientation) {
        final isSelected = _selectedFormat.orientation == orientation;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFormat = _selectedFormat.copyWith(orientation: orientation);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      orientation.icon,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      orientation.displayName,
                      style: TextStyle(
                        color: isSelected ? Theme.of(context).primaryColor : null,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPreview() {
    final previewSize = _selectedFormat.getDisplayDimensions(scale: 0.3);
    final actualDimensions = _selectedFormat.actualDimensions;
    
    return Center(
      child: Container(
        width: previewSize.width.clamp(60.0, 120.0),
        height: previewSize.height.clamp(80.0, 160.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _selectedFormat.size.displayName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _selectedFormat.orientation.displayName,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              if (_selectedFormat.size == PageSize.custom) ...[
                const SizedBox(height: 4),
                Text(
                  '${actualDimensions.width.toInt()}×${actualDimensions.height.toInt()}',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
