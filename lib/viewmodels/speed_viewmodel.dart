import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velocimetro/models/speed.dart';
import '../utils/distance_utils.dart';

class SpeedViewModel extends ChangeNotifier {
  Speed? _currentSpeed;
  double _odometer = 0.0;      // total acumulado em metros
  double _tripOdometer = 0.0;  // hodômetro parcial (trip)
  
  double? _lastLat;
  double? _lastLon;
  DateTime? _lastTimestamp;

  Speed? get currentSpeed => _currentSpeed;
  double get odometerKm => _odometer / 1000.0;
  double get tripOdometerKm => _tripOdometer / 1000.0;

  Future<void> init(BuildContext context) async {
    // Checa permissões
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão negada')),
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão negada permanentemente')),
      );
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão concedida')),
      );
    }

    // Verifica serviço de localização
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS desativado')),
      );
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS ativo')),
      );
    }

    // Stream de posição
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
        timeLimit: Duration(seconds: 0),
      ),
    ).listen((Position position) {
      final lat = position.latitude;
      final lon = position.longitude;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nova posição: $lat, $lon'),
          duration: const Duration(milliseconds: 500),
        ),
      );

      if (_lastLat != null && _lastLon != null) {
        final distance = calculateDistance(_lastLat!, _lastLon!, lat, lon);
        _odometer += distance;
        _tripOdometer += distance;

        double speedMps = position.speed;
        if (speedMps.isNaN || speedMps < 0) {
          final dt = DateTime.now().difference(_lastTimestamp!).inMilliseconds / 1000;
          speedMps = distance / dt;
        }

        _currentSpeed = Speed(
          speed: speedMps,
          timestamp: DateTime.now(),
          latitude: lat,
          longitude: lon,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Velocidade: ${(speedMps*3.6).toStringAsFixed(1)} km/h, Distância percorrida: ${_odometer.toStringAsFixed(1)} m'),
            duration: const Duration(milliseconds: 500),
          ),
        );
      }

      _lastLat = lat;
      _lastLon = lon;
      _lastTimestamp = DateTime.now();

      notifyListeners();
    });
  }


  void resetOdometer() {
    _odometer = 0.0;
    notifyListeners();
  }

  void resetTrip() {
    _tripOdometer = 0.0;
    notifyListeners();
  }
}
