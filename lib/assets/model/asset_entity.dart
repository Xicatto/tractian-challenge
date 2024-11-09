sealed class SensorStatus {}

enum Sensor implements SensorStatus {
  energy,
  vibration,
}

enum Status implements SensorStatus {
  operating,
  alert,
}

class Asset {
  final String? gatewayId;
  final String id;
  final String? locationId;
  final String name;
  final String? parentId;
  final String? sensorId;
  final String? sensorType;
  final String? status;

  Asset({
    this.gatewayId,
    required this.id,
    this.locationId,
    required this.name,
    this.parentId,
    this.sensorId,
    this.sensorType,
    this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      gatewayId: json['gatewayId'],
      id: json['id'],
      locationId: json['locationId'],
      name: json['name'],
      parentId: json['parentId'],
      sensorId: json['sensorId'],
      sensorType: json['sensorType'],
      status: json['status'],
    );
  }
}
