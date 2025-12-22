import 'package:dio/dio.dart';

Response getResponse({
  dynamic data,
  String responseDataKey = 'data',
  String? message,
  int? statusCode,
  RequestOptions? requestOptions,
}) => Response(
  data: {responseDataKey: data, 'message': message},
  requestOptions: requestOptions ?? RequestOptions(),
  statusCode: statusCode,
);

DioException getDioException({
  dynamic data,
  String responseDataKey = 'data',
  String? message,
  int? statusCode,
  RequestOptions? requestOptions,
}) => DioException(
  requestOptions: requestOptions ?? RequestOptions(),
  response: getResponse(
    responseDataKey: responseDataKey,
    data: data,
    message: message,
    statusCode: statusCode,
  ),
  type: DioExceptionType.badResponse,
);
