// lib\Pages\Add\AddPageController.dart
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Models/JournalEntry.dart';

enum PhotoPermissionResult { granted, denied }

class AddPageController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  String? imagePath;

  AddPageController({String? initialImagePath}) : imagePath = initialImagePath;

  Future<PhotoPermissionResult> pickImage(ImageSource source) async {
    final permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;

    var status = await permission.status;
    if (!status.isGranted && !status.isLimited) {
      status = await permission.request();
    }

    if (!status.isGranted && !status.isLimited) {
      return PhotoPermissionResult.denied;
    }

    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      imagePath = picked.path;
      notifyListeners();
    }
    return PhotoPermissionResult.granted;
  }

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
      imagePath: imagePath,
    );
  }
}