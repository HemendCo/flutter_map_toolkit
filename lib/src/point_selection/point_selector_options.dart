library flutter_map_toolkit.point_selector;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_map_toolkit/src/core/marker_info.dart';

import '../core/point_event_handler.dart';

/// this class use [MapTapEventHandler] to handle tap events
///
/// you need to manually add this event handler into the `flutter_map` widget
///
/// [marker] is point marker that will be displayed on the map
///
/// [removeOnTap] if true, the marker will be removed when user tap on marker
///
/// [onPointSelected] callback that will be called when user selects a point or
/// remove the marker
///
/// [mapPointLink] is a [Cubit] that will be used to link the marker to the
class PointSelectorOptions extends LayerOptions {
  final MapTapEventHandler mapPointLink;
  final MarkerInfo marker;
  final bool removeOnTap;
  final void Function(LatLng? point) onPointSelected;
  PointSelectorOptions({
    required this.mapPointLink,
    required this.onPointSelected,
    required this.marker,
    this.removeOnTap = true,
  });
}

/// this class use internal map events to select the point so no
/// manual handling is needed
///
/// [selectedIcon] is marker that will be displayed on the map when user
/// selects a point
///
/// [floatingIcon] is marker that will be displayed on the map when user is
/// moving the map
///
/// [selectionDelay] is the delay before the point is selected
///
/// [onPointSelected] callback that will be called when user selects a point
class CenterPointSelectorOptions extends LayerOptions {
  final MarkerInfo selectedIcon;
  final MarkerInfo floatingIcon;
  final Duration selectionDelay;
  final void Function(LatLng? point) onPointSelected;
  CenterPointSelectorOptions({
    super.key,
    MarkerInfo? selectedIcon,
    MarkerInfo? floatingIcon,
    required this.onPointSelected,
    this.selectionDelay = const Duration(milliseconds: 300),
    super.rebuild,
  })  : selectedIcon = selectedIcon ??
            MarkerInfo(
              view: (_) => const Icon(Icons.gps_fixed),
            ),
        floatingIcon = selectedIcon ??
            MarkerInfo(
              view: (_) => const Icon(Icons.gps_not_fixed),
            );
}
