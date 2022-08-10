import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_hemend/src/live_markers/live_markers_controller.dart';
import 'package:latlong2/latlong.dart';

import 'live_markers_options.dart';

export 'package:flutter_map_hemend/src/core/marker_info.dart';

class LiveMarkerPlugin extends MapPlugin {
  LiveMarkersController? _controller;

  @override
  Widget createLayer(LayerOptions options, MapState mapState, Stream<void> stream) {
    if (options is LiveMarkerOptionsWithRefreshRate) {
      _controller ??= LiveMarkersControllerWithRefreshRate(
        pointInfoProvider: options.pointsInfoProvider,
        refreshRate: options.initialRefreshRate,
        mapData: MultiMarkerControllerInfo(
          () => mapState.bounds,
        ),
      );
      return BlocBuilder<LiveMarkersController, MultiMarkerLayerState>(
          bloc: _controller,
          builder: (context, state) {
            return MarkerLayerWidget(
              options: MarkerLayerOptions(
                markers: [
                  ...state.markers.map(
                    (e) {
                      final marker = options.getMarkerFor(e.iconId);
                      return Marker(
                        height: marker.viewSize.height,
                        width: marker.viewSize.width,
                        builder: (context) => FittedBox(
                          child: AnimatedRotation(
                            duration: const Duration(milliseconds: 500),
                            turns: e.rotation / pi,
                            alignment: Alignment.center,
                            // origin: Offset.zero,
                            child: marker.view(context),
                          ),
                        ),
                        point: e.position,
                      );
                    },
                  ),
                ],
              ),
            );
          });
    }

    if (options is LiveMarkerOptionsWithSocket) {
      _controller ??= LiveMarkersControllerWithSocket(
        pointInfoProvider: options.pointsInfoProvider,
        mapData: MultiMarkerControllerInfoWithStream(
          () => mapState.bounds,
          stream,
        ),
      );

      return BlocBuilder<LiveMarkersController, MultiMarkerLayerState>(
          bloc: _controller,
          builder: (context, state) {
            return MarkerLayerWidget(
              options: MarkerLayerOptions(
                markers: [
                  ...state.markers.map(
                    (e) {
                      final marker = options.getMarkerFor(e.iconId ?? options.defaultMarker);
                      return Marker(
                        height: marker.viewSize.height,
                        width: marker.viewSize.width,
                        builder: (context) => FittedBox(
                          child: AnimatedRotation(
                            duration: const Duration(milliseconds: 500),
                            turns: e.rotation / pi,
                            alignment: Alignment.center,
                            child: marker.view(context),
                          ),
                        ),
                        point: e.position,
                      );
                    },
                  ),
                ],
              ),
            );
          });
    }

    throw Exception('options is not LiveMarkersOptions');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is LiveMarkerOptionsWithRefreshRate || options is LiveMarkerOptionsWithSocket;
  }
}
