// lib\Pages\HomePage\HomePage.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../Component/JournalCard/JournalCard.dart';
import '../../Models/JournalEntry.dart';
import '../../Utils/AppLocaleController.dart';
import '../Add/AddPage.dart';
import '../Detail/DetailPage.dart';
import '../Settings/SettingsPage.dart';
import 'HomePageController.dart';

class HomePage extends StatefulWidget {
  final AppLocaleController localeController;

  const HomePage({super.key, required this.localeController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController _controller = HomePageController();

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

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
    await _controller.insertAtTop(entry);
  }

  Future<void> _openDetail(int index, JournalEntry entry) async {
    final updated = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(entry: entry)),
    );
    if (!mounted || updated == null) return;
    await _controller.updateEntry(index, updated);
  }

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsPage(localeController: widget.localeController),
      ),
    );
    if (!mounted) return;
    await _controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _openSettings,
        ),
        title: Text(l10n.list),
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
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_controller.entries.isEmpty) {
            return Center(child: Text(l10n.noEntries));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _controller.entries.length,
            itemBuilder: (context, index) {
              final entry = _controller.entries[index];
              return Dismissible(
                key: ObjectKey(entry),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
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