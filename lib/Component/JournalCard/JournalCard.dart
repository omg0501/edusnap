import 'package:flutter/material.dart';
import '../../Models/JournalEntry.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;

  const JournalCard({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(
          entry.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(entry.note),
      ),
    );
  }
}