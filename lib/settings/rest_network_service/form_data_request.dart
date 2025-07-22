import 'dart:io';

import 'json_request.dart';

class FormDataRequest extends JsonRequest {
  final Map<String, File> files;
  
  FormDataRequest.post(
    String endpoint, {
    this.files = const {},
    Map<String, dynamic>? body,
    super.queryParams,
  }) : super(POST, endpoint: endpoint, body: body ?? const {});

  @override
  bool operator ==(other) =>
      other is FormDataRequest &&
      endpoint == other.endpoint &&
      method == other.method;

  @override
  int get hashCode => endpoint.hashCode;
}
