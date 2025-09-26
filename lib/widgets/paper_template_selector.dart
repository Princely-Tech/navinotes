import 'package:flutter/material.dart';
import 'package:navinotes/models/paper_template.dart';
import 'package:navinotes/widgets/paper_background_painter.dart';

/// A widget for selecting a paper template from a list of options.
class PaperTemplateSelector extends StatefulWidget {
  final PaperTemplate initialTemplate;
  final Function(PaperTemplate) onTemplateSelected;

  const PaperTemplateSelector({
    super.key,
    required this.initialTemplate,
    required this.onTemplateSelected,
  });

  @override
  State<PaperTemplateSelector> createState() => _PaperTemplateSelectorState();
}

class _PaperTemplateSelectorState extends State<PaperTemplateSelector> {
  late PaperTemplate _selectedTemplate;
  PaperType _selectedType = PaperType.lined;
  PaperColor _selectedColor = PaperColor.white;
  PaperSize _selectedSize = PaperSize.a4;

  @override
  void initState() {
    super.initState();
    _selectedTemplate = widget.initialTemplate;
  }

  List<PaperTemplate> get _filteredTemplates {
    return PaperTemplates.defaultTemplates
        .where((t) =>
            t.type == _selectedType &&
            t.color == _selectedColor &&
            t.size == _selectedSize)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose Paper',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Filters
              _buildFilters(),

              const Divider(height: 1),

              // Template Grid
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: _filteredTemplates.length,
                  itemBuilder: (context, index) {
                    final template = _filteredTemplates[index];
                    return _buildTemplateCard(template);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFilterDropdown<PaperType>(
            value: _selectedType,
            items: PaperType.values,
            onChanged: (value) => setState(() => _selectedType = value!),
            getDisplayName: (type) => type.displayName,
          ),
          _buildFilterDropdown<PaperColor>(
            value: _selectedColor,
            items: PaperColor.values,
            onChanged: (value) => setState(() => _selectedColor = value!),
            getDisplayName: (color) => color.displayName,
          ),
          _buildFilterDropdown<PaperSize>(
            value: _selectedSize,
            items: PaperSize.values,
            onChanged: (value) => setState(() => _selectedSize = value!),
            getDisplayName: (size) => size.displayName,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown<T>({    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) getDisplayName,
  }) {
    return DropdownButton<T>(
      value: value,
      underline: const SizedBox.shrink(),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(getDisplayName(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTemplateCard(PaperTemplate template) {
    final isSelected = template.id == _selectedTemplate.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTemplate = template;
        });
        widget.onTemplateSelected(template);
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [
              Expanded(
                child: CustomPaint(
                  painter: PaperBackgroundPainter(template: template),
                  size: Size.infinite,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[100],
                child: Text(
                  template.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
