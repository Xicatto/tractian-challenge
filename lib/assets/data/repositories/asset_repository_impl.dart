import 'package:tractian_mobile/assets/data/datasources/remote_asset_datasource.dart';
import 'package:tractian_mobile/assets/domain/entities/asset_entity.dart';
import 'package:tractian_mobile/assets/domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  final RemoteAssetDataSource remoteAssetDataSource;

  AssetRepositoryImpl(this.remoteAssetDataSource);

  @override
  Future<List<AssetEntity>> getAssets(String companyId) {
    return remoteAssetDataSource.fetchAssets(companyId);
  }
}
