import 'dart:math' as math;
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
  bool isMirrored = false; // HUD (espelhado)
  bool isDarkMode = false; // fundo preto / texto branco

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = SpeedViewModel()..init();
        return vm;
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          title: const Text('Velocímetro'),
          backgroundColor: isDarkMode ? Colors.black : Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Consumer<SpeedViewModel>(
            builder: (context, vm, _) {
              final speed = vm.currentSpeed?.speedKmH ?? 0.0;
              final odometer = vm.odometerKm;
              final trip = vm.tripOdometerKm;

              final content = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                                '${speed.toStringAsFixed(1)} km/h',
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

                  Text(
                    'Hodômetro: ${odometer.toStringAsFixed(2)} km',
                    style: TextStyle(
                      fontSize: 24,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Trip: ${trip.toStringAsFixed(2)} km',
                    style: TextStyle(
                      fontSize: 18,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isMirrored = !isMirrored;
                            isDarkMode = !isDarkMode;
                          });
                        },
                        child: Transform(
                          alignment: Alignment.center,
                          transform: isMirrored
                              ? Matrix4.rotationX(math.pi)
                              : Matrix4.identity(),
                          child: Text(
                            isDarkMode ? 'Modo Claro' : 'Modo Escuro',
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          final vm = context.read<SpeedViewModel>();
                          vm.resetTrip(); // ✅ reseta só o TRIP
                        },
                        icon: Transform(
                          alignment: Alignment.center,
                          transform: isMirrored
                              ? Matrix4.rotationX(math.pi)
                              : Matrix4.identity(),
                          child: const Icon(Icons.refresh),
                        ),
                        label: Transform(
                          alignment: Alignment.center,
                          transform: isMirrored
                              ? Matrix4.rotationX(math.pi)
                              : Matrix4.identity(),
                          child: const Text('Reset'),
                        ),
                      ),
                    ],
                  ),
                ],
              );

              // ✅ HUD: inverter verticalmente
              return isMirrored
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(math.pi),
                      child: content,
                    )
                  : content;
            },
          ),
        ),
      ),
    );
  }
}
