import 'package:flutter/material.dart';

class StatTile extends StatelessWidget {
  final String label;
  final String value;

  const StatTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
