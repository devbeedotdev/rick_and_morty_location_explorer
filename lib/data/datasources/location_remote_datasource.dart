import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/network_client.dart';
import '../models/location_model.dart';

abstract class LocationRemoteDataSource {
  Future<LocationListResponse> getLocations({required int page, String? name, String? type});
  Future<LocationModel> getLocation(int id);
  Future<ResidentModel> getResident(String url);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Dio _dio;
  LocationRemoteDataSourceImpl(NetworkClient client) : _dio = client.dio;

  @override
  Future<LocationListResponse> getLocations({required int page, String? name, String? type}) async {
    try {
      final params = <String, dynamic>{'page': page};
      if (name != null && name.isNotEmpty) params['name'] = name;
      if (type != null && type.isNotEmpty) params['type'] = type;
      final response = await _dio.get(AppConstants.locationEndpoint, queryParameters: params);
      return LocationListResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<LocationModel> getLocation(int id) async {
    try {
      final response = await _dio.get('${AppConstants.locationEndpoint}/$id');
      return LocationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<ResidentModel> getResident(String url) async {
    try {
      final response = await _dio.get(url);
      return ResidentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
