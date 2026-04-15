import '../models/post.dart';

final List<Post> mockPosts = [
  Post(
    id: '001',
    itemName: 'Wallet',
    type: 'Lost',
    owner: 'John Doe',
    reportedBy: 'John Doe',
    status: 'Pending',
    security: 'Yes',
    date: 'Mar 23, 2026',
  ),
  Post(
    id: '002',
    itemName: 'Phone',
    type: 'Found',
    owner: 'Gumsiram',
    reportedBy: 'Alex B',
    status: 'Resolved',
    security: 'Yes',
    date: 'Mar 23, 2026',
  ),
  Post(
    id: '003',
    itemName: 'Backpack',
    type: 'Lost',
    owner: 'Francis B',
    reportedBy: 'Francis B',
    status: 'In Progress',
    security: 'Yes',
    date: 'Mar 23, 2026',
  ),
  Post(
    id: '004',
    itemName: 'Keys',
    type: 'Found',
    owner: 'Krish P',
    reportedBy: 'Krish P',
    status: 'Done',
    security: 'Yes',
    date: 'Mar 23, 2026',
  ),
];