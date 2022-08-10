import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_hemend/src/core/map_information_request_params.dart';
import 'package:flutter_map_hemend/src/core/point_info_provider.dart';

import '../core/point_info.dart';

abstract class LiveMarkersController implements Cubit<MultiMarkerLayerState> {}

/// this class updates markers with given [refreshRate] per seconds
///
/// [refreshRate] is the rate of updating data per seconds
///
/// [mapData] is used to find data for current viewport of map
///
/// [autoUpdate] is used to active autoUpdater by default
///
/// [pointInfoProvider] is used to get points information
class LiveMarkersControllerWithRefreshRate extends Cubit<MultiMarkerLayerState> implements LiveMarkersController {
  LiveMarkersControllerWithRefreshRate({
    required this.mapData,
    required this.pointInfoProvider,
    MultiMarkerLayerState? initialState,
    bool autoUpdate = true,
    double refreshRate = 1,
  })  : _refreshRate = refreshRate,
        _autoUpdate = autoUpdate,
        super(
          initialState ??
              MultiMarkerLayerState(
                [],
              ),
        ) {
    if (autoUpdate) {
      _registerAutoUpdater();
    }
  }
  double _refreshRate;

  double get refreshRate => _refreshRate;

  bool _autoUpdate;

  bool get autoUpdate => _autoUpdate;

  Timer? _internalTimer;
  PointInfoProvider pointInfoProvider;
  void activeAutoUpdater([double? updateRate]) {
    if (autoUpdate) {
      _internalTimer?.cancel();
    }
    _refreshRate = updateRate ?? _refreshRate;
    _autoUpdate = true;
    _registerAutoUpdater();
  }

  Future<void> _registerAutoUpdater() async {
    await update();
    _internalTimer = Timer(Duration(milliseconds: 1000 ~/ refreshRate), _registerAutoUpdater);
  }

  Future<void> update() async {
    if (!mapData.bounds().isValid) {
      return;
    }

    final state = await fetchData(MapInformationRequestParams(viewPort: mapData.bounds()));
    emit(state);
  }

  MultiMarkerControllerInfo mapData;

  Future<MultiMarkerLayerState> fetchData(MapInformationRequestParams params) async {
    final points = await pointInfoProvider.getPoints(params);
    return MultiMarkerLayerState(points);
  }
}

/// this class will not update predictably and only updates when new data
/// passed through [pointInfoProvider]'s Stream
///
/// although this class is not auto updater, it will connect map changes events
/// to [pointInfoProvider]'s Stream and if provider is handling map changes events
/// it will update accordingly
///
/// [mapData] is used to find data for current viewport of map and map events
///
/// [pointInfoProvider] is stream provider of points
class LiveMarkersControllerWithSocket extends Cubit<MultiMarkerLayerState> implements LiveMarkersController {
  LiveMarkersControllerWithSocket({
    required this.mapData,
    required this.pointInfoProvider,
    MultiMarkerLayerState? initialState,
  }) : super(
          initialState ??
              MultiMarkerLayerState(
                [],
              ),
        ) {
    _registerAutoUpdater();
  }
  MultiMarkerControllerInfoWithStream mapData;
  PointInfoStreamedProvider pointInfoProvider;

  void _registerAutoUpdater() {
    pointInfoProvider
        .getPointStream(mapData.stream.map((event) => MapInformationRequestParams(viewPort: mapData.bounds())))
        .listen(
      (event) {
        emit(
          MultiMarkerLayerState(
            event,
          ),
        );
      },
    );
  }
}

class MultiMarkerControllerInfo {
  final LatLngBounds Function() bounds;

  const MultiMarkerControllerInfo(
    this.bounds,
  );
}

class MultiMarkerControllerInfoWithStream {
  final LatLngBounds Function() bounds;
  final Stream<void> stream;
  const MultiMarkerControllerInfoWithStream(
    this.bounds,
    this.stream,
  );
}

class MultiMarkerLayerState {
  final List<PointInfo> markers;

  MultiMarkerLayerState(
    this.markers,
  );

  MultiMarkerLayerState copyWith({
    List<PointInfo>? markers,
  }) {
    return MultiMarkerLayerState(
      markers ?? this.markers,
    );
  }

  @override
  String toString() => 'CarsLayerState(cars: $markers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiMarkerLayerState && listEquals(other.markers, markers);
  }

  @override
  int get hashCode => markers.hashCode;
}
