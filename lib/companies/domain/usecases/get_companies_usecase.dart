
import 'package:tractian_mobile/companies/domain/repositories/company_repository.dart';

import '../entities/company_entity.dart';

class GetCompaniesUseCase {
  final CompanyRepository _repository;

  GetCompaniesUseCase(this._repository);

  Future<List<CompanyEntity>> execute() {
    return _repository.getCompanies();
  }
}