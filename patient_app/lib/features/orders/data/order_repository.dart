import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/api_paths.dart';
import '../../../core/providers/core_providers.dart';
import '../domain/order.dart';

class OrderRepository {
  OrderRepository(this._dio);
  final Dio _dio;

  Future<Order> create({
    required int drugId,
    required int quantity,
    required int patientAddressId,
    required String paymentMethod,
    String? notes,
    String? prescriptionImagePath,
  }) async {
    try {
      final FormData data = FormData.fromMap({
        'drug_id': drugId,
        'quantity': quantity,
        'patient_address_id': patientAddressId,
        'payment_method': paymentMethod,
        if (notes != null) 'notes': notes,
        if (prescriptionImagePath != null)
          'prescription_image':
              await MultipartFile.fromFile(prescriptionImagePath),
      });
      final res = await _dio.post(ApiPaths.orders, data: data);
      return Order.fromJson(Map<String, dynamic>.from(res.data as Map));
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر إنشاء الطلب.');
    }
  }

  Future<List<Order>> list() async {
    try {
      final res = await _dio.get(ApiPaths.orders);
      final items = res.data['data'] as List<dynamic>;
      return items
          .map((e) => Order.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر تحميل الطلبات.');
    }
  }

  Future<Order> show(int id) async {
    try {
      final res = await _dio.get(ApiPaths.order(id));
      return Order.fromJson(Map<String, dynamic>.from(res.data as Map));
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر تحميل الطلب.');
    }
  }

  Future<({String clientSecret, String paymentUrl})> pay(int id) async {
    try {
      final res = await _dio.post(ApiPaths.orderPay(id));
      return (
        clientSecret: res.data['client_secret'] as String,
        paymentUrl: res.data['payment_url'] as String,
      );
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : ApiException('تعذّر بدء الدفع.');
    }
  }
}

final orderRepositoryProvider = Provider<OrderRepository>(
    (ref) => OrderRepository(ref.read(dioProvider)));
