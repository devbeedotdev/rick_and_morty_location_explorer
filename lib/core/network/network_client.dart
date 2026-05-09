import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../errors/failures.dart';

class NetworkClient {
  late final Dio _dio;
  NetworkClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ));
    _dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false, logPrint: (o) => _log(o.toString())),
    );
  }
  Dio get dio => _dio;
  void _log(String msg) => print('[Network] $msg'); // ignore: avoid_print
}

AppFailure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      if (code == 404) return const NotFoundFailure();
      return ServerFailure(e.response?.data?['error'] ?? 'Server error', statusCode: code);
    default:
      return UnknownFailure(e.message ?? 'Unknown error');
  }
}
