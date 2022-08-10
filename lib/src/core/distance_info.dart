import 'package:latlong2/latlong.dart';

class DistanceInfo {
  final double dist;
  final LatLng source;
  final LatLng destination;
  DistanceInfo({
    required this.dist,
    required this.source,
    required this.destination,
  });
}
