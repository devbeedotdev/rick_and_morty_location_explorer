class AppConstants {
  AppConstants._();
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const String locationEndpoint = '/location';
  static const int maxResidentsShown = 6;
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

class AppStrings {
  AppStrings._();
  static const String appName = 'Rick & Morty';
}
