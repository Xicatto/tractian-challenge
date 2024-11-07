import 'package:get/get.dart';
import 'package:tractian_mobile/companies/data/datasources/remote_company_datasource.dart';
import 'package:tractian_mobile/companies/data/repositories/company_repository_impl.dart';
import 'package:tractian_mobile/companies/domain/usecases/get_companies_usecase.dart';
import 'package:tractian_mobile/companies/presentation/controllers/company_controller.dart';

class CompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RemoteCompanyDataSource());
    Get.lazyPut(
        () => CompanyRepositoryImpl(Get.find<RemoteCompanyDataSource>()));
    Get.lazyPut(() => GetCompaniesUseCase(Get.find<CompanyRepositoryImpl>()));
    Get.put(CompanyController(Get.find<GetCompaniesUseCase>()));
  }
}
