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
class LiveMarkerOptionsWithRefreshRate extends LayerOptions with _MarkerInfoProvider {
  @override
  final Map<String, MarkerInfo> markers;

  @override
  final String defaultMarker;

  /// refresh rate of the layer
  final double initialRefreshRate;

  /// used to get [PointInfo]s for current viewport
  final PointInfoProvider pointsInfoProvider;

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
class LiveMarkerOptionsWithStream extends LayerOptions with _MarkerInfoProvider {
  @override
  final Map<String, MarkerInfo> markers;
  @override
  final String defaultMarker;

  /// used to get [PointInfo]s for current viewport
  final PointInfoStreamedProvider pointsInfoProvider;

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
  LiveMarkerOptionsWithStream({
    required this.pointsInfoProvider,
    required this.markers,
    String? defaultIcon,
  })  : defaultMarker = defaultIcon ?? markers.keys.last,
        assert(
          defaultIcon == null || markers.keys.contains(defaultIcon),
        );
}

mixin _MarkerInfoProvider implements _IMarkerInfoProvider {
  MarkerInfo getMarkerFor(String? key) {
    final element = markers[key] ?? markers[defaultMarker];
    if (element == null) {
      throw Exception(
        'Icon not found for key: $key or even the defaultIcon $defaultMarker',
      );
    }
    return element;
  }
}

abstract class _IMarkerInfoProvider {
  /// used to build widgets for each marker type accordingly.
  Map<String, MarkerInfo> get markers;

  /// is used when no markerId provided to [PointInfo] or the provided key
  /// is not presented in [markers]
  String get defaultMarker;
}
