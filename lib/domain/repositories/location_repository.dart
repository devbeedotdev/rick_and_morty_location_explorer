import '../entities/location.dart';
import '../../core/errors/failures.dart';

abstract class LocationRepository {
  Future<(PaginatedLocations?, AppFailure?)> getLocations({
    required int page,
    String? name,
    String? type,
  });
  Future<(Location?, AppFailure?)> getLocation(int id);
  Future<(Resident?, AppFailure?)> getResident(String url);
  Future<DateTime?> getLastUpdated();
}
