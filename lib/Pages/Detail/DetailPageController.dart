// lib\Pages\Detail\DetailPageController.dart
import 'package:flutter/foundation.dart';
import '../../Models/JournalEntry.dart';

class DetailPageController extends ChangeNotifier {
  JournalEntry entry;
  DetailPageController(this.entry);

  void updateEntry(JournalEntry updated) {
    entry = updated;
    notifyListeners();
  }
}