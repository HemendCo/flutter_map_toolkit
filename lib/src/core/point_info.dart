import 'package:latlong2/latlong.dart';

import 'type_caster.dart';
import 'core_methods.dart';

class PointInfo {
  final double rotation;
  final LatLng position;
  final String? iconId;
  PointInfo({
    required this.rotation,
    required this.position,
    required this.iconId,
  });

  Map<String, dynamic> toMap() {
    return {
      'rotation': rotation,
      'position': {
        'lat': position.latitude,
        'long': position.longitude,
      },
      'iconId': iconId,
    };
  }

  factory PointInfo.fromMap(Map<String, dynamic> map) {
    return PointInfo(
      rotation: asType(
        map['rotation'],
        doubleParser,
      ),
      position: pointFromMap(asType(map['position'])),
      iconId: asType(map['iconId']),
    );
  }
}
