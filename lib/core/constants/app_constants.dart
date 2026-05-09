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
  static const String locationsTitle = 'Locations';
  static const String searchHint = 'Search locations…';
  static const String filterByType = 'Filter by type';
  static const String allTypes = 'All types';
  static const String lastUpdated = 'Last updated';
  static const String never = 'Never';
  static const String retry = 'Retry';
  static const String noResults = 'No locations found';
  static const String noResultsSubtitle = 'Try adjusting your search or filter.';
  static const String errorGeneric = 'Something went wrong';
  static const String errorNetwork = 'No internet connection';
  static const String errorNotFound = 'Resource not found';
  static const String residents = 'Residents';
  static const String dimension = 'Dimension';
  static const String type = 'Type';
  static const String name = 'Name';
  static const String status = 'Status';
  static const String unknown = 'Unknown';
  static const String loadingMore = 'Loading more…';
}
