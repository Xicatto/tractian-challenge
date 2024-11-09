import 'package:get/get.dart';
import 'package:tractian_mobile/companies/model/company.dart';
import 'package:tractian_mobile/companies/provider/company_provider.dart';

class CompanyController extends GetxController with StateMixin<List<Company>> {
  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
  }

  fetchCompanies() async {
    try {
      final response = await CompanyProvider().fetchCompanies();
      final companies = (response.body as List).map((company) {
        return Company.fromJson(company);
      }).toList();
      change(companies, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
