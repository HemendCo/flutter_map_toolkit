import 'package:latlong2/latlong.dart';

import 'type_caster.dart';
import 'core_methods.dart';

class PointInfo {
  final double rotation;
  final LatLng position;
  final String? iconId;
  final Map<String, dynamic> metaData;

  /// info of the marker point containing the following parameters:
  /// rotation - rotation of the marker in radians
  /// position - [LatLng]position of the marker
  /// iconId - id of the marker icon (must be provided to plugin - some plugins
  /// do not support icons and will ignore this parameter)
  PointInfo({
    required this.rotation,
    required this.position,
    required this.iconId,
    required this.metaData,
  });

  Map<String, dynamic> toMap() {
    return {
      'rotation': rotation,
      'position': {
        'lat': position.latitude,
        'long': position.longitude,
      },
      'iconId': iconId,
      'metaData': metaData,
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
      metaData: asType(map['metaData']),
    );
  }
}
