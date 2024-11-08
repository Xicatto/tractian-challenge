import 'package:get/get.dart';
import 'package:tractian_mobile/assets/data/datasources/remote_asset_datasource.dart';
import 'package:tractian_mobile/assets/data/repositories/asset_repository_impl.dart';
import 'package:tractian_mobile/assets/domain/usecases/get_assets_usecase.dart';
import 'package:tractian_mobile/assets/domain/usecases/get_locations_usecase.dart';
import 'package:tractian_mobile/assets/presentation/controllers/asset_controller.dart';

class AssetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RemoteAssetDataSource());
    Get.put(
      AssetRepositoryImpl(Get.find<RemoteAssetDataSource>()),
    );
    Get.put(GetAssetsUseCase(Get.find<AssetRepositoryImpl>()));
    Get.put(AssetController(
        Get.find<GetAssetsUseCase>(), Get.find<GetLocationsUseCase>()));
  }
}
