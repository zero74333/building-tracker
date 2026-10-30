import 'package:flutter/material.dart';

import '../export_service.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  Future<void> _run(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export & Backup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => _run(context, ExportService.shareMarkdown),
            icon: const Icon(Icons.description),
            label: const Text('Export as Markdown (.md)'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => _run(context, ExportService.shareBackup),
            icon: const Icon(Icons.backup),
            label: const Text('Save backup (.json)'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _run(context, () async {
              final n = await ExportService.restoreBackup();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Restored $n day(s)')));
            }),
            icon: const Icon(Icons.restore),
            label: const Text('Restore from backup (.json)'),
          ),
        ],
      ),
    );
  }
}
