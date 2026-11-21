import 'package:flutter/material.dart';
import '../../Utils/AppLocaleController.dart';
import '../../Utils/DuoLayoutController.dart';
import '../../l10n/app_localizations.dart';
import 'SettingsPageController.dart';

class SettingsPage extends StatefulWidget {
  final AppLocaleController localeController;
  final DuoLayoutController duoController;

  const SettingsPage({
    super.key,
    required this.localeController,
    required this.duoController,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsPageController _controller = SettingsPageController();

  @override
  void initState() {
    super.initState();
    _controller.init();
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
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
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
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (secondConfirm != true || !mounted) return;

    await _controller.clearAllData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _controller,
        widget.localeController,
        widget.duoController,
      ]),
      builder: (context, _) {
        final isChinese =
            widget.localeController.locale.scriptCode == 'Hant';
        final duoRailActive = widget.duoController.isSideRailActive;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !duoRailActive,
            title: Text(l10n.settings),
          ),
          body: SafeArea(
            child: ListView(
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
                            ? const Locale.fromSubtags(
                                languageCode: 'zh',
                                scriptCode: 'Hant',
                              )
                            : const Locale('en'),
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text(l10n.storageUsage),
                  trailing: Text(
                    l10n.storageUsed(
                      _controller.storageSizeKb.toStringAsFixed(1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: OutlinedButton.icon(
                    onPressed: _handleClearDataWithDoubleConfirm,
                    icon: const Icon(Icons.delete_forever),
                    label: Text(l10n.formatData),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text(l10n.version),
                  trailing: Text(_controller.version),
                ),
                ListTile(
                  title: Text(l10n.buildNumber),
                  trailing: Text(_controller.buildNumber),
                ),
                if (!duoRailActive) ...[
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.back),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}