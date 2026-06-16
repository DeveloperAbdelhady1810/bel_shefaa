import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/token_storage.dart';
import '../domain/pharmacy_user.dart';

class AuthRepository {
  AuthRepository(this._dio, this._authedDio, this._storage);

  final Dio _dio;       // unauthenticated — for login
  final Dio _authedDio; // authenticated  — for me / logout / fcm-token
  final TokenStorage _storage;

  Future<({String token, PharmacyUser user})> login(
      String email, String password) async {
    try {
      final res = await _dio.post(ApiPaths.pharmacyLogin, data: {
        'email': email,
        'password': password,
        'device_name': 'pharmacy_mobile',
      });
      final token = res.data['token'] as String;
      final user = PharmacyUser.fromJson(
          Map<String, dynamic>.from(res.data['user'] as Map));
      await _storage.write(token);
      return (token: token, user: user);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('فشل تسجيل الدخول.');
    }
  }

  Future<PharmacyUser> me() async {
    try {
      final res = await _authedDio.get(ApiPaths.pharmacyMe);
      return PharmacyUser.fromJson(Map<String, dynamic>.from(res.data as Map));
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر تحميل بيانات المستخدم.');
    }
  }

  Future<void> logout() async {
    try {
      await _authedDio.post(ApiPaths.pharmacyLogout);
    } catch (_) {}
    await _storage.delete();
  }

  Future<void> updateFcmToken(String fcmToken) async {
    try {
      await _authedDio.post(ApiPaths.pharmacyFcmToken,
          data: {'fcm_token': fcmToken});
    } catch (_) {}
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(baseDioProvider),
    ref.read(dioProvider),
    ref.read(tokenStorageProvider),
  );
});
