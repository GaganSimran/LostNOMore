import 'package:flutter/material.dart';


//i started first coding the widgets inside the login screens and i notice on how
//extensive the coding was and i could reuse most of my widgets
//so i did darts of only idgets

class SummaryCard extends StatelessWidget {
  final String label;
  final String count;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
//this is for stattisitics moste likely need to change t
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12)),
                  Text(count,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}