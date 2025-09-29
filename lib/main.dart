import 'package:flutter/material.dart';
import 'package:velocimetro/views/speed_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velocímetro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SpeedometerPage(),
    );
  }
}
