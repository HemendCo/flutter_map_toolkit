import 'package:flutter_map_hemend/src/core/type_caster.dart';

import 'package:latlong2/latlong.dart';

LatLng pointFromMap(Map<String, dynamic> map) {
  final point = LatLng(asType(map['lat']), asType(map['long']));
  return point;
}
