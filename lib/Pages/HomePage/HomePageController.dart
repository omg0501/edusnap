import 'package:flutter/foundation.dart';
import '../../Models/JournalEntry.dart';

class HomePageController extends ChangeNotifier {
  final List<JournalEntry> entries = [
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
  ];

  void insertAtTop(JournalEntry entry) {
    entries.insert(0, entry);
    notifyListeners();
  }

  void updateEntry(int index, JournalEntry updated) {
    if (index >= 0 && index < entries.length) {
      entries[index] = updated;
      notifyListeners();
    }
  }

  void remove(JournalEntry entry) {
    entries.remove(entry);
    notifyListeners();
  }
}