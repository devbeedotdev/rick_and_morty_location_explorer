import '../../domain/entities/location.dart';

class InfoModel {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const InfoModel({required this.count, required this.pages, this.next, this.prev});

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
        count: (json['count'] as num).toInt(),
        pages: (json['pages'] as num).toInt(),
        next: json['next'] as String?,
        prev: json['prev'] as String?,
      );
}

class LocationModel {
  final int id;
  final String name;
  final String type;
  final String dimension;
  final List<String> residents;
  final String url;
  final String created;

  const LocationModel({
    required this.id, required this.name, required this.type,
    required this.dimension, required this.residents,
    required this.url, required this.created,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String? ?? '',
        type: json['type'] as String? ?? '',
        dimension: json['dimension'] as String? ?? '',
        residents: (json['residents'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
        url: json['url'] as String? ?? '',
        created: json['created'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id, 'name': name, 'type': type, 'dimension': dimension,
        'residents': residents, 'url': url, 'created': created,
      };

  Location toEntity() => Location(
        id: id, name: name, type: type, dimension: dimension,
        residentUrls: residents, url: url, created: created,
      );
}

class LocationListResponse {
  final InfoModel info;
  final List<LocationModel> results;

  const LocationListResponse({required this.info, required this.results});

  factory LocationListResponse.fromJson(Map<String, dynamic> json) => LocationListResponse(
        info: InfoModel.fromJson(json['info'] as Map<String, dynamic>),
        results: (json['results'] as List<dynamic>)
            .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  PaginatedLocations toEntity() => PaginatedLocations(
        locations: results.map((m) => m.toEntity()).toList(),
        totalPages: info.pages,
        totalCount: info.count,
      );
}

class ResidentModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;

  const ResidentModel({
    required this.id, required this.name, required this.status,
    required this.species, required this.image,
  });

  factory ResidentModel.fromJson(Map<String, dynamic> json) => ResidentModel(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String? ?? '',
        status: json['status'] as String? ?? '',
        species: json['species'] as String? ?? '',
        image: json['image'] as String? ?? '',
      );

  Resident toEntity() => Resident(id: id, name: name, status: status, species: species, image: image);
}
