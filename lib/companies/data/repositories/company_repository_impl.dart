
import 'package:tractian_mobile/companies/data/datasources/remote_company_datasource.dart';
import 'package:tractian_mobile/companies/domain/repositories/company_repository.dart';

import '../../domain/entities/company_entity.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final RemoteCompanyDataSource remoteCompanyDataSource;

  CompanyRepositoryImpl(this.remoteCompanyDataSource);

  @override
  Future<List<CompanyEntity>> getCompanies() {
    return remoteCompanyDataSource.fetchCompanies();
  }
}
