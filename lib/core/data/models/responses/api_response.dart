import 'package:dio/dio.dart';

class ApiResponse<T extends Object?> {
  ApiResponse({
    required this.data,
    required this.statusCode,
    required this.success,
    required this.message,
  });

  factory ApiResponse.fromResponse(Response<dynamic> response) {
    final data = response.data as Map<String, dynamic>;
    final statusCode = response.statusCode ?? 0;

    return ApiResponse<T>(
      data: data['data'] as T,
      statusCode: statusCode,
      success: data['success'] as bool,
      message: data['message'] as String,
    );
  }
  final T data;
  final int statusCode;
  final bool success;
  final String message;
}
