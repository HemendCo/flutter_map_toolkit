library flutter_map_toolkit.live_markers;

import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_toolkit/src/core/marker_info.dart';
import 'package:flutter_map_toolkit/src/core/point_info_provider.dart';

/// Options for [LiveMarkerPlugin] layer.
///
/// [LiveMarkerOptionsWithRefreshRate] is used for layers with refresh rate.
///
/// [markers] is used to build widgets for each marker type accordingly.
///
/// [getMarkerFor] is used to get marker for given marker id.
///
/// [defaultMarker] is used when no markerId provided to [PointInfo]
///
/// [initialRefreshRate] is starting refresh rate of the layer
///
/// [pointsInfoProvider] is used to get [PointInfo]s for current viewport
class LiveMarkerOptionsWithRefreshRate extends LayerOptions {
  final Map<String, MarkerInfo> markers;
  final String defaultMarker;
  final double initialRefreshRate;
  final PointInfoProvider pointsInfoProvider;

  MarkerInfo getMarkerFor(String? key) {
    final element = markers[key] ?? markers[defaultMarker];
    if (element == null) {
      throw Exception('Icon not found for key: $key or even the defaultIcon $defaultMarker');
    }
    return element;
  }

  LiveMarkerOptionsWithRefreshRate({
    this.initialRefreshRate = 1,
    required this.pointsInfoProvider,
    required this.markers,
    String? defaultIcon,
  })  : defaultMarker = defaultIcon ?? markers.keys.last,
        assert(
          defaultIcon == null || markers.keys.contains(defaultIcon),
        );
}

/// Options for [LiveMarkerPlugin] layer.
///
/// [LiveMarkerOptionsWithRefreshRate] is used for layers with refresh rate.
///
/// [markers] is used to build widgets for each marker type accordingly.
///
/// [getMarkerFor] is used to get marker for given marker id.
///
/// [defaultMarker] is used when no markerId provided to [PointInfo]
///
/// [pointsInfoProvider] is used to get [PointInfo]s for current viewport
class LiveMarkerOptionsWithSocket extends LayerOptions {
  final Map<String, MarkerInfo> markers;
  final String defaultMarker;
  final PointInfoStreamedProvider pointsInfoProvider;

  MarkerInfo getMarkerFor(String? key) {
    final element = markers[key] ?? markers[defaultMarker];
    if (element == null) {
      throw Exception('Icon not found for key: $key or even the defaultIcon $defaultMarker');
    }
    return element;
  }

  LiveMarkerOptionsWithSocket({
    required this.pointsInfoProvider,
    required this.markers,
    String? defaultIcon,
  })  : defaultMarker = defaultIcon ?? markers.keys.last,
        assert(
          defaultIcon == null || markers.keys.contains(defaultIcon),
        );
}
