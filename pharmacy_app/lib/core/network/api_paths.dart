class ApiPaths {
  static const String pharmacyLogin = '/pharmacy/login';
  static const String pharmacyMe = '/pharmacy/me';
  static const String pharmacyLogout = '/pharmacy/logout';
  static const String pharmacyFcmToken = '/pharmacy/fcm-token';
  static const String pharmacyOrders = '/pharmacy/orders';
  static String pharmacyOrderAccept(int orderId) =>
      '/pharmacy/orders/$orderId/accept';
  static String pharmacyOrderReject(int orderId) =>
      '/pharmacy/orders/$orderId/reject';
  static const String pharmacyStock = '/pharmacy/stock';
  static const String pharmacyStockLookup = '/pharmacy/stock/lookup';
}
