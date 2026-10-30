import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'database.dart';
import 'fields.dart';

class ExportService {
  /// Builds one Markdown file with every day, then opens the share sheet
  /// (save to Google Drive, Files, Obsidian, email, etc.).
  static Future<void> shareMarkdown() async {
    final all = await TrackerDb.loadAll();
    final buf = StringBuffer('# Zeeshan Daily Life Style: Export\n\n');

    all.forEach((date, data) {
      buf.writeln('## $date');
      buf.writeln();
      for (final s in sections) {
        final lines = <String>[];
        for (final f in s.fields) {
          final v = data['${s.id}.${f.key}'];
          if (v == null || v == false || v == '') continue;
          final shown = v == true ? 'Yes' : v.toString();
          lines.add('- ${f.label}: $shown');
        }
        if (lines.isEmpty) continue;
        buf.writeln('### ${s.title}');
        for (final line in lines) {
          buf.writeln(line);
        }
        buf.writeln();
      }
    });

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/life-tracker-export.md');
    await file.writeAsString(buf.toString());
    await Share.shareXFiles([XFile(file.path)], subject: 'Life tracker export');
  }

  /// Saves all data as a JSON backup file and opens the share sheet.
  static Future<void> shareBackup() async {
    final all = await TrackerDb.loadAll();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/life-tracker-backup.json');
    await file.writeAsString(jsonEncode(all));
    await Share.shareXFiles([XFile(file.path)], subject: 'Life tracker backup');
  }

  /// Lets you pick a backup file and merges it into this phone.
  /// Returns how many days were restored (0 if no file was picked).
  static Future<int> restoreBackup() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = picked?.files.single.path;
    if (path == null) return 0;

    final raw = jsonDecode(await File(path).readAsString()) as Map<String, dynamic>;
    final all = raw.map(
      (date, data) => MapEntry(date, Map<String, dynamic>.from(data as Map)),
    );
    await TrackerDb.importAll(all);
    return all.length;
  }
}
