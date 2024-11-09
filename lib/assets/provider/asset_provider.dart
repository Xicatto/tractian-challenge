import 'package:get/get.dart';

class AssetProvider extends GetConnect {
  Future<Response> fetchAssets(String companyId) =>
      get('https://fake-api.tractian.com/companies/$companyId/assets');
}
