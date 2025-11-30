import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:HUDSpeedometerLCMR/models/speed.dart';

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

  Future<void> init() async {
    // Checa permissões
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    // Verifica serviço de localização
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    // Stream de posição com alta precisão
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      ),
    ).listen((Position position) {
      final lat = position.latitude;
      final lon = position.longitude;

      double distance = 0;

      if (_lastLat != null && _lastLon != null) {
        // usando Geolocator.distanceBetween
        distance = Geolocator.distanceBetween(
          _lastLat!, _lastLon!, lat, lon,
        );
        _odometer += distance;
        _tripOdometer += distance;
      }

      // velocidade em m/s
      double speedMps = position.speed;
      if (speedMps.isNaN || speedMps < 0) {
        final dt = (_lastTimestamp != null)
            ? DateTime.now().difference(_lastTimestamp!).inMilliseconds / 1000
            : 1.0;
        speedMps = distance / dt;
      }

      // Atualiza currentSpeed
      _currentSpeed = Speed(
        speed: speedMps,
        timestamp: DateTime.now(),
        latitude: lat,
        longitude: lon,
      );

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
