import 'package:flutter/material.dart';

import '../database.dart';
import '../fields.dart';

/// Shows every section for one day. Used by Today and by History.
/// Quick sections are open by default; full-entry sections start collapsed.
class DayEditor extends StatefulWidget {
  const DayEditor({super.key, required this.date});

  final String date;

  @override
  State<DayEditor> createState() => _DayEditorState();
}

class _DayEditorState extends State<DayEditor> {
  Map<String, dynamic> _data = {};
  bool _loading = true;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final d = await TrackerDb.load(widget.date);
    if (!mounted) return;
    setState(() {
      _data = d;
      _loading = false;
    });
  }

  void _changed() => setState(() => _dirty = true);

  Future<void> _save() async {
    await TrackerDb.save(widget.date, _data);
    if (!mounted) return;
    setState(() => _dirty = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (final s in sections)
                ExpansionTile(
                  title: Text(s.title),
                  initiallyExpanded: s.quick,
                  children: [
                    for (final f in s.fields)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: _buildField(s, f),
                      ),
                  ],
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _dirty ? _save : null,
              icon: const Icon(Icons.save),
              label: Text(_dirty ? 'Save' : 'Saved'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(SectionDef s, FieldDef f) {
    // Same key format the Markdown export reads: "section.field".
    final key = '${s.id}.${f.key}';
    final v = _data[key];

    switch (f.type) {
      case FieldType.text:
      case FieldType.multiline:
        return TextFormField(
          initialValue: v?.toString() ?? '',
          maxLines: f.type == FieldType.multiline ? 4 : 1,
          decoration: InputDecoration(
            labelText: f.label,
            border: const OutlineInputBorder(),
          ),
          onChanged: (t) {
            _data[key] = t;
            _changed();
          },
        );

      case FieldType.number:
        return TextFormField(
          initialValue: v?.toString() ?? '',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: f.label,
            border: const OutlineInputBorder(),
          ),
          onChanged: (t) {
            _data[key] = num.tryParse(t) ?? t;
            _changed();
          },
        );

      case FieldType.slider:
        final score = v is num ? v.toInt() : 5;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${f.label}: $score / 10'),
            Slider(
              value: score.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$score',
              onChanged: (x) {
                _data[key] = x.round();
                _changed();
              },
            ),
          ],
        );

      case FieldType.check:
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(f.label),
          value: v == true,
          onChanged: (x) {
            _data[key] = x ?? false;
            _changed();
          },
        );

      case FieldType.choice:
        final options = f.options ?? const <String>[];
        return DropdownButtonFormField<String>(
          value: options.contains(v) ? v as String : null,
          decoration: InputDecoration(
            labelText: f.label,
            border: const OutlineInputBorder(),
          ),
          items: [
            for (final o in options)
              DropdownMenuItem(value: o, child: Text(o)),
          ],
          onChanged: (x) {
            _data[key] = x;
            _changed();
          },
        );
    }
  }
}
