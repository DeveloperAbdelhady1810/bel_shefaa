class ApiPaths {
  // Auth
  static const String otpRequest = '/patient/otp/request';
  static const String otpVerify = '/patient/otp/verify';
  static const String logout = '/patient/logout';
  static const String me = '/patient/me';

  // Addresses
  static const String addresses = '/patient/addresses';
  static String address(int id) => '/patient/addresses/$id';

  // Drugs
  static const String drugsSearch = '/drugs/search';
  static const String drugsByCategory = '/drugs/by-category';

  // Orders
  static const String orders = '/patient/orders';
  static String order(int id) => '/patient/orders/$id';
  static String orderPay(int id) => '/patient/orders/$id/pay';
}
