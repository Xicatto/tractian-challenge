import 'package:tractian_mobile/assets/domain/entities/asset_entity.dart';

abstract class AssetRepository {
  Future<List<AssetEntity>> getAssets(String companyId);
}
