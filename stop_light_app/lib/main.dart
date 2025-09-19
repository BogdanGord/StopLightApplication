import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(const StopLightApp());
}

class StopLightApp extends StatelessWidget {
  const StopLightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stop Light',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomePage(),
    );
  }
}
