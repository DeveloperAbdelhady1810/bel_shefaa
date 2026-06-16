import 'push_service.dart';

/// No-op implementation — swap for FirebasePushService once google-services.json lands.
class PushServiceStub implements PushService {
  const PushServiceStub();

  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> registerToken(String token) async {}
}
