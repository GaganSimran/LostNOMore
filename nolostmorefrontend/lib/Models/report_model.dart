class ReportModel {
  final int id;
  final String name;

  ReportModel({
    required this.id,
    required this.name,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final rawName = json['name'];

    return ReportModel(
      id: json['id'] ?? 0,
      name: rawName == null ? '' : rawName.toString(),
    );
  }
}