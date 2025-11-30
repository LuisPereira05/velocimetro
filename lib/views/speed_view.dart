import 'dart:math' as math;
import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:HUDSpeedometerLCMR/viewmodels/speed_viewmodel.dart';

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

              final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

              final content = isLandscape
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 180,
                                ranges: <GaugeRange>[
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: 60,
                                    color: const Color.fromARGB(255, 129, 255, 133),
                                  ),
                                  GaugeRange(
                                    startValue: 60,
                                    endValue: 120,
                                    color: const Color.fromARGB(255, 201, 135, 36),
                                  ),
                                  GaugeRange(
                                    startValue: 120,
                                    endValue: 180,
                                    color: const Color.fromARGB(255, 255, 17, 0),
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
                                        color: isDarkMode ? Colors.white : Colors.black,
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
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  'Viagem: ${trip.toStringAsFixed(2)} km',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFeatures: const [FontFeature.tabularFigures()],
                                    color: isDarkMode ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  alignment: WrapAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isMirrored = !isMirrored;
                                          isDarkMode = !isDarkMode;
                                        });
                                      },
                                      child: Transform.scale(
                                          child: Text(isDarkMode ? 'Modo Mobile' : 'Modo HUD'),
                                          scaleY: isMirrored ? -1 : 1,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        final vm = context.read<SpeedViewModel>();
                                        vm.resetTrip();
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: Transform.scale(child: Text('Reset'), scaleY: isMirrored ? -1 : 1,),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height - 300,
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 180,
                                ranges: <GaugeRange>[
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: 60,
                                    color: const Color.fromARGB(255, 129, 255, 133),
                                  ),
                                  GaugeRange(
                                    startValue: 60,
                                    endValue: 120,
                                    color: const Color.fromARGB(255, 201, 135, 36),
                                  ),
                                  GaugeRange(
                                    startValue: 120,
                                    endValue: 180,
                                    color: const Color.fromARGB(255, 255, 17, 0),
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
                                        color: isDarkMode ? Colors.white : Colors.black,
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
                          'Viagem: ${trip.toStringAsFixed(2)} km',
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
                              child: Transform.scale(
                                  child: Text(isDarkMode ? 'Modo Mobile' : 'Modo HUD'),
                                  scaleY: isMirrored ? -1 : 1,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                final vm = context.read<SpeedViewModel>();
                                vm.resetTrip();
                              },
                              icon: const Icon(Icons.refresh),
                              label: Transform.scale(child: Text('Reset'), scaleY: isMirrored ? -1 : 1,),
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
