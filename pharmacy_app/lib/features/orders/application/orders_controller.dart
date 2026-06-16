import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/orders_repository.dart';
import '../domain/incoming_order.dart';

class OrdersController extends AsyncNotifier<List<IncomingOrder>> {
  Timer? _timer;

  @override
  Future<List<IncomingOrder>> build() async {
    ref.onDispose(() => _timer?.cancel());
    _startPolling();
    return _fetch();
  }

  Future<List<IncomingOrder>> _fetch() =>
      ref.read(ordersRepositoryProvider).fetchIncoming();

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) async {
      try {
        final orders = await _fetch();
        state = AsyncData(orders);
      } catch (_) {}
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<bool> accept(int orderId) async {
    final repo = ref.read(ordersRepositoryProvider);
    final result = await repo.accept(orderId);
    if (result.won) {
      // Remove from list immediately.
      state.whenData((list) {
        state = AsyncData(
            list.where((o) => o.orderId != orderId).toList());
      });
    }
    return result.won;
  }

  Future<String> acceptWithMessage(int orderId) async {
    final repo = ref.read(ordersRepositoryProvider);
    final result = await repo.accept(orderId);
    if (result.won) {
      state.whenData((list) {
        state = AsyncData(
            list.where((o) => o.orderId != orderId).toList());
      });
    }
    return result.message;
  }

  Future<void> reject(int orderId, {String? reason}) async {
    await ref.read(ordersRepositoryProvider).reject(orderId, reason: reason);
    state.whenData((list) {
      state =
          AsyncData(list.where((o) => o.orderId != orderId).toList());
    });
  }
}

final ordersControllerProvider =
    AsyncNotifierProvider<OrdersController, List<IncomingOrder>>(
        OrdersController.new);
