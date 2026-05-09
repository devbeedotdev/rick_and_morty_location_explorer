import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/location.dart';
import '../../domain/usecases/location_usecases.dart';

part 'location_list_event.dart';
part 'location_list_state.dart';

class LocationListBloc extends Bloc<LocationListEvent, LocationListState> {
  final GetLocationsUseCase _getLocations;
  final GetLastUpdatedUseCase _getLastUpdated;

  LocationListBloc({
    required GetLocationsUseCase getLocations,
    required GetLastUpdatedUseCase getLastUpdated,
  })  : _getLocations = getLocations,
        _getLastUpdated = getLastUpdated,
        super(const LocationListState()) {
    on<LocationListFetchRequested>(_onFetchRequested);
    on<LocationListNextPageRequested>(_onNextPageRequested);
    on<LocationListFilterChanged>(_onFilterChanged);
    on<LocationListRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onFetchRequested(LocationListFetchRequested event, Emitter<LocationListState> emit) async {
    emit(state.copyWith(status: LocationListStatus.loading, clearError: true));
    await _loadPage(1, emit, replace: true);
  }

  Future<void> _onNextPageRequested(LocationListNextPageRequested event, Emitter<LocationListState> emit) async {
    if (state.hasReachedMax || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true));
    await _loadPage(state.currentPage + 1, emit, replace: false);
  }

  Future<void> _onFilterChanged(LocationListFilterChanged event, Emitter<LocationListState> emit) async {
    emit(state.copyWith(
      status: LocationListStatus.loading,
      nameFilter: event.name ?? state.nameFilter,
      typeFilter: event.type ?? state.typeFilter,
      locations: [], currentPage: 0, hasReachedMax: false, clearError: true,
    ));
    await _loadPage(1, emit, replace: true);
  }

  Future<void> _onRefreshRequested(LocationListRefreshRequested event, Emitter<LocationListState> emit) async {
    emit(state.copyWith(locations: [], currentPage: 0, hasReachedMax: false,
        status: LocationListStatus.loading, clearError: true));
    await _loadPage(1, emit, replace: true);
  }

  Future<void> _loadPage(int page, Emitter<LocationListState> emit, {required bool replace}) async {
    final lastUpdated = await _getLastUpdated();
    final (result, failure) = await _getLocations(page: page, name: state.nameFilter, type: state.typeFilter);

    emit(state.copyWith(isLoadingMore: false));

    if (failure != null) {
      emit(state.copyWith(status: LocationListStatus.failure, errorMessage: failure.message, lastUpdated: lastUpdated));
      return;
    }
    if (result == null || result.locations.isEmpty) {
      emit(state.copyWith(status: replace ? LocationListStatus.empty : state.status, lastUpdated: lastUpdated));
      return;
    }
    final updated = replace ? result.locations : [...state.locations, ...result.locations];
    emit(state.copyWith(
      status: LocationListStatus.success,
      locations: updated,
      currentPage: page,
      totalPages: result.totalPages,
      hasReachedMax: page >= result.totalPages,
      lastUpdated: lastUpdated,
    ));
  }
}
