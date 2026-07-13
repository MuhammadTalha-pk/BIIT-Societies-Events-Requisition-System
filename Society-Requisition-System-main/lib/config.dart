class ServerConfig {
  static const String ip = '192.168.4.135'; // local server IP
  static const int port = 5000;

  static String get baseUrl => 'http://$ip:6000';
  static String get apiBaseUrl => 'http://$ip:$port';
  // // Optional: specific endpoints
  // static String get imageBase => '$baseUrl/images';
  // static String get userEndpoint => '$baseUrl/api/users';
}
