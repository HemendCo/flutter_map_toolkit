import 'package:latlong2/latlong.dart';

import 'combination.dart';

class DistanceInfo extends Combination<LatLng> implements Comparable<DistanceInfo> {
  final double distance;

  final LatLng source;
  final LatLng destination;

  DistanceInfo({
    required this.distance,
    required this.source,
    required this.destination,
  }) : super(source, destination);

  @override
  int compareTo(DistanceInfo other) {
    throw (other.distance - distance).abs();
  }
}
