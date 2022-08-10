library flutter_map_hemend.directions.providers;
// ignore_for_file: constant_identifier_names

import 'package:flutter_map_hemend/src/core/type_caster.dart';
import 'package:flutter_map_hemend/src/direction/direction_provider.dart';
import 'package:latlong2/latlong.dart';

/// details level of the route
/// - simplified : low detail level can be used for low quality routing view only
///
/// - full : full detail level can be used for high quality routing view
enum MapboxDetailsLevel {
  simplified,
  full,
}

enum MapboxGeometries {
  geojson,
  polyline,
  polyline6,
}

/// details level of each step in response
///
/// this is not used inside the plugin but you can use it to get more details
/// about each step in the route via [onDirectionResult]
///
/// does not work with `steps`: `false` or
/// `detailsLevel` : `MapboxDetailsLevel.simplified`
enum MapboxDetailsAnnotations {
  distance,
  duration,
  speed,
  congestion,
}

/// options for the route request
///
/// used to exclude certain points from result of the route request
enum MapboxExcludeAnnotations {
  toll,
  motorway,
  ferry,
  unpaved,
  cash_only_tolls,
}

/// [MapboxDirectionProvider] is a provider for the [DirectionsPlugin]
/// it is used to get the route from the mapbox api
///
/// [MapboxRouteSelectMode] is used to determine how the route is selected
enum MapboxRouteSelectMode {
  drivingWithTraffic('driving-traffic/'),
  driving('driving/'),
  cycling('walking/'),
  walking('walking/');

  const MapboxRouteSelectMode(this.value);

  final String value;
}

/// playground: [https://docs.mapbox.com/playground/directions]
///
/// (Required) [mapboxToken] : token for the mapbox api
///
/// (Required) [getRequestHandler] : function that will be used to get the
/// response of the request with given [url]
///
/// [onDirectionResult] : function that will be called when the response of the
/// request is received
///
/// **These values can be changed after creating the instance of the class**
/// - [language] : language of the response (default: 'en')
/// - [geometries] : type of the geometry of the route (default: 'geojson')
/// - [steps] : whether to return steps in the response (default: false)
/// - [alternatives] : whether to return alternative routes in the response
/// - [detailsLevel] : type of the overview geometry in the response (default: 'full')
/// - [routeSelectMode] : result route mode of the request (default: 'driving')
/// - [continueStraight] : whether to continue straight at waypoints (default: true)
/// - [annotations] : details of each step in the response (default: [])
/// - [excludeAnnotations] : exclude certain points/events from the response (default: [])
class MapboxDirectionProvider implements DirectionsProvider {
  static const baseUrl = 'https://api.mapbox.com/directions/v5/mapbox/';
  final Future<Map<String, dynamic>> Function(String url) getRequestHandler;
  final String mapboxToken;
  final void Function(Map<String, dynamic>)? onDirectionResult;
  MapboxRouteSelectMode routeSelectMode;
  MapboxDetailsLevel detailsLevel;
  bool continueStraight;
  MapboxGeometries geometries;
  String language;
  bool steps;
  Set<MapboxDetailsAnnotations> annotations;
  Set<MapboxExcludeAnnotations> excludeAnnotations;
  bool alternatives;
  MapboxDirectionProvider({
    required this.mapboxToken,
    required this.getRequestHandler,
    this.onDirectionResult,
    this.language = 'en',
    this.alternatives = false,
    this.annotations = const <MapboxDetailsAnnotations>{},
    this.excludeAnnotations = const <MapboxExcludeAnnotations>{},
    this.steps = false,
    this.geometries = MapboxGeometries.geojson,
    this.continueStraight = true,
    this.detailsLevel = MapboxDetailsLevel.full,
    this.routeSelectMode = MapboxRouteSelectMode.driving,
  });
  @override
  Future<DirectionProviderResponse> getDirections(DirectionsRequest request) async {
    final urlBuilder = StringBuffer(baseUrl)
      ..write(routeSelectMode.value)
      ..write(request.routingPoints.map((e) => '${e.longitude},${e.latitude}').join(';'))
      ..write('?')
      ..write('alternatives=$alternatives')
      ..write('&continue_straight=$continueStraight')
      ..write('&geometries=${geometries.name}')
      ..write('&language=$language')
      ..write('&overview=${detailsLevel.name}')
      ..write('&steps=$steps')
      ..write(annotations.isNotEmpty ? '&annotations=${annotations.map((e) => e.name).join(',')}' : '')
      ..write(excludeAnnotations.isNotEmpty ? '&exclude=${excludeAnnotations.map((e) => e.name).join(',')}' : '')
      ..write('&access_token=$mapboxToken');
    final url = urlBuilder.toString();

    final response = await getRequestHandler(url)
        .onError((error, stackTrace) => throw Exception('Error while getting directions: $error\n$stackTrace'));
    onDirectionResult?.call(response);

    final path = List<Map<String, dynamic>>.from(asType(response['routes'])).first['geometry']['coordinates'];
    final pathList = List<dynamic>.from(asType(path));
    final pathListLatLng = pathList.map((e) => LatLng(asType(e[1]), asType(e[0])));

    return DirectionProviderResponse(path: pathListLatLng.toList());
  }
}
