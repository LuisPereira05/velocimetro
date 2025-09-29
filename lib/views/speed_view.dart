import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:velocimetro/viewmodels/speed_viewmodel.dart';

class SpeedometerPage extends StatefulWidget {
  const SpeedometerPage({super.key});

  @override
  _SpeedometerPageState createState() => _SpeedometerPageState();
}

class _SpeedometerPageState extends State<SpeedometerPage> {
  bool isMirrored = false; // espelhar HUD
  bool isDarkMode = false; // fundo preto / texto branco

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = SpeedViewModel();
        vm.init();
        return vm;
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          title: const Text("Velocímetro"),
          backgroundColor: isDarkMode ? Colors.black : Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Consumer<SpeedViewModel>(
            builder: (context, vm, child) {
              final speed = vm.currentSpeed?.speedKmH ?? 0.0;
              final odometer = vm.odometerKm;

              final content = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Velocímetro analógico
                  SizedBox(
                    height: 300,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 180,
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0,
                              endValue: 60,
                              color: Colors.green,
                            ),
                            GaugeRange(
                              startValue: 60,
                              endValue: 120,
                              color: Colors.orange,
                            ),
                            GaugeRange(
                              startValue: 120,
                              endValue: 180,
                              color: Colors.red,
                            ),
                          ],
                          pointers: <GaugePointer>[NeedlePointer(value: speed)],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                "${speed.toStringAsFixed(1)} km/h",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.8,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Hodômetro digital
                  Text(
                    "Hodômetro: ${odometer.toStringAsFixed(2)} km",
                    style: TextStyle(
                      fontSize: 24,
                      fontFeatures: [FontFeature.tabularFigures()],
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isMirrored = !isMirrored; // HUD ON/OFF
                        isDarkMode = !isDarkMode;
                      });
                    },
                    child: Transform.scale(
                      scaleY: isMirrored
                          ? -1
                          : 1, // desfaz o espelho só no texto
                      child: Text(isDarkMode ? "Modo Mobile" : "Modo HUD"),
                    ),
                  ),
                ],
              );

              // Espelha horizontalmente para HUD (reflexo no para-brisa fica "normal")
              return isMirrored
                  ? Transform.scale(scaleY: -1, child: content)
                  : content;
            },
          ),
        ),
      ),
    );
  }
}
