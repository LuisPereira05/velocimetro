

class Speed {
  final double speed;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;

  Speed({
    required this.speed,
    required this.timestamp,
    this.latitude,
    this.longitude,
  });

  double get speedKmH => speed * 3.6;

}
