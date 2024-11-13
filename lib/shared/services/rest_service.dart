import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_shop/main/app_env.dart';
import 'package:online_shop/shared/data/local/local_token_storage.dart';
import 'package:online_shop/shared/data/models/app_responses.dart';
import 'package:online_shop/shared/services/log_service.dart';

final restServiceProvider = Provider<RestService>(
  (ref) {
    return RestService();
  },
);

class RestService {
  final _errorStream = StreamController<Response>.broadcast();
  Stream<Response> get errorStream => _errorStream.stream;

  late final Dio _client;
  RestService() {
    _client = Dio(BaseOptions(
      baseUrl: EnvInfo.baseUrl,
      connectTimeout: const Duration(seconds: 20),
    ))
      ..options.headers.addAll({
        Headers.contentTypeHeader: Headers.jsonContentType,
        Headers.acceptHeader: Headers.textPlainContentType,
      })
      ..interceptors.addAll([
        InterceptorsWrapper(onRequest: _handleUserTokenOnRequest),
        // InterceptorsWrapper(onRequest: _encryptRequest),
      ])
      ..options.validateStatus = (_) => true;
  }

  void _handleUserTokenOnRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = LocalTokenStorage.getToken();
    if (token?.isNotEmpty ?? false) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  // void _encryptRequest(
  //   RequestOptions options,
  //   RequestInterceptorHandler handler,
  // ) {
  //   /// encryption happens here
  //   final encrypted = Encryption.encryptString(jsonEncode(options.data));
  //   options.data = encrypted.toMap();
  //   return handler.next(options);
  // }

  Future<ApiResponse> _handleResponse(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();

      Map<String, dynamic> data;
      try {
        data = Map<String, dynamic>.from(response.data);
      } catch (e) {
        data = {};
      }

      if ((response.statusCode == 200) || (response.statusCode == 201))
        return ApiResponse(data: data);

      dLog('API error: - $response');

      _errorStream.add(response);

      if (response.statusCode == 401) return ApiError.unauthorized;

      // if (response.statusCode == 400) {
      return ApiError(
        message: data['responseMessage'] ??
            data['title'] ??
            ApiError.unknown.message,
      );
      // }
    } on DioException catch (e) {
      if (e.error is SocketException) return ApiError.socket;
      if (e.type == DioExceptionType.connectionTimeout) return ApiError.timeout;
      dLog('DioException: - $e');
      return ApiError.unknown;
    } catch (e, s) {
      dLog('API unknown Exception: - $e\n$s');
    }
    return ApiError.unknown;
  }

  Future<ApiResponse> get({
    required String path,
    Map<String, dynamic>? params,
  }) {
    return _handleResponse(() => _client.get(path, queryParameters: params));
  }

  Future<ApiResponse> post({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _handleResponse(() => _client.post(
          path,
          data: data,
          queryParameters: queryParameters,
        ));
  }

  Future<ApiResponse> postFormData({
    required String path,
    FormData? data,
  }) {
    return _handleResponse(() => _client.post(path, data: data));
  }

  Future<ApiResponse> put({
    required String path,
    Map<String, dynamic>? data,
  }) {
    return _handleResponse(() => _client.put(path, data: data));
  }

  Future<ApiResponse> delete({
    required String path,
    Map<String, dynamic>? data,
  }) {
    return _handleResponse(() => _client.delete(path, data: data));
  }
}

extension ApiResponseExt on ApiResponse {
  bool get hasError => this is ApiError;
  ApiError get error => this as ApiError;
}
