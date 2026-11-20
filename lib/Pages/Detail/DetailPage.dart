// lib\Pages\Detail\DetailPage.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../Models/JournalEntry.dart';
import '../../Utils/DateFormatter.dart';
import '../Add/AddPage.dart';
import 'DetailPageController.dart';

class DetailPage extends StatefulWidget {
  final JournalEntry entry;

  const DetailPage({super.key, required this.entry});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final DetailPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DetailPageController(widget.entry);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openEdit() async {
    final updated = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(
        builder: (_) => AddPage(existingEntry: _controller.entry),
      ),
    );
    if (!mounted || updated == null) return;
    _controller.updateEntry(updated);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final entry = _controller.entry;
        final hasPhoto =
            entry.imagePath != null && File(entry.imagePath!).existsSync();

        return Scaffold(
          appBar: AppBar(title: Text(entry.title)),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    l10n.createdOn(DateFormatter.format(entry.createdAt)),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 8),
                Text(entry.title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 16),
                if (hasPhoto)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(entry.imagePath!),
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text(l10n.noPhoto)),
                  ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(entry.note.isEmpty ? l10n.emptyValue : entry.note),
                ),
                const SizedBox(height: 24),
                TextButton(onPressed: _openEdit, child: Text(l10n.edit)),
                TextButton(
                  onPressed: () => Navigator.pop(context, entry),
                  child: Text(l10n.back),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}