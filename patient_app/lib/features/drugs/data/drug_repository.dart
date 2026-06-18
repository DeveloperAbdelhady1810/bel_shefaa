import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/providers/core_providers.dart';
import '../domain/drug_result.dart';

class DrugRepository {
  DrugRepository(this._dio);
  final Dio _dio;

  Future<List<DrugResult>> search(String q, {double? lat, double? lng}) async {
    try {
      final res = await _dio.get(ApiPaths.drugsSearch, queryParameters: {
        'q': q,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      });
      final data = res.data['data'] as List<dynamic>;
      return data
          .map((e) =>
              DrugResult.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر البحث.');
    }
  }

  Future<List<DrugResult>> byCategory(String slug,
      {double? lat, double? lng}) async {
    try {
      final res = await _dio.get(ApiPaths.drugsByCategory, queryParameters: {
        'slug': slug,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      });
      final data = res.data['data'] as List<dynamic>;
      return data
          .map((e) =>
              DrugResult.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر تحميل هذا القسم.');
    }
  }
}

final drugRepositoryProvider = Provider<DrugRepository>(
    (ref) => DrugRepository(ref.read(baseDioProvider)));
