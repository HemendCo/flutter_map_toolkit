library flutter_map_toolkit.directions;

import 'package:flutter_map_toolkit/src/core/extensions.dart';
import 'package:latlong2/latlong.dart';

/// a provider must have [getDirections] methods with the following parameters:
/// - [request] : the request parameters which is a [DirectionsRequest]
/// containing waypoints
///
/// and in response it must have the following parameters:
/// - [response] : the response parameters which is a [DirectionProviderResponse]
/// which will have [path] that is a [List<LatLng>] of the route
abstract class DirectionsProvider {
  /// a provider must have [getDirections] methods with the following parameters:
  /// - [request] : the request parameters which is a [DirectionsRequest]
  /// containing waypoints
  ///
  /// and in response it must have the following parameters:
  /// - [response] : the response parameters which is a [DirectionProviderResponse]
  /// which will have [path] that is a [List<LatLng>] of the route
  const DirectionsProvider();
  Future<DirectionProviderResponse> getDirections(DirectionsRequest request);
}

/// a provider must have [getDirections] methods with the following parameters:
/// - [request] : the request parameters which is a [DirectionsRequest]
class DirectionsRequest {
  /// waypoints of the routing request
  final List<LatLng> waypoints;

  /// a provider must have [getDirections] methods with the following parameters:
  /// - [request] : the request parameters which is a [DirectionsRequest]
  DirectionsRequest(this.waypoints);
}

/// response of the [DirectionsProvider] which will have [path] that is a
/// [List<LatLng>] of the route

class DirectionProviderResponse {
  /// path of the route
  final List<LatLng> path;

  /// response of the [DirectionsProvider] which will have [path] that is a
  /// [List<LatLng>] of the route
  DirectionProviderResponse({
    required this.path,
  });

  /// total distance of the route
  double getTotalDistance({
    DistanceMode distanceMode = DistanceMode.kilometers,
  }) =>
      path.calculateLength(
        distanceMode: distanceMode,
      );
}
