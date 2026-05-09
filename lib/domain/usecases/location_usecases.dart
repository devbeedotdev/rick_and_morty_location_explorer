import '../entities/location.dart';
import '../repositories/location_repository.dart';
import '../../core/errors/failures.dart';

class GetLocationsUseCase {
  final LocationRepository _repository;
  const GetLocationsUseCase(this._repository);
  Future<(PaginatedLocations?, AppFailure?)> call({
    required int page,
    String? name,
    String? type,
  }) => _repository.getLocations(page: page, name: name, type: type);
}

class GetLocationUseCase {
  final LocationRepository _repository;
  const GetLocationUseCase(this._repository);
  Future<(Location?, AppFailure?)> call(int id) => _repository.getLocation(id);
}

class GetResidentUseCase {
  final LocationRepository _repository;
  const GetResidentUseCase(this._repository);
  Future<(Resident?, AppFailure?)> call(String url) => _repository.getResident(url);
}

class GetLastUpdatedUseCase {
  final LocationRepository _repository;
  const GetLastUpdatedUseCase(this._repository);
  Future<DateTime?> call() => _repository.getLastUpdated();
}
