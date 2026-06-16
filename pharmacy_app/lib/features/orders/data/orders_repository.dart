import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/providers/core_providers.dart';
import '../domain/incoming_order.dart';

class OrdersRepository {
  OrdersRepository(this._dio);

  final Dio _dio;

  Future<List<IncomingOrder>> fetchIncoming() async {
    try {
      final res = await _dio.get(ApiPaths.pharmacyOrders);
      final list = res.data as List<dynamic>;
      return list
          .map((e) => IncomingOrder.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر تحميل الطلبات الواردة.');
    }
  }

  Future<({bool won, String message})> accept(int orderId) async {
    try {
      final res = await _dio.post(ApiPaths.pharmacyOrderAccept(orderId));
      return (
        won: res.data['won'] as bool,
        message: res.data['message'] as String,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        final msg = e.response?.data['message'] as String? ??
            'تم قبول الطلب من صيدلية أخرى.';
        return (won: false, message: msg);
      }
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر قبول الطلب.');
    }
  }

  Future<void> reject(int orderId, {String? reason}) async {
    try {
      await _dio.post(ApiPaths.pharmacyOrderReject(orderId),
          data: reason != null ? {'reason': reason} : {});
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر رفض الطلب.');
    }
  }
}

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository(ref.read(dioProvider));
});
