import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../models/location_model.dart';

abstract class LocationLocalDataSource {
  Future<LocationListResponse?> getCachedLocations({required int page, String? name, String? type});
  Future<void> cacheLocations({required int page, String? name, String? type, required LocationListResponse data});
  Future<DateTime?> getLastUpdated();
  Future<void> saveLastUpdated(DateTime dt);
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final SharedPreferences _prefs;
  LocationLocalDataSourceImpl(this._prefs);

  String _buildKey(int page, String? name, String? type) =>
      '${AppConstants.cacheKeyLocations}${page}_${name ?? ''}_${type ?? ''}';

  @override
  Future<LocationListResponse?> getCachedLocations({required int page, String? name, String? type}) async {
    final raw = _prefs.getString(_buildKey(page, name, type));
    if (raw == null) return null;
    try {
      final map = json.decode(raw) as Map<String, dynamic>;
      final cachedAt = DateTime.tryParse(map['_cachedAt'] as String? ?? '');
      if (cachedAt == null || DateTime.now().difference(cachedAt) > AppConstants.cacheExpiry) return null;
      return LocationListResponse.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheLocations({required int page, String? name, String? type, required LocationListResponse data}) async {
    final map = {
      'info': {'count': data.info.count, 'pages': data.info.pages, 'next': data.info.next, 'prev': data.info.prev},
      'results': data.results.map((r) => r.toJson()).toList(),
      '_cachedAt': DateTime.now().toIso8601String(),
    };
    await _prefs.setString(_buildKey(page, name, type), json.encode(map));
  }

  @override
  Future<DateTime?> getLastUpdated() async {
    final raw = _prefs.getString(AppConstants.cacheKeyLastUpdated);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  @override
  Future<void> saveLastUpdated(DateTime dt) async {
    await _prefs.setString(AppConstants.cacheKeyLastUpdated, dt.toIso8601String());
  }
}
