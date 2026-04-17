class Post {
  final String id;
  final String itemName;
  final String type;
  final String owner;
  final String reportedBy;
  final String status;
  final String date;

  Post({
    required this.id,
    required this.itemName,
    required this.type,
    required this.owner,
    required this.reportedBy,
    required this.status,
    required this.date,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      itemName: json['item_name'] ?? '',
      type: json['type'] ?? '',
      owner: json['owner'] ?? '',
      reportedBy: json['reported_by'] ?? '',
      status: _capitalize(json['status'] ?? ''),
      date: (json['created_at'] ?? '').toString().split('T').first,
    );
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}