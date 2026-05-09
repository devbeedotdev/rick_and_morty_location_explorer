part of 'location_detail_bloc.dart';

enum LocationDetailStatus { initial, loading, success, failure }

class LocationDetailState extends Equatable {
  final LocationDetailStatus status;
  final Location? location;
  final List<Resident> residents;
  final String? errorMessage;

  const LocationDetailState({
    this.status = LocationDetailStatus.initial,
    this.location,
    this.residents = const [],
    this.errorMessage,
  });

  LocationDetailState copyWith({
    LocationDetailStatus? status,
    Location? location,
    List<Resident>? residents,
    String? errorMessage,
  }) => LocationDetailState(
    status: status ?? this.status,
    location: location ?? this.location,
    residents: residents ?? this.residents,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, location, residents, errorMessage];
}
