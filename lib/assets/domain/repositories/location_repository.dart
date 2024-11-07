import 'package:tractian_mobile/assets/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Future<List<LocationEntity>> fetchLocations(String companyId);
}
