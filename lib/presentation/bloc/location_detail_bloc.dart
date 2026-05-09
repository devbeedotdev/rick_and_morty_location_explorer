import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/location_usecases.dart';

part 'location_detail_event.dart';
part 'location_detail_state.dart';

class LocationDetailBloc extends Bloc<LocationDetailEvent, LocationDetailState> {
  final GetLocationUseCase _getLocation;
  final GetResidentUseCase _getResident;

  LocationDetailBloc({
    required GetLocationUseCase getLocation,
    required GetResidentUseCase getResident,
  })  : _getLocation = getLocation,
        _getResident = getResident,
        super(const LocationDetailState()) {
    on<LocationDetailFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(LocationDetailFetchRequested event, Emitter<LocationDetailState> emit) async {
    emit(state.copyWith(status: LocationDetailStatus.loading));

    final (location, failure) = await _getLocation(event.locationId);
    if (failure != null) {
      emit(state.copyWith(status: LocationDetailStatus.failure, errorMessage: failure.message));
      return;
    }

    emit(state.copyWith(status: LocationDetailStatus.success, location: location, residents: []));

    if (location != null && location.residentUrls.isNotEmpty) {
      final urls = location.residentUrls.take(AppConstants.maxResidentsShown).toList();
      final results = await Future.wait(urls.map((url) => _getResident(url)));
      final residents = results.where((r) => r.$1 != null).map((r) => r.$1!).toList();
      emit(state.copyWith(residents: residents));
    }
  }
}
