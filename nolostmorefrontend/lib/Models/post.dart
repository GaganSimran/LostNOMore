class Post {
  final String id;
  final String itemName;
  final String type;
  final String owner;
  final String reportedBy;
  final String status;
  final String security;
  final String date;

  const Post({
    required this.id,
    required this.itemName,
    required this.type,
    required this.owner,
    required this.reportedBy,
    required this.status,
    required this.security,
    required this.date,
  });
}