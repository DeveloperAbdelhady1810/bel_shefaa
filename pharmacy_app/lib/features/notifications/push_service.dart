abstract class PushService {
  /// Returns the FCM token, or null when FCM is not configured.
  Future<String?> getToken();

  /// Called after login to register the device token with the backend.
  Future<void> registerToken(String token);
}
