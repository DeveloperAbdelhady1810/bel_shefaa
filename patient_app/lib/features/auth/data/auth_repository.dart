import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/token_storage.dart';
import '../domain/patient.dart';

class AuthRepository {
  AuthRepository(this._dio, this._authedDio, this._storage);

  final Dio _dio;
  final Dio _authedDio;
  final TokenStorage _storage;

  Future<void> requestOtp(String email) async {
    try {
      await _dio.post(ApiPaths.otpRequest, data: {'email': email});
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر إرسال الكود.');
    }
  }

  Future<({String token, Patient patient, bool isNew})> verifyOtp({
    required String email,
    required String code,
    String? name,
    String? phone,
  }) async {
    try {
      final res = await _dio.post(ApiPaths.otpVerify, data: {
        'email': email,
        'code': code,
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        'device_name': 'patient_mobile',
      });
      final token = res.data['token'] as String;
      await _storage.write(token);
      final patient =
          Patient.fromJson(Map<String, dynamic>.from(res.data['patient'] as Map));
      return (token: token, patient: patient, isNew: patient.addresses.isEmpty);
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('رمز التحقق غير صحيح أو منتهي.');
    }
  }

  Future<Patient> me() async {
    try {
      final res = await _authedDio.get(ApiPaths.me);
      return Patient.fromJson(Map<String, dynamic>.from(res.data as Map));
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر تحميل بيانات المستخدم.');
    }
  }

  Future<void> logout() async {
    try {
      await _authedDio.post(ApiPaths.logout);
    } catch (_) {}
    await _storage.delete();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(
      ref.read(baseDioProvider),
      ref.read(dioProvider),
      ref.read(tokenStorageProvider),
    ));
