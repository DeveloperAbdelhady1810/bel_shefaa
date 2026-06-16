import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../domain/pharmacy_user.dart';
import '../../notifications/push_service.dart';
import '../../notifications/push_service_stub.dart';

// Registered in main.dart via ProviderScope overrides if needed.
final pushServiceProvider = Provider<PushService>((_) => const PushServiceStub());

sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final PharmacyUser user;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final repo = ref.read(authRepositoryProvider);
    // Bootstrap: check if a stored token is still valid.
    try {
      final user = await repo.me();
      return AuthAuthenticated(user);
    } catch (_) {
      return const AuthUnauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final push = ref.read(pushServiceProvider);
      final result = await repo.login(email, password);
      // Register FCM token after login (no-op in stub mode).
      final fcmToken = await push.getToken();
      if (fcmToken != null) {
        await repo.updateFcmToken(fcmToken);
      }
      return AuthAuthenticated(result.user);
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(AuthUnauthenticated());
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthState>(AuthController.new);
