import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/orders/presentation/incoming_orders_screen.dart';
import '../../features/orders/presentation/order_detail_screen.dart';
import '../../features/orders/domain/incoming_order.dart';
import '../../features/stock/presentation/stock_edit_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      if (authState.isLoading) return null;
      final isLoggedIn = authState.valueOrNull is AuthAuthenticated;
      final onLogin = state.matchedLocation == '/login';
      if (!isLoggedIn && !onLogin) return '/login';
      if (isLoggedIn && onLogin) return '/orders';
      return null;
    },
    refreshListenable: _AuthStateListenable(ref),
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (_, __) => const IncomingOrdersScreen(),
        routes: [
          GoRoute(
            path: 'detail',
            builder: (_, state) {
              final order = state.extra as IncomingOrder;
              return OrderDetailScreen(order: order);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/stock',
        builder: (_, __) => const StockEditScreen(),
      ),
    ],
  );
});

// Makes GoRouter re-evaluate redirect when auth state changes.
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(this._ref) {
    _ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}
