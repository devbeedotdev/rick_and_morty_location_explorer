import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final int id;
  final String name;
  final String type;
  final String dimension;
  final List<String> residentUrls;
  final String url;
  final String created;

  const Location({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residentUrls,
    required this.url,
    required this.created,
  });

  @override
  List<Object?> get props => [id];
}

class Resident extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;

  const Resident({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
  });

  @override
  List<Object?> get props => [id];
}

class PaginatedLocations extends Equatable {
  final List<Location> locations;
  final int totalPages;
  final int totalCount;

  const PaginatedLocations({
    required this.locations,
    required this.totalPages,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [locations, totalPages, totalCount];
}
