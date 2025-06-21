import 'package:flutter/material.dart';

import 'form_data_request.dart';
import 'json_request.dart';

export 'form_data_request.dart';
export 'json_request.dart';

typedef Json = Map<String, dynamic>;

/// Service used to interact with external REST apps and apis
abstract class RestNetworkService {
  @protected
  final String baseUrl, apiVersion;

  @protected
  final bool isProd;

  @protected
  final Duration sendTimeout, receiveTimeout;

  RestNetworkService({
    required this.baseUrl,
    required this.apiVersion,
    required this.isProd,
    required this.sendTimeout,
    Duration? receiveTimeout,
  }) : receiveTimeout = receiveTimeout ?? sendTimeout;

  // bool get initialized => _ready;
  // bool _ready = false;
  // @mustCallSuper
  // bool init({
  //   required String baseUrl,
  //   required String apiVersion,
  //   required Duration sendTimeout,
  //   required bool isProd,
  //   Duration? receiveTimeout,
  // }) {
  //   if (!_ready) {
  //     baseUrl = baseUrl;
  //     apiVersion = apiVersion;
  //     _ready = true;
  //     return true;
  //   }
  //   return false;
  // }

  /// Sends a Json request with the specified [request].
  ///
  /// Throws a [NetworkException], [TimeoutException], [ServerException], or [InputException] if there is an error.
  Future<Json> sendJsonRequest<T>(JsonRequest request);

  /// Sends a multipart/form-data request with the specified [request].
  ///
  /// Throws a [NetworkException], [TimeoutException], [ServerException], or [InputException] if there is an error.
  Future<Json> sendFormDataRequest<T>(FormDataRequest request);
}
