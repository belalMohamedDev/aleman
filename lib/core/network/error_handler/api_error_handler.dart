import 'package:aleman/core/network/failure/api_error_model.dart';
import 'package:aleman/core/services/app_logger.dart';
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    appLogger.error('API Error occurred', error);
    if (error is DioException) {
      final status = error.response?.statusCode;
      final data = error.response?.data;

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(message: 'Connection timeout with server');

        case DioExceptionType.sendTimeout:
          return ApiErrorModel(message: 'Send timeout with server');

        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(message: 'Receive timeout with server');

        case DioExceptionType.badResponse:
          return _parseServerError(status, data);

        case DioExceptionType.cancel:
          return ApiErrorModel(message: 'Request was cancelled');

        case DioExceptionType.connectionError:
          return ApiErrorModel(message: 'No internet connection');

        default:
          return ApiErrorModel(message: 'Unexpected error occurred');
      }
    } else {
      return ApiErrorModel(message: 'Unexpected error occurred');
    }
  }

  /// Parse server error body (400–500)
  static ApiErrorModel _parseServerError(int? statusCode, dynamic data) {
    if (data != null && data is Map<String, dynamic>) {
      try {
        // Try parsing as the GlobalExceptionHandler format first
        if (data.containsKey('status') || data.containsKey('detail')) {
          return ApiErrorModel.fromJson(data);
        }
        
        // Fallback for generic formats
        String message = 'Unknown server error';
        if (data.containsKey('message')) {
          message = data['message'];
        } else if (data.containsKey('error')) {
          message = data['error'];
        } else if (data.containsKey('errors')) {
          if (data['errors'] is List && data['errors'].isNotEmpty) {
            message = data['errors'][0].toString();
          }
        }
        return ApiErrorModel(message: message, status: statusCode);
      } catch (_) {}
    } else if (data is String) {
      return ApiErrorModel(message: data, status: statusCode);
    }

    return ApiErrorModel(message: 'Unknown server error', status: statusCode);
  }
}
