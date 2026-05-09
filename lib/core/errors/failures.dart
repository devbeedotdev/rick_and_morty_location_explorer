import 'package:equatable/equatable.dart';

abstract class AppFailure extends Equatable {
  final String message;
  const AppFailure(this.message);
  @override
  List<Object?> get props => [message];
}
class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'No internet connection']);
}
class ServerFailure extends AppFailure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
  @override
  List<Object?> get props => [message, statusCode];
}
class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'Resource not found']);
}
class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Cache read/write failed']);
}
class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
