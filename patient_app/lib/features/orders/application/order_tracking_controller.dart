import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/order_repository.dart';
import '../domain/order.dart';

class OrderTrackingController extends FamilyAsyncNotifier<Order, int> {
  Timer? _timer;

  @override
  Future<Order> build(int orderId) async {
    ref.onDispose(() => _timer?.cancel());
    final order = await ref.read(orderRepositoryProvider).show(orderId);
    if (!order.status.isTerminal) _startPolling(orderId);
    return order;
  }

  void _startPolling(int orderId) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final order =
            await ref.read(orderRepositoryProvider).show(orderId);
        state = AsyncData(order);
        if (order.status.isTerminal) _timer?.cancel();
      } catch (_) {}
    });
  }
}

final orderTrackingProvider = AsyncNotifierProviderFamily<
    OrderTrackingController, Order, int>(OrderTrackingController.new);

// Recent orders list
class OrdersListController extends AsyncNotifier<List<Order>> {
  @override
  Future<List<Order>> build() =>
      ref.read(orderRepositoryProvider).list();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(orderRepositoryProvider).list());
  }
}

final ordersListControllerProvider =
    AsyncNotifierProvider<OrdersListController, List<Order>>(
        OrdersListController.new);
