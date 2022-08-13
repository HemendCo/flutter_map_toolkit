library flutter_map_toolkit.point_selector;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_map_toolkit/src/core/marker_info.dart';

import '../core/map_tap_event_handler.dart';

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
/// [mapEventLink] is a [Cubit] that will be used to link the marker to the
class PointSelectorOptions extends LayerOptions {
  /// link of user interactions with map
  final MapTapEventHandler mapEventLink;

  /// marker view on the map
  final MarkerInfo marker;

  /// if remove [removeOnTap] is true, the [PointSelectorOptions] must be last
  /// in the list of [LayerOptions], this is due a limitation of
  /// `flutter hittests`. this will happen if another layer adds a marker over
  /// the marker that is being added by this plugin.
  final bool removeOnTap;

  /// callback that will be called when user selects a point or remove the marker
  final void Function(PointSelectionEvent point) onPointSelected;

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
  /// [mapEventLink] is a [Cubit] that will be used to link the marker to the
  PointSelectorOptions({
    required this.mapEventLink,
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
  /// marker view when user stopped moving for [selectionDelay]
  final MarkerInfo selectedIcon;

  /// marker view when user is moving the map
  final MarkerInfo floatingIcon;

  /// delay before the point state is changed to selected
  final Duration selectionDelay;

  /// callback that will be called when user selects a point
  final void Function(PointSelectionEvent? point) onPointSelected;

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

/// point selection state
enum PointSelectionState {
  /// point is not selected
  none,

  /// point is selected
  select,

  /// point is removed
  remove,
}

/// event params of point selection callback
class PointSelectionEvent {
  /// effective point of the event
  final LatLng? point;

  /// state of the event
  final PointSelectionState state;

  /// params of the event
  ///
  /// - [point] is nullable but [state] is not
  /// - [point] always carry a value if [state] is not [PointSelectionState.none]
  ///   this condition is checked with assertion in debug mode only
  const PointSelectionEvent({
    this.point,
    required this.state,
  }) : assert(
          state == PointSelectionState.none || point != null,
        );

  @override
  bool operator ==(Object other) {
    return other is PointSelectionEvent && //
        other.point?.latitude == point?.latitude && //
        other.point?.longitude == point?.longitude && //
        other.state == state;
  }

  @override
  int get hashCode => point.hashCode ^ state.hashCode;
}
