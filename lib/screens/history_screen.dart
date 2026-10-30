import 'package:flutter/material.dart';

import '../database.dart';
import 'day_editor.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, Map<String, dynamic>> _all = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await TrackerDb.loadAll();
    if (!mounted) return;
    setState(() {
      _all = all;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final dates = _all.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: dates.isEmpty
          ? const Center(child: Text('No entries yet. Start in Today.'))
          : ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, i) {
                final d = dates[i];
                final rating = _all[d]?['daily.rating'];
                return ListTile(
                  title: Text(d),
                  subtitle: Text(
                    rating == null ? 'No rating' : 'Day rating: $rating',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: Text(d)),
                          body: DayEditor(date: d),
                        ),
                      ),
                    );
                    _load();
                  },
                );
              },
            ),
    );
  }
}
