import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;

  const AppHeader({
    super.key,
    required this.title,
  });
//this widget its for the header for the circle avatar
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 20),
            CircleAvatar(child: Icon(Icons.person)),
          ],
        ),
      ],
    );
  }
}