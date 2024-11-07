import 'package:dio/dio.dart';
import 'package:tractian_mobile/assets/domain/entities/location_entity.dart';

final dio = Dio();

class RemoteLocationDatasource {
  Future<List<LocationEntity>> fetchLocations(String companyId) async {
    final response = await dio
        .get('https://fake-api.tractian.com/companies/$companyId/locations');
    final locations = (response.data as List).map((location) {
      return LocationEntity.fromJson(location);
    }).toList();
    return locations;
  }
}
