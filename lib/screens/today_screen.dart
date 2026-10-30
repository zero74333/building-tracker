import 'package:flutter/material.dart';

import '../database.dart';
import 'day_editor.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = dateKey(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: Text('Today · $key')),
      body: DayEditor(date: key),
    );
  }
}
