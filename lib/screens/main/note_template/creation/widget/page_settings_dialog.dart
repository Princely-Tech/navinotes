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

  @override
  void initState() {
    super.initState();
    _selectedFormat = widget.currentFormat;
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PageSize.values.where((size) => size != PageSize.custom).map((size) {
        final isSelected = _selectedFormat.size == size;
        return InkWell(
          onTap: () {
            setState(() {
              _selectedFormat = _selectedFormat.copyWith(size: size);
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
    return Center(
      child: Container(
        width: previewSize.width,
        height: previewSize.height,
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
            ],
          ),
        ),
      ),
    );
  }
}
