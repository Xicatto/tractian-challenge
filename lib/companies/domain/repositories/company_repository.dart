import '../entities/company_entity.dart';

abstract class CompanyRepository {
  Future<List<CompanyEntity>> getCompanies();
}
