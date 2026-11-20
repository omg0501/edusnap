// lib\Pages\Add\AddPage.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Models/JournalEntry.dart';
import 'AddPageController.dart';

class AddPage extends StatefulWidget {
  final JournalEntry? existingEntry;

  const AddPage({super.key, this.existingEntry});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late final AddPageController _controller;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingEntry?.title ?? '');
    _noteController = TextEditingController(text: widget.existingEntry?.note ?? '');
    _controller = AddPageController(initialImagePath: widget.existingEntry?.imagePath);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showPhotoSourceSheet() async {
    final l10n = AppLocalizations.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.gallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l10n.camera),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null || !mounted) return;
    final result = await _controller.pickImage(source);

    if (result == PhotoPermissionResult.denied && mounted) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(
            source == ImageSource.camera
                ? l10n.cameraAccessNeeded
                : l10n.photoLibraryAccessNeeded,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.notNow),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                openAppSettings();
              },
              child: Text(l10n.openSettings),
            ),
          ],
        ),
      );
    }
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    final entry = _controller.createOrUpdateEntry(
      rawTitle: _titleController.text,
      rawNote: _noteController.text,
      existingCreatedAt: widget.existingEntry?.createdAt,
    );

    if (entry == null) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(l10n.titleMissing),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.existingEntry != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? l10n.edit : l10n.add)),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final hasPhoto = _controller.imagePath != null &&
                File(_controller.imagePath!).existsSync();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: l10n.title),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.note),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                if (hasPhoto) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_controller.imagePath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                OutlinedButton.icon(
                  onPressed: _showPhotoSourceSheet,
                  icon: const Icon(Icons.photo_camera),
                  label: Text(hasPhoto ? l10n.changePhoto : l10n.addPhoto),
                ),
                const SizedBox(height: 16),
                FilledButton(onPressed: _save, child: Text(l10n.save)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.back),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}