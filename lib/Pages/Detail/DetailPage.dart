// lib\Pages\Detail\DetailPage.dart
import 'package:flutter/material.dart';
import '../../Models/JournalEntry.dart';
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final entry = _controller.entry;
        return Scaffold(
          appBar: AppBar(title: Text(entry.title)),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.title, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Text(entry.note),
                  const Spacer(),
                  Center(
                    child: TextButton(
                      onPressed: _openEdit,
                      child: const Text('Edit'),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, entry),
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}