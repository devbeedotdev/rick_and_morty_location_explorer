import '../../core/errors/failures.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';
import '../datasources/location_remote_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource _remote;
  final LocationLocalDataSource _local;

  LocationRepositoryImpl({required LocationRemoteDataSource remote, required LocationLocalDataSource local})
      : _remote = remote, _local = local;

  @override
  Future<(PaginatedLocations?, AppFailure?)> getLocations({required int page, String? name, String? type}) async {
    final cached = await _local.getCachedLocations(page: page, name: name, type: type);
    if (cached != null) {
      _refreshInBackground(page: page, name: name, type: type);
      return (cached.toEntity(), null);
    }
    return _fetchFromNetwork(page: page, name: name, type: type);
  }

  Future<(PaginatedLocations?, AppFailure?)> _fetchFromNetwork({required int page, String? name, String? type}) async {
    try {
      final data = await _remote.getLocations(page: page, name: name, type: type);
      await _local.cacheLocations(page: page, name: name, type: type, data: data);
      await _local.saveLastUpdated(DateTime.now());
      return (data.toEntity(), null);
    } on AppFailure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }

  void _refreshInBackground({required int page, String? name, String? type}) {
    _fetchFromNetwork(page: page, name: name, type: type);
  }

  @override
  Future<(Location?, AppFailure?)> getLocation(int id) async {
    try {
      return (_remote.getLocation(id).then((m) => m.toEntity()), null).$1.then((v) => (v, null));
    } on AppFailure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }

  @override
  Future<(Resident?, AppFailure?)> getResident(String url) async {
    try {
      final model = await _remote.getResident(url);
      return (model.toEntity(), null);
    } on AppFailure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, UnknownFailure(e.toString()));
    }
  }

  @override
  Future<DateTime?> getLastUpdated() => _local.getLastUpdated();
}
