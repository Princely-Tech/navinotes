import 'package:navinotes/packages.dart';

/// Implementation of [RestfulApiService] using the Dio library.
class DioNetworkService extends RestNetworkService {
  final Dio _dio;
  final SessionManager sessionManager;
  BuildContext context;
  DioNetworkService({
    required this.sessionManager,
    required this.context,
    required super.baseUrl,
    required super.apiVersion,
    required super.isProd,
    required super.sendTimeout,
    super.receiveTimeout,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: Uri.http(baseUrl, apiVersion).toString(),
           connectTimeout: sendTimeout,
           sendTimeout: sendTimeout,
           receiveTimeout: receiveTimeout ?? sendTimeout,
         ),
       ) {
    _dio.interceptors.addAll([
      if (!isProd || kDebugMode) NetworkLoggerInterceptor(),
      DataErrorInterceptor(context),
    ]);
  }

  @override
  Future<Json> sendFormDataRequest<T>(FormDataRequest request) async {
    // assert(initialized, 'This Network Service has not been initialized');

    final files = request.files.map((key, file) {
      final type = lookupMimeType(file.path);
      final contentType = type != null ? MediaType.parse(type) : null;
      return MapEntry(
        key,
        MultipartFile.fromFileSync(file.path, contentType: contentType),
      );
    });
    final otherData = request.body;

    final data = FormData.fromMap({...files, ...otherData});

    try {
      final response = await _dio.request(
        request.endpoint,
        data: data,
        queryParameters: request.queryParams,
        options: Options(
          method: request.method,
          contentType: 'multipart/form-data',
          headers: sessionManager.sessionHeaders(),
        ),
      );
      final res = response.data;
      if (res is! Map) {
        return {'data': res};
      }
      return res as Map<String, dynamic>;
    } on DioException catch (e) {
      throw e.error!;
    }
  }

  @override
  Future<Json> sendJsonRequest<T>(JsonRequest request) async {
    try {
      final headers = sessionManager.sessionHeaders();
      final response = await _dio.request(
        request.endpoint,
        data: request.body,
        queryParameters: request.queryParams,
        options: Options(
          method: request.method,
          contentType: 'Application/json',
          responseType: ResponseType.json,
          headers: headers,
        ),
      );
      final res = response.data;
      if (res is! Map) {
        return {'data': res};
      }
      return res as Map<String, dynamic>;
    } on DioException catch (e) {
      throw e.error!;
    }
  }
}

class DataErrorInterceptor extends Interceptor {
  BuildContext context;
  DataErrorInterceptor(this.context);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data is! Map) {
      response.data = {'data': response.data};
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.isNetworkError) {
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: NetworkException(),
        ),
      );
    } else if (err.isTimeoutError) {
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: TimeoutException('Request Timed out. Try again'),
        ),
      );
    } else {
      Map json;
      if (err.response == null) {
        json = {};
      } else if (err.response?.data is Map) {
        json = err.response!.data;
      } else {
        json = jsonDecode(err.response!.data);
      }
      
      //Shows error to user
      ErrorDisplayService.showError(context, err);

      final message = json['error'] ?? json['message'];
      AppException exception;
      if (err.isServerError) {
        exception = ServerException(errorMessage: message);
      } else if (err.isForbiddenError) {
        exception = ForbiddenResourceException(errorMessage: message);
      } else if (err.isUnauthorisedError) {
        exception = UnauthorisedException(errorMessage: message);
      } else {
        exception = InputException(errorMessage: message);
      }
      handler.next(
        DioException(requestOptions: err.requestOptions, error: exception),
      );
    }
  }
}

class NetworkLoggerInterceptor extends PrettyDioLogger {
  NetworkLoggerInterceptor()
    : super(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 88,
      );
}

extension DioExceptionExtension on DioException {
  bool get isTimeoutError => [
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.connectionTimeout,
  ].contains(type);

  bool get isNetworkError =>
      error is SocketException || type == DioExceptionType.connectionError;

  bool get isServerError => (response?.statusCode ?? 501) >= 500;
  bool get isForbiddenError => response?.statusCode == 403;
  bool get isUnauthorisedError => response?.statusCode == 401;
}
