// lib\Pages\Settings\SettingsPage.dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../Utils/AppLocaleController.dart';
import 'SettingsPageController.dart';

class SettingsPage extends StatefulWidget {
  final AppLocaleController localeController;

  const SettingsPage({super.key, required this.localeController});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsPageController _controller = SettingsPageController();

  @override
  void initState() {
    super.initState();
    _controller.calculateStorageUsage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleClearDataWithDoubleConfirm() async {
    final l10n = AppLocalizations.of(context)!;

    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmClearTitle1),
        content: Text(l10n.confirmClearMsg1),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.confirm)),
        ],
      ),
    );
    if (firstConfirm != true || !mounted) return;

    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmClearTitle2),
        content: Text(l10n.confirmClearMsg2),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.confirm)),
        ],
      ),
    );
    if (secondConfirm != true || !mounted) return;

    await _controller.clearAllData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, widget.localeController]),
          builder: (context, _) {
            final isChinese = widget.localeController.locale.scriptCode == 'Hant';

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  title: Text(l10n.language),
                  trailing: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, label: Text('English')),
                      ButtonSegment(value: true, label: Text('中文')),
                    ],
                    selected: {isChinese},
                    onSelectionChanged: (selection) {
                      widget.localeController.setLocale(
                        selection.first
                            ? const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
                            : const Locale('en'),
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text(l10n.storageUsage),
                  trailing: Text(l10n.storageUsed(_controller.storageSizeKb.toStringAsFixed(1))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: OutlinedButton.icon(
                    onPressed: _handleClearDataWithDoubleConfirm,
                    icon: const Icon(Icons.delete_forever),
                    label: Text(l10n.formatData),
                  ),
                ),
                const SizedBox(height: 24),
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