// lib\Pages\Settings\SettingsPageController.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/JournalEntry.dart';
import '../HomePage/HomePageController.dart';

class SettingsPageController extends ChangeNotifier {
  double storageSizeKb = 0.0;

  Future<void> calculateStorageUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(HomePageController.storageKey);

    if (raw == null || raw.isEmpty) {
      storageSizeKb = 0.0;
      notifyListeners();
      return;
    }

    int totalBytes = utf8.encode(raw).length;

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      for (final item in decoded) {
        final entry = JournalEntry.fromJson(Map<String, dynamic>.from(item as Map));
        if (entry.imagePath != null) {
          final file = File(entry.imagePath!);
          if (await file.exists()) {
            totalBytes += await file.length();
          }
        }
      }
    } catch (_) {}

    storageSizeKb = totalBytes / 1024.0;
    notifyListeners();
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(HomePageController.storageKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as List<dynamic>;
        for (final item in decoded) {
          final entry = JournalEntry.fromJson(Map<String, dynamic>.from(item as Map));
          if (entry.imagePath != null) {
            final file = File(entry.imagePath!);
            if (await file.exists()) {
              await file.delete();
            }
          }
        }
      } catch (_) {}
    }

    await prefs.setString(HomePageController.storageKey, '[]');
    storageSizeKb = 0.0;
    notifyListeners();
  }
}