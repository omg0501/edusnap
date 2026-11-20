// lib\Pages\HomePage\HomePageController.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/JournalEntry.dart';

class HomePageController extends ChangeNotifier {
  static const String storageKey = 'journal_entries_v1';
  bool isLoading = false;
  final List<JournalEntry> entries = [];

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(storageKey);

      if (raw == null) {
        entries
          ..clear()
          ..addAll([
            JournalEntry(
              title: 'Plant cells',
              note: 'The cell wall keeps the shape. Chloroplasts handle photosynthesis.',
              createdAt: DateTime(2026, 10, 1),
            ),
            JournalEntry(
              title: 'Fractions',
              note: 'A fraction is part of a whole. One half is written as 1/2.',
              createdAt: DateTime(2026, 10, 8),
            ),
            JournalEntry(
              title: 'Water cycle',
              note: 'Water evaporates, condenses into clouds, then falls as rain.',
              createdAt: DateTime(2026, 10, 15),
            ),
          ]);
        await save();
      } else {
        final decoded = (jsonDecode(raw) as List<dynamic>)
            .map((item) => JournalEntry.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        entries
          ..clear()
          ..addAll(decoded);
      }
    } catch (_) {}

    isLoading = false;
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(storageKey, raw);
  }

  Future<void> insertAtTop(JournalEntry entry) async {
    entries.insert(0, entry);
    notifyListeners();
    await save();
  }

  Future<void> updateEntry(int index, JournalEntry updated) async {
    if (index >= 0 && index < entries.length) {
      entries[index] = updated;
      notifyListeners();
      await save();
    }
  }

  Future<void> remove(JournalEntry entry) async {
    if (entry.imagePath != null) {
      final file = File(entry.imagePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    entries.remove(entry);
    notifyListeners();
    await save();
  }
}