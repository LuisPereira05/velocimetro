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
    // Get screen orientation using MediaQuery
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

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
        ),
        body: Center(
          child: Consumer<SpeedViewModel>(
            builder: (context, vm, child) {
              final speed = vm.currentSpeed?.speedKmH ?? 0.0;
              final odometer = vm.odometerKm;

              return Transform(
                alignment: Alignment.center,
                // When in landscape, rotate 90 degrees and apply mirroring if needed
                transform: isLandscape
                    ? (isMirrored
                            ? Matrix4.rotationZ(
                                3.14159 / 2,
                              ) // Rotate 90 degrees for "panoramic"
                            : Matrix4.rotationZ(
                                3.14159 / 2,
                              ) // Rotate 90 degrees without mirroring
                        ..scale(-1, 1, 1)) // Apply mirroring if needed
                    : Matrix4.identity(), // No transformation in portrait mode
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
                          isMirrored = !isMirrored; // Toggle the mirror effect
                          isDarkMode = !isDarkMode; // Toggle dark mode
                        });
                      },
                      child: Text(
                        isDarkMode
                            ? (isLandscape ? "Modo Dashboard" : "Modo Mobile")
                            : (isLandscape ? "Modo Dashboard" : "Modo Mobile"),
                      ),
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
