import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/companies/presentation/controllers/company_controller.dart';

class CompanyPage extends GetView<CompanyController> {
  const CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/logo.png',
            scale: 2.0,
          ),
        ),
      ),
      body: controller.obx(
        (companies) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Companies',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: companies!.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 16,
                ),
                itemBuilder: (context, index) => ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.black26),
                  ),
                  title: Text(companies[index].name),
                  onTap: () {
                    Get.toNamed('/companies/${companies[index].id}/assets');
                  },
                  leading: Image.asset(
                    'assets/menu_icon.png',
                    scale: 2,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        onLoading: Center(
          child: CircularProgressIndicator(),
        ),
        onError: (error) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
