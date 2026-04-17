class Item {
  final int id;
  final int userId;
  final String itemCode;
  final String title;
  final String description;
  final String category;
  final String location;
  final String imageUrl;
  final String type;
  final String status;
  final bool handedToSecurity;
  final bool isApproved;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item({
    required this.id,
    required this.userId,
    required this.itemCode,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.imageUrl,
    required this.type,
    required this.status,
    required this.handedToSecurity,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      userId: json['user_id'],
      itemCode: json['item_code'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['image_url'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      handedToSecurity: json['handed_to_security'] ?? false,
      isApproved: json['is_approved'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}