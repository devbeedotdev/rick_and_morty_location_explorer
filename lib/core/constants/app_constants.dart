class AppConstants {
  AppConstants._();
  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const String locationEndpoint = '/location';
  static const int pageSize = 20;
  static const String cacheKeyLocations = 'cached_locations_page_';
  static const String cacheKeyLastUpdated = 'last_updated_timestamp';
  static const Duration cacheExpiry = Duration(hours: 1);
  static const int residentGridCrossAxisCount = 3;
  static const int maxResidentsShown = 6;
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const double desktopBreakpoint = 900;
  static const double tabletBreakpoint = 600;
  static const int listColumnsDesktop = 2;
  static const double maxContentWidth = 1200;
}

class AppStrings {
  AppStrings._();
  static const String appName = 'Rick & Morty';
}
