import 'package:dio/dio.dart';
import 'package:tractian_mobile/companies/domain/entities/company_entity.dart';

final dio = Dio();

class RemoteCompanyDataSource {
  Future<List<CompanyEntity>> fetchCompanies() async {
    final response = await dio.get('https://fake-api.tractian.com/companies');
    final companies = (response.data as List).map((company) {
      return CompanyEntity.fromJson(company);
    }).toList();
    return companies;
  }
}
