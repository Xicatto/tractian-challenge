import 'package:tractian_mobile/assets/data/datasources/remote_location_datasource.dart';
import 'package:tractian_mobile/assets/domain/entities/location_entity.dart';
import 'package:tractian_mobile/assets/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final RemoteLocationDatasource remoteLocationDatasource;

  LocationRepositoryImpl(this.remoteLocationDatasource);

  @override
  Future<List<LocationEntity>> fetchLocations(String companyId) {
    return remoteLocationDatasource.fetchLocations(companyId);
  }
}
