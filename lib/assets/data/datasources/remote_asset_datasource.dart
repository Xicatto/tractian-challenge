import 'package:dio/dio.dart';
import 'package:tractian_mobile/assets/domain/entities/asset_entity.dart';

final dio = Dio();

class RemoteAssetDataSource {
  Future<List<AssetEntity>> fetchAssets(String companyId) async {
    final response = await dio
        .get('https://fake-api.tractian.com/companies/$companyId/assets');
    final assets = (response.data as List).map((company) {
      return AssetEntity.fromJson(company);
    }).toList();
    return assets;
  }
}
