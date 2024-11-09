import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/assets/presentation/bindings/asset_binding.dart';
import 'package:tractian_mobile/assets/presentation/pages/asset_page.dart';
import 'package:tractian_mobile/companies/presentation/bindings/company_binding.dart';
import 'package:tractian_mobile/companies/presentation/pages/company_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      title: 'Tractian Challenge',
      initialRoute: '/companies',
      getPages: [
        GetPage(
          name: '/companies',
          page: () => CompanyPage(),
          binding: CompanyBinding(),
        ),
        GetPage(
          name: '/companies/:companyId/assets',
          page: () => AssetPage(),
          binding: AssetBinding(),
        ),
      ],
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Color(0xFF17192D),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
    );
  }
}
