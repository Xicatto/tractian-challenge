import 'package:tractian_mobile/assets/domain/entities/asset_entity.dart';
import 'package:tractian_mobile/assets/domain/repositories/asset_repository.dart';

class GetAssetsUseCase {
  final AssetRepository _repository;

  GetAssetsUseCase(this._repository);

  Future<List<AssetEntity>> execute(String companyId) {
    return _repository.getAssets(companyId);
  }
}
