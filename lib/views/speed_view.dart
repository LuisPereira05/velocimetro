import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:velocimetro/viewmodels/speed_viewmodel.dart';

class SpeedometerPage extends StatelessWidget {
  const SpeedometerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = SpeedViewModel();
        vm.init(context);
        return vm;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Velocímetro")),
        body: Center(
          child: Consumer<SpeedViewModel>(
            builder: (context, vm, child) {
              final speed = vm.currentSpeed?.speedKmH ?? 0.0;
              final odometer = vm.odometerKm;

              return Column(
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
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
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
                    style: const TextStyle(
                      fontSize: 24,
                      fontFeatures: [FontFeature.tabularFigures()], // números alinhados
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => vm.resetOdometer(),
                    child: const Text("Resetar Hodômetro"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
