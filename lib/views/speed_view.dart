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
  bool isMirrored = false; // Tracks if the interface is mirrored
  bool isDarkMode =
      false; // Tracks if the background is black and text is white

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = SpeedViewModel();
        vm.init();
        return vm;
      },
      child: Scaffold(
        backgroundColor: isDarkMode
            ? Colors.black
            : Colors.white, // Set background color based on mode
        appBar: AppBar(
          title: const Text("Velocímetro"),
          backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        ),
        body: Center(
          child: Consumer<SpeedViewModel>(
            builder: (context, vm, child) {
              final speed = vm.currentSpeed?.speedKmH ?? 0.0;
              final odometer = vm.odometerKm;

              return Transform(
                alignment: Alignment.center,
                transform: isMirrored
                    ? Matrix4.rotationY(3.14159)
                    : Matrix4.identity(), // Mirror transformation
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gauge circular (velocímetro analógico)
                    SizedBox(
                      height: 300,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 180, // até 180 km/h
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
                            pointers: <GaugePointer>[
                              NeedlePointer(value: speed),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  "${speed.toStringAsFixed(1)} km/h",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors
                                              .black, // Text color based on mode
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
                        fontFeatures: [
                          FontFeature.tabularFigures(),
                        ], // números alinhados
                        color: isDarkMode
                            ? Colors.white
                            : Colors.black, // Text color based on mode
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Toggle the mirror effect and the dark mode
                        setState(() {
                          isMirrored = !isMirrored;
                          isDarkMode = !isDarkMode;
                        });
                      },
                      child: Text(
                        isDarkMode ? "Modo Claro" : "Modo Escuro",
                      ), // Change button text based on the current mode
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
