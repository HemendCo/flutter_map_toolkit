import 'package:flutter_map_toolkit/src/core/type_caster.dart';

import 'package:latlong2/latlong.dart';

LatLng pointFromMap(Map<String, dynamic> map) {
  final point = LatLng(asType(map['lat']), asType(map['long']));
  return point;
}

String mapBoxUrlBuilder({
  String protocol = 'https',
  String host = 'api.mapbox.com',
  String basePath = 'styles',
  String apiVer = 'v1',
  required String style,
  bool is2x = false,
  required String accessToken,
}) {
  final result = StringBuffer(protocol)
    ..write('://')
    ..write(host)
    ..write('/')
    ..write(basePath)
    ..write('/')
    ..write(apiVer)
    ..write('/')
    ..write(style)
    ..write('/tiles/{z}/{x}/{y}')
    ..write(is2x ? '@2x' : '')
    ..write('?access_token=')
    ..write(accessToken);
  return result.toString();
}
