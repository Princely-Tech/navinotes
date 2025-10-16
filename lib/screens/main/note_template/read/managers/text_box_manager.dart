import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/creation/models/text_box.dart';


/// Manages text boxes for a drawing canvas
class TextBoxManager extends ChangeNotifier {
  final List<TextBox> _textBoxes = [];
  String? _selectedTextBoxId;
  String? _editingTextBoxId;
  TextBoxFormat _currentFormat = const TextBoxFormat();

  /// Get all text boxes
  List<TextBox> get textBoxes => List.unmodifiable(_textBoxes);

  /// Get selected text box ID
  String? get selectedTextBoxId => _selectedTextBoxId;

  /// Get editing text box ID
  String? get editingTextBoxId => _editingTextBoxId;

  /// Get current text box format
  TextBoxFormat get currentFormat => _currentFormat;

  /// Get selected text box
  TextBox? get selectedTextBox {
    if (_selectedTextBoxId == null) return null;
    try {
      return _textBoxes.firstWhere((tb) => tb.id == _selectedTextBoxId);
    } catch (e) {
      return null;
    }
  }

  /// Add a new text box at the specified position
  TextBox addTextBox(Offset position, {String? text, TextBoxFormat? format}) {
    final textBoxFormat = format ?? _currentFormat;
    final textBox = TextBox.create(
      position: position,
      text: text ?? 'Text',
      textStyle: textBoxFormat.textStyle,
    ).copyWith(
      backgroundColor: textBoxFormat.backgroundColor,
      hasBorder: textBoxFormat.hasBorder,
      borderColor: textBoxFormat.borderColor,
      borderWidth: textBoxFormat.borderWidth,
      borderRadius: textBoxFormat.borderRadius,
      textAlign: textBoxFormat.textAlign,
    );

    _textBoxes.add(textBox);
    _selectedTextBoxId = textBox.id;
    notifyListeners();
    return textBox;
  }

  /// Update an existing text box
  void updateTextBox(TextBox updatedTextBox) {
    final index = _textBoxes.indexWhere((tb) => tb.id == updatedTextBox.id);
    if (index != -1) {
      _textBoxes[index] = updatedTextBox;
      notifyListeners();
    }
  }

  /// Delete a text box
  void deleteTextBox(String textBoxId) {
    _textBoxes.removeWhere((tb) => tb.id == textBoxId);
    if (_selectedTextBoxId == textBoxId) {
      _selectedTextBoxId = null;
    }
    if (_editingTextBoxId == textBoxId) {
      _editingTextBoxId = null;
    }
    notifyListeners();
  }

  /// Select a text box
  void selectTextBox(String? textBoxId) {
    if (_selectedTextBoxId != textBoxId) {
      _selectedTextBoxId = textBoxId;
      _editingTextBoxId = null; // Stop editing when selecting different text box
      notifyListeners();
    }
  }

  /// Start editing a text box
  void startEditing(String? textBoxId) {
    if (textBoxId != null) {
      _selectedTextBoxId = textBoxId;
      _editingTextBoxId = textBoxId;
      notifyListeners();
    }
  }

  /// Stop editing
  void stopEditing() {
    if (_editingTextBoxId != null) {
      _editingTextBoxId = null;
      notifyListeners();
    }
  }

  /// Clear selection
  void clearSelection() {
    if (_selectedTextBoxId != null || _editingTextBoxId != null) {
      _selectedTextBoxId = null;
      _editingTextBoxId = null;
      notifyListeners();
    }
  }

  /// Update current format
  void updateFormat(TextBoxFormat format) {
    _currentFormat = format;
    
    // Apply format to selected text box if any
    if (_selectedTextBoxId != null) {
      final selectedTextBox = this.selectedTextBox;
      if (selectedTextBox != null) {
        final updatedTextBox = selectedTextBox.copyWith(
          textStyle: format.textStyle,
          backgroundColor: format.backgroundColor,
          hasBorder: format.hasBorder,
          borderColor: format.borderColor,
          borderWidth: format.borderWidth,
          borderRadius: format.borderRadius,
          textAlign: format.textAlign,
          updatedAt: DateTime.now(),
        );
        updateTextBox(updatedTextBox);
      }
    }
    
    notifyListeners();
  }

  /// Get text box at position
  TextBox? getTextBoxAtPosition(Offset position) {
    // Check from top to bottom (reverse order for proper hit testing)
    for (int i = _textBoxes.length - 1; i >= 0; i--) {
      if (_textBoxes[i].containsPoint(position)) {
        return _textBoxes[i];
      }
    }
    return null;
  }

  /// Move text box to front (z-order)
  void moveToFront(String textBoxId) {
    final index = _textBoxes.indexWhere((tb) => tb.id == textBoxId);
    if (index != -1 && index != _textBoxes.length - 1) {
      final textBox = _textBoxes.removeAt(index);
      _textBoxes.add(textBox);
      notifyListeners();
    }
  }

  /// Duplicate selected text box
  TextBox? duplicateSelected() {
    final selected = selectedTextBox;
    if (selected != null) {
      final duplicated = selected.copyWith(
        id: null, // Will generate new ID
        position: selected.position + const Offset(20, 20),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _textBoxes.add(duplicated);
      _selectedTextBoxId = duplicated.id;
      notifyListeners();
      return duplicated;
    }
    return null;
  }

  /// Clear all text boxes
  void clearAll() {
    if (_textBoxes.isNotEmpty) {
      _textBoxes.clear();
      _selectedTextBoxId = null;
      _editingTextBoxId = null;
      notifyListeners();
    }
  }

  /// Load text boxes from JSON
  void loadFromJson(List<dynamic> jsonList) {
    _textBoxes.clear();
    _selectedTextBoxId = null;
    _editingTextBoxId = null;
    
    for (final json in jsonList) {
      try {
        final textBox = TextBox.fromJson(json as Map<String, dynamic>);
        _textBoxes.add(textBox);
      } catch (e) {
        debugPrint('Error loading text box from JSON: $e');
      }
    }
    
    notifyListeners();
  }

  /// Convert text boxes to JSON
  List<Map<String, dynamic>> toJson() {
    return _textBoxes.map((tb) => tb.toJson()).toList();
  }

  /// Get text boxes count
  int get count => _textBoxes.length;

  /// Check if any text box is being edited
  bool get isEditing => _editingTextBoxId != null;

  /// Check if any text box is selected
  bool get hasSelection => _selectedTextBoxId != null;

  @override
  void dispose() {
    _textBoxes.clear();
    super.dispose();
  }
}
