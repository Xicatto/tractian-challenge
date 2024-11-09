import 'package:get/get.dart';

class CompanyProvider extends GetConnect {
  Future<Response> fetchCompanies() =>
      get('https://fake-api.tractian.com/companies');
}
