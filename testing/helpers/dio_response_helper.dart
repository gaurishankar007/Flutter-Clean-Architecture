import 'package:dio/dio.dart';

Response<dynamic> getResponse({
  dynamic data,
  String responseDataKey = 'data',
  String? message,
  int? statusCode,
  RequestOptions? requestOptions,
  bool isStandardResponse = true,
}) => Response(
  data: isStandardResponse ? {responseDataKey: data, 'message': message} : data,
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
