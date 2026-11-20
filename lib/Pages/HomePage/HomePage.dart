import 'package:flutter/material.dart';
import '../../Component/JournalCard/JournalCard.dart';
import '../../Models/JournalEntry.dart';
import '../Add/AddPage.dart';
import '../Detail/DetailPage.dart';
import '../Settings/SettingsPage.dart';
import 'HomePageController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController _controller = HomePageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openAdd() async {
    final entry = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(builder: (_) => const AddPage()),
    );
    if (!mounted || entry == null) return;
    _controller.insertAtTop(entry);
  }

  Future<void> _openDetail(int index, JournalEntry entry) async {
    final updated = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(entry: entry)),
    );
    if (!mounted || updated == null) return;
    _controller.updateEntry(index, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          ),
        ),
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAdd,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return ListView.builder(
            itemCount: _controller.entries.length,
            itemBuilder: (context, index) {
              final entry = _controller.entries[index];
              return Dismissible(
                key: ObjectKey(entry),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => _controller.remove(entry),
                child: JournalCard(
                  entry: entry,
                  onTap: () => _openDetail(index, entry),
                ),
              );
            },
          );
        },
      ),
    );
  }
}