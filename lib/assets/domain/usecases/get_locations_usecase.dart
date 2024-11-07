import 'package:tractian_mobile/assets/domain/entities/location_entity.dart';
import 'package:tractian_mobile/assets/domain/repositories/location_repository.dart';

class GetLocationsUseCase {
  final LocationRepository _repository;

  GetLocationsUseCase(this._repository);

  Future<List<LocationEntity>> execute(String companyId) {
    return _repository.fetchLocations(companyId);
  }
}
