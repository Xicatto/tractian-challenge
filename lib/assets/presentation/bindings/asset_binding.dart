import 'package:get/get.dart';
import 'package:tractian_mobile/assets/presentation/controllers/asset_controller.dart';

class AssetBinding extends Bindings {
  @override
  void dependencies() {
    Get.create(() => AssetController());
  }
}
