// lib\Component\JournalCard\JournalCardController.dart
import 'dart:io';

class JournalCardController {
  bool hasValidImage(String? path) {
    if (path == null || path.isEmpty) return false;
    return File(path).existsSync();
  }
}