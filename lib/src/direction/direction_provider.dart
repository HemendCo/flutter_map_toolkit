import 'package:flutter_map_hemend/src/core/extensions.dart';
import 'package:latlong2/latlong.dart';

/// a provider must have [getDirections] methods with the following parameters:
/// - [request] : the request parameters which is a [DirectionsRequest]
/// containing waypoints
///
/// and in response it must have the following parameters:
/// - [response] : the response parameters which is a [DirectionProviderResponse]
/// which will have [path] that is a [List<LatLng>] of the route
abstract class DirectionsProvider {
  Future<DirectionProviderResponse> getDirections(DirectionsRequest request);
}

class DirectionsRequest {
  final List<LatLng> routingPoints;

  DirectionsRequest(this.routingPoints);
}

class DirectionProviderResponse {
  final List<LatLng> path;

  DirectionProviderResponse({
    required this.path,
  });
  double get totalDistance => path.calculateLength();
}
