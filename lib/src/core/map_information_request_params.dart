import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_toolkit/src/core/type_caster.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_map_toolkit/src/core/core_methods.dart';

/// body of a post request to the server
///
/// [viewPort] is the current viewport of the map in the form of a [LatLngBounds]
/// - this is used to get only needed information from the server
///
/// [center] is calculated from view port if not provided
class MapInformationRequestParams {
  final LatLngBounds viewPort;
  final LatLng center;
  final double zoom;

  /// body of a post request to the server
  ///
  /// [viewPort] is the current viewport of the map in the form of a [LatLngBounds]
  /// - this is used to get only needed information from the server
  ///
  /// [center] is calculated from view port if not provided
  MapInformationRequestParams({
    required this.viewPort,
    LatLng? center,
    required this.zoom,
  }) : center = center ?? viewPort.center;

  MapInformationRequestParams copyWith({
    LatLngBounds? viewPort,
    LatLng? center,
    double? zoom,
  }) {
    return MapInformationRequestParams(
      viewPort: viewPort ?? this.viewPort,
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'viewPort': {
        'northWest': {
          'lat': viewPort.northWest.latitude,
          'long': viewPort.northWest.longitude,
        },
        'southEast': {
          'lat': viewPort.southEast.latitude,
          'long': viewPort.southEast.longitude,
        },
      },
      'center': {
        'lat': center.latitude,
        'long': center.longitude,
      },
      'zoom': zoom,
    };
  }

  factory MapInformationRequestParams.fromMap(Map<String, dynamic> map) {
    final bounds = boundsFromMap(
      Map<String, dynamic>.from(
        map['viewPort'] as Map,
      ),
    );
    return MapInformationRequestParams(
      viewPort: bounds,
      zoom: asType(map['zoom']),
      center: pointFromMap(
        asType(
          map['center'],
        ),
      ),
    );
  }

  static LatLngBounds boundsFromMap(Map<String, dynamic> map) {
    final point0Map = map['northWest'];
    final point0LatLng = pointFromMap(asType(point0Map));
    final point1Map = map['southEast'];
    final point1LatLng = pointFromMap(asType(point1Map));
    return LatLngBounds(point0LatLng, point1LatLng);
  }

  @override
  String toString() => //
      'MapInformationRequestParams(viewPort: $viewPort, center: $center)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MapInformationRequestParams && //
        other.viewPort == viewPort &&
        other.center == center;
  }

  @override
  int get hashCode => viewPort.hashCode ^ center.hashCode;
}
