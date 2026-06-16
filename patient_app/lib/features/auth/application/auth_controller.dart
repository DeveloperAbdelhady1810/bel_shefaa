import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../domain/patient.dart';

sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.patient);
  final Patient patient;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    try {
      final patient = await ref.read(authRepositoryProvider).me();
      return AuthAuthenticated(patient);
    } catch (_) {
      return const AuthUnauthenticated();
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(AuthUnauthenticated());
  }

  void setAuthenticated(Patient patient) {
    state = AsyncData(AuthAuthenticated(patient));
  }

  void refreshPatient(Patient patient) {
    state = AsyncData(AuthAuthenticated(patient));
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthState>(AuthController.new);
