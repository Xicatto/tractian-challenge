import 'package:get/get.dart';
import 'package:tractian_mobile/assets/data/datasources/remote_location_datasource.dart';
import 'package:tractian_mobile/assets/data/repositories/location_repository_impl.dart';
import 'package:tractian_mobile/assets/domain/usecases/get_locations_usecase.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RemoteLocationDatasource());
    Get.put(LocationRepositoryImpl(Get.find<RemoteLocationDatasource>()));
    Get.put(GetLocationsUseCase(Get.find<LocationRepositoryImpl>()));
  }
}
