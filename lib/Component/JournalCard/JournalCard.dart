// lib\Component\JournalCard\JournalCard.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../Models/JournalEntry.dart';
import '../../Utils/DateFormatter.dart';
import 'JournalCardController.dart';

class JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;

  JournalCard({super.key, required this.entry, required this.onTap});

  final JournalCardController _controller = JournalCardController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasImage = _controller.hasValidImage(entry.imagePath);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: hasImage
              ? Image.file(
                  File(entry.imagePath!),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 56,
                  height: 56,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
        ),
        title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.note.isNotEmpty)
              Text(entry.note, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              l10n.createdOn(DateFormatter.format(entry.createdAt)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}