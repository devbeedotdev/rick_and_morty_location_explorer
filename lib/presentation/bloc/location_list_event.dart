part of 'location_list_bloc.dart';

abstract class LocationListEvent extends Equatable {
  const LocationListEvent();
  @override
  List<Object?> get props => [];
}

class LocationListFetchRequested extends LocationListEvent {
  const LocationListFetchRequested();
}

class LocationListNextPageRequested extends LocationListEvent {
  const LocationListNextPageRequested();
}

class LocationListFilterChanged extends LocationListEvent {
  final String? name;
  final String? type;
  const LocationListFilterChanged({this.name, this.type});
  @override
  List<Object?> get props => [name, type];
}

class LocationListRefreshRequested extends LocationListEvent {
  const LocationListRefreshRequested();
}
