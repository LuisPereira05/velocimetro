import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:velocimetro/views/speed_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Mantém a tela ligada (importante para HUD)
  await WakelockPlus.enable();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velocímetro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: const SpeedometerPage(),
    );
  }
}
