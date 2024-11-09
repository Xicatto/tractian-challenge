import 'package:get/get.dart';

class LocationProvider extends GetConnect {
  Future<Response> fetchLocations(String companyId) =>
      get('https://fake-api.tractian.com/companies/$companyId/locations');
}
