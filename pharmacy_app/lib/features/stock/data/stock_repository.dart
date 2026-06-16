import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/providers/core_providers.dart';

part 'stock_repository.freezed.dart';
part 'stock_repository.g.dart';

@freezed
class DrugLookupResult with _$DrugLookupResult {
  const factory DrugLookupResult({
    required int drugId,
    required String nameAr,
    String? nameEn,
    String? form,
    String? strength,
    required int quantity,
  }) = _DrugLookupResult;

  factory DrugLookupResult.fromJson(Map<String, dynamic> json) =>
      _$DrugLookupResultFromJson(json);
}

class StockRepository {
  StockRepository(this._dio);

  final Dio _dio;

  Future<DrugLookupResult> lookup(String code) async {
    try {
      final res = await _dio.post(ApiPaths.pharmacyStockLookup, data: {'code': code});
      final drug = res.data['drug'] as Map;
      final quantity = int.tryParse(res.data['quantity'].toString()) ?? 0;
      return DrugLookupResult(
        drugId: int.tryParse(drug['id'].toString()) ?? 0,
        nameAr: drug['name_ar'] as String,
        nameEn: drug['name_en'] as String?,
        form: drug['form'] as String?,
        strength: drug['strength'] as String?,
        quantity: quantity,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ApiException('لم يتم العثور على الدواء.', statusCode: 404);
      }
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('خطأ في البحث.');
    }
  }

  Future<void> updateQuantity(int drugId, int quantity) async {
    try {
      await _dio.post(ApiPaths.pharmacyStock,
          data: {'drug_id': drugId, 'quantity': quantity});
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر تحديث الكمية.');
    }
  }
}

final stockRepositoryProvider = Provider<StockRepository>((ref) {
  return StockRepository(ref.read(dioProvider));
});
