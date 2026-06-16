import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/providers/core_providers.dart';
import '../../auth/domain/patient.dart';

class AddressRepository {
  AddressRepository(this._dio);
  final Dio _dio;

  Future<List<PatientAddress>> list() async {
    try {
      final res = await _dio.get(ApiPaths.addresses);
      return (res.data as List<dynamic>)
          .map((e) =>
              PatientAddress.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر تحميل العناوين.');
    }
  }

  Future<PatientAddress> store({
    required String label,
    required String addressLine,
    String? city,
    String? district,
    required double lat,
    required double lng,
    bool isDefault = false,
  }) async {
    try {
      final res = await _dio.post(ApiPaths.addresses, data: {
        'label': label,
        'address_line': addressLine,
        if (city != null) 'city': city,
        if (district != null) 'district': district,
        'lat': lat,
        'lng': lng,
        'is_default': isDefault,
      });
      return PatientAddress.fromJson(
          Map<String, dynamic>.from(res.data as Map));
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر حفظ العنوان.');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _dio.delete(ApiPaths.address(id));
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر حذف العنوان.');
    }
  }
}

final addressRepositoryProvider = Provider<AddressRepository>(
    (ref) => AddressRepository(ref.read(dioProvider)));
