import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../network/api_exception.dart';
import '../storage/token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return const TokenStorage(FlutterSecureStorage());
});

// Raw Dio without auth — used by the auth repository itself to avoid circular dep.
final baseDioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: '$kApiBaseUrl/api',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json'},
  ));
});

// Authenticated Dio — attaches Bearer token from storage; 401 → clears token.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: '$kApiBaseUrl/api',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json'},
  ));

  final storage = ref.read(tokenStorageProvider);

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await storage.read();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (e, handler) async {
      if (e.response?.statusCode == 401) {
        await storage.delete();
      }
      final message = _extractMessage(e);
      handler.reject(
        DioException(
          requestOptions: e.requestOptions,
          error: ApiException(message, statusCode: e.response?.statusCode),
          response: e.response,
          type: e.type,
        ),
      );
    },
  ));

  return dio;
});

String _extractMessage(DioException e) {
  try {
    final data = e.response?.data;
    if (data is Map) {
      if (data['message'] != null) return data['message'].toString();
      if (data['errors'] is Map) {
        final first = (data['errors'] as Map).values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
      }
    }
  } catch (_) {}
  return 'حدث خطأ، يرجى المحاولة مجدداً.';
}
