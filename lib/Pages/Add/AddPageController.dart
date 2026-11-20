import 'package:flutter/foundation.dart';
import '../../Models/JournalEntry.dart';

class AddPageController extends ChangeNotifier {
  JournalEntry? createOrUpdateEntry({
    required String rawTitle,
    required String rawNote,
    DateTime? existingCreatedAt,
  }) {
    final trimmed = rawTitle.trim();
    if (trimmed.isEmpty) return null;

    return JournalEntry(
      title: trimmed,
      note: rawNote.trim(),
      createdAt: existingCreatedAt ?? DateTime.now(),
    );
  }
}