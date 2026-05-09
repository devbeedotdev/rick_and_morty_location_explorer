part of 'location_detail_bloc.dart';

abstract class LocationDetailEvent extends Equatable {
  const LocationDetailEvent();
  @override
  List<Object?> get props => [];
}

class LocationDetailFetchRequested extends LocationDetailEvent {
  final int locationId;
  const LocationDetailFetchRequested(this.locationId);
  @override
  List<Object?> get props => [locationId];
}
