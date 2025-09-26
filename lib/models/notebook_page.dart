import 'package:navinotes/models/paper_template.dart';
import 'package:navinotes/packages.dart';

/// Represents a single page in a notebook
class NotebookPage {
  final String id;
  final String notebookId;
  final int pageNumber;
  final PaperTemplate template;
  final String? handwritingData; // SVG or path data for handwriting
  final String? textContent; // Rich text content
  final String? drawingData; // Drawing/sketch data
  final List<PageAnnotation> annotations;
  final int createdAt;
  final int updatedAt;
  final bool hasContent;

  NotebookPage({
    String? id,
    required this.notebookId,
    required this.pageNumber,
    required this.template,
    this.handwritingData,
    this.textContent,
    this.drawingData,
    this.annotations = const [],
    required this.createdAt,
    required this.updatedAt,
    this.hasContent = false,
  }) : id = id ?? const Uuid().v4();

  NotebookPage copyWith({
    String? id,
    String? notebookId,
    int? pageNumber,
    PaperTemplate? template,
    String? handwritingData,
    String? textContent,
    String? drawingData,
    List<PageAnnotation>? annotations,
    int? createdAt,
    int? updatedAt,
    bool? hasContent,
  }) {
    return NotebookPage(
      id: id ?? this.id,
      notebookId: notebookId ?? this.notebookId,
      pageNumber: pageNumber ?? this.pageNumber,
      template: template ?? this.template,
      handwritingData: handwritingData ?? this.handwritingData,
      textContent: textContent ?? this.textContent,
      drawingData: drawingData ?? this.drawingData,
      annotations: annotations ?? this.annotations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasContent: hasContent ?? this.hasContent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notebook_id': notebookId,
      'page_number': pageNumber,
      'template_data': jsonEncode(template.toMap()),
      'handwriting_data': handwritingData,
      'text_content': textContent,
      'drawing_data': drawingData,
      'annotations': jsonEncode(annotations.map((a) => a.toMap()).toList()),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'has_content': hasContent ? 1 : 0,
    };
  }

  factory NotebookPage.fromMap(Map<String, dynamic> map) {
    List<PageAnnotation> annotationsList = [];
    if (map['annotations'] != null) {
      final annotationsJson = jsonDecode(map['annotations']) as List;
      annotationsList = annotationsJson
          .map((a) => PageAnnotation.fromMap(a as Map<String, dynamic>))
          .toList();
    }

    return NotebookPage(
      id: map['id'] ?? '',
      notebookId: map['notebook_id'] ?? '',
      pageNumber: map['page_number'] ?? 0,
      template: PaperTemplate.fromMap(
        jsonDecode(map['template_data'] ?? '{}') as Map<String, dynamic>,
      ),
      handwritingData: map['handwriting_data'],
      textContent: map['text_content'],
      drawingData: map['drawing_data'],
      annotations: annotationsList,
      createdAt: map['created_at'] ?? 0,
      updatedAt: map['updated_at'] ?? 0,
      hasContent: (map['has_content'] ?? 0) == 1,
    );
  }
}

/// Represents annotations on a page (highlights, shapes, etc.)
class PageAnnotation {
  final String id;
  final AnnotationType type;
  final Map<String, dynamic> data; // Position, size, color, etc.
  final int createdAt;

  PageAnnotation({
    String? id,
    required this.type,
    required this.data,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'data': jsonEncode(data),
      'created_at': createdAt,
    };
  }

  factory PageAnnotation.fromMap(Map<String, dynamic> map) {
    return PageAnnotation(
      id: map['id'] ?? '',
      type: AnnotationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AnnotationType.highlight,
      ),
      data: jsonDecode(map['data'] ?? '{}') as Map<String, dynamic>,
      createdAt: map['created_at'] ?? 0,
    );
  }
}

enum AnnotationType {
  highlight,
  underline,
  strikethrough,
  shape,
  arrow,
  textBox,
}

