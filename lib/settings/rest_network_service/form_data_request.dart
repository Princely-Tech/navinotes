import 'dart:io';

import 'json_request.dart';

class FormDataRequest extends JsonRequest {
  final Map<String, File> files;

  FormDataRequest.raw(
    super.method, {
    required super.endpoint,
    required this.files,
    required Map<String, dynamic>? otherData,
    required super.queryParams,
  }) : super(body: otherData ?? const {});

  FormDataRequest.post(
    String endpoint,
    this.files, {
    Map<String, dynamic>? otherData,
    super.queryParams,
  }) : super(POST, endpoint: endpoint, body: otherData ?? const {});

  FormDataRequest.patch(
    String endpoint,
    this.files, {
    Map<String, dynamic>? otherData,
    super.queryParams,
  }) : super(PATCH, endpoint: endpoint, body: otherData ?? const {});

  FormDataRequest.put(
    String endpoint,
    this.files, {
    Map<String, dynamic>? otherData,
    super.queryParams,
  }) : super(PUT, endpoint: endpoint, body: otherData ?? const {});

  FormDataRequest.delete(
    String endpoint,
    this.files, {
    Map<String, dynamic>? otherData,
    super.queryParams,
  }) : super(DELETE, endpoint: endpoint, body: otherData ?? const {});

  FormDataRequest.get(String endpoint, {super.queryParams})
    : files = const {},
      super(DELETE, endpoint: endpoint, body: const {});

  @override
  bool operator ==(other) =>
      other is FormDataRequest &&
      endpoint == other.endpoint &&
      method == other.method;

  @override
  int get hashCode => endpoint.hashCode;
}
