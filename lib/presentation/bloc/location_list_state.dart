part of 'location_list_bloc.dart';

enum LocationListStatus { initial, loading, success, empty, failure }

class LocationListState extends Equatable {
  final LocationListStatus status;
  final List<Location> locations;
  final int currentPage;
  final int totalPages;
  final bool hasReachedMax;
  final String? errorMessage;
  final String? nameFilter;
  final String? typeFilter;
  final DateTime? lastUpdated;
  final bool isLoadingMore;

  const LocationListState({
    this.status = LocationListStatus.initial,
    this.locations = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.hasReachedMax = false,
    this.errorMessage,
    this.nameFilter,
    this.typeFilter,
    this.lastUpdated,
    this.isLoadingMore = false,
  });

  LocationListState copyWith({
    LocationListStatus? status,
    List<Location>? locations,
    int? currentPage,
    int? totalPages,
    bool? hasReachedMax,
    String? errorMessage,
    String? nameFilter,
    String? typeFilter,
    DateTime? lastUpdated,
    bool? isLoadingMore,
    bool clearError = false,
    bool clearFilters = false,
  }) => LocationListState(
    status: status ?? this.status,
    locations: locations ?? this.locations,
    currentPage: currentPage ?? this.currentPage,
    totalPages: totalPages ?? this.totalPages,
    hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    nameFilter: clearFilters ? null : (nameFilter ?? this.nameFilter),
    typeFilter: clearFilters ? null : (typeFilter ?? this.typeFilter),
    lastUpdated: lastUpdated ?? this.lastUpdated,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );

  @override
  List<Object?> get props => [
    status, locations, currentPage, totalPages, hasReachedMax,
    errorMessage, nameFilter, typeFilter, lastUpdated, isLoadingMore,
  ];
}
