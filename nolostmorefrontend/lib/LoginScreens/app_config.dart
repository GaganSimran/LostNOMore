class AppConfig {
  // MAIN URL
  static const String baseUrl = "https://nolostmore-backend.onrender.com";

 //API END POINTS
  static String get users => "$baseUrl/users";
  static String get login => "$baseUrl/users/login";
  static String get items => "$baseUrl/items";
  static String get reports => "$baseUrl/reports";
  static String get notifications => "$baseUrl/notifications";
}