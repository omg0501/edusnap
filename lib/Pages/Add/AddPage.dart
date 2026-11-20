import 'package:flutter/material.dart';
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
  final AddPageController _controller = AddPageController();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingEntry?.title ?? '');
    _noteController = TextEditingController(text: widget.existingEntry?.note ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final entry = _controller.createOrUpdateEntry(
      rawTitle: _titleController.text,
      rawNote: _noteController.text,
      existingCreatedAt: widget.existingEntry?.createdAt,
    );

    if (entry == null) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Title is missing'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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
    final isEdit = widget.existingEntry != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit' : 'Add')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}