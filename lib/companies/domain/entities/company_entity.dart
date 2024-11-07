class CompanyEntity {
  final String id;
  final String name;

  CompanyEntity({required this.id, required this.name});

  factory CompanyEntity.fromJson(Map<String, dynamic> json) =>
      CompanyEntity(id: json['id'], name: json['name']);
}
