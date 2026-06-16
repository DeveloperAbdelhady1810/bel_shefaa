import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/address/presentation/onboarding_address_screen.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/otp_request_screen.dart';
import '../../features/auth/presentation/otp_verify_screen.dart';
import '../../features/drugs/presentation/home_screen.dart';
import '../../features/orders/presentation/order_flow_screen.dart';
import '../../features/orders/presentation/orders_history_screen.dart';
import '../../features/orders/presentation/payment_screen.dart';
import '../../features/orders/presentation/tracking_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = _AuthStateListenable(ref);

  return GoRouter(
    refreshListenable: authListenable,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider).valueOrNull;
      final isLoading = ref.read(authControllerProvider).isLoading;
      if (isLoading) return null;

      final isAuthenticated = auth is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/otp');

      if (!isAuthenticated && !isAuthRoute) return '/otp-request';
      if (isAuthenticated && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/otp-request',
        builder: (_, __) => const OtpRequestScreen(),
      ),
      GoRoute(
        path: '/otp-verify',
        builder: (_, state) {
          final email = state.extra as String? ?? '';
          return OtpVerifyScreen(email: email);
        },
      ),
      GoRoute(
        path: '/onboarding-address',
        builder: (_, __) => const OnboardingAddressScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/order-flow',
        builder: (_, __) => const OrderFlowScreen(),
      ),
      GoRoute(
        path: '/payment/:orderId',
        builder: (_, state) {
          final orderId = int.parse(state.pathParameters['orderId']!);
          return PaymentScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/tracking/:orderId',
        builder: (_, state) {
          final orderId = int.parse(state.pathParameters['orderId']!);
          return TrackingScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/orders-history',
        builder: (_, __) => const OrdersHistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfileScreen(),
      ),
    ],
    initialLocation: '/otp-request',
  );
});

class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(this._ref) {
    _ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}
