import 'dart:math';

import 'package:latlong2/latlong.dart';

import 'distance_info.dart';

/// metrics of result of distance mode
/// used to set earth's radius
enum DistanceMode {
  meters(6378000),
  kilometers(6378),
  miles(3959);

  const DistanceMode(this.earthRadius);
  final double earthRadius;
}

extension LatLngTools on LatLng {
  /// calculate distance between two points
  ///
  /// distanceMode is unit of result
  double calculateDistanceTo(LatLng target, {DistanceMode distanceMode = DistanceMode.kilometers}) {
    final deltaLong = target.longitudeInRad - longitudeInRad;
    final deltaLat = target.latitudeInRad - latitudeInRad;
    final a = pow(sin(deltaLat / 2), 2) + cos(latitudeInRad) * cos(target.latitudeInRad) * pow(sin(deltaLong / 2), 2);

    final c = 2 * asin(sqrt(a));

    return (c * distanceMode.earthRadius);
  }
}

extension LatLngListTools<T extends LatLng> on List<T> {
  /// used to calculate length of a path
  ///
  /// distanceMode is unit of result
  double calculateLength({DistanceMode distanceMode = DistanceMode.kilometers}) {
    double distance = 0;
    for (int i = 0; i < length - 1; i++) {
      distance += this[i].calculateDistanceTo(this[i + 1], distanceMode: distanceMode);
    }
    return distance;
  }

  DistanceInfo? distanceToPoint(LatLng point, [double precision = 15]) {
    if (isNotEmpty == true) {
      final path = Path();
      path.addAll(this);
      final normalized = path.equalize(precision);
      final shortestDistance = normalized.coordinates
          .map(
        (coordinate) => DistanceInfo(
          destination: point,
          dist: coordinate.calculateDistanceTo(point),
          source: coordinate,
        ),
      )
          .reduce(
        ((a, b) {
          return b.dist < a.dist ? b : a;
        }),
      );
      return shortestDistance;
    }
    return null;
  }
}

extension Dissolver<T> on List<T> {
  List<List<T>> dissolveToListsOf(int n) {
    final result = <List<T>>[];
    for (int i = 0; i < length; i++) {
      result.add(sublist(i, min(i + n, length)));
    }
    if (result.last.length < n) {
      result.removeLast();
      result.add(sublist(length - n, length));
    }
    return result;
  }
}
