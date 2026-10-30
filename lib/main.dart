import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ZeeshanLifeStyleApp());
}

class ZeeshanLifeStyleApp extends StatelessWidget {
  const ZeeshanLifeStyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeeshan Daily Life Style',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFC9A65A),
      ),
      home: const HomeScreen(),
    );
  }
}
