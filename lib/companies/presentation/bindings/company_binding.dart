import 'package:get/get.dart';
import 'package:tractian_mobile/companies/presentation/controllers/company_controller.dart';

class CompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CompanyController());
  }
}
