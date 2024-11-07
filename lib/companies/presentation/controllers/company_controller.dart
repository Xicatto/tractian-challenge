import 'package:get/get.dart';
import 'package:tractian_mobile/companies/domain/entities/company_entity.dart';
import 'package:tractian_mobile/companies/domain/usecases/get_companies_usecase.dart';

class CompanyController extends GetxController
    with StateMixin<List<CompanyEntity>> {
  final GetCompaniesUseCase getCompaniesUseCase;

  CompanyController(this.getCompaniesUseCase);

  @override
  void onInit() {
    getCompaniesUseCase.execute().then((result) async {
      final companies = result;
      change(companies, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
    super.onInit();
  }
}
