import 'package:navinotes/packages.dart';

mixin AppRepository {
  @protected
  Logger get logger => Logger(runtimeType.toString());

  /// Converts an exception [e] to a corresponding [Failure].
  @protected
  Failure convertException(e) {
    if (e is AppException) {
      return e.toFailure();
    } else if (e is TimeoutException) {
      return TimeoutFailure();
    } else {
      return UnknownFailure();
    }
  }

  @protected
  Future<DataResponse<T>> runDataWithGuard<T>(
    FutureOr<DataResponse<T>> Function() closure,
  ) async {
    try {
      final d = await closure();
      return d;
    } on AppException catch (e, t) {
      if (e is! NetworkException) logger.severe(e.toFailure().message, e, t);
      return DataResponse<T>(data: null, error: convertException(e));
    } catch (e, t) {
      logger.severe(e, e, t);
      return DataResponse<T>(data: null, error: convertException(e));
    }
  }
}
