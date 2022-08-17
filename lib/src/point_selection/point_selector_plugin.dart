library flutter_map_toolkit.point_selector;

import 'package:flutter/material.dart' //
    show
        Center,
        GestureDetector,
        SizedBox,
        Widget;
import 'package:flutter_bloc/flutter_bloc.dart' //
    show
        BlocBuilder,
        Cubit;
import 'package:flutter_map/plugin_api.dart' //
    show
        LayerOptions,
        MapPlugin,
        MapState,
        Marker,
        MarkerLayerOptions,
        MarkerLayerWidget;
import 'package:latlong2/latlong.dart' //
    show
        LatLng;

import 'package:flutter_map_toolkit/src/point_selection/point_selector_controller.dart' //
    show
        CenterPointSelectorController,
        MapLocatorLayerState;

import '../../flutter_map_toolkit.dart' //
    show
        CenterPointSelectorOptions,
        PointInfo,
        PointSelectionEvent,
        PointSelectionState,
        PointSelectorOptions;

/// A plugin that allows the user to select a point on the map.
///
/// behavior of the plugin is defined by the [LayerOptions] params.
///
/// [PointSelectorOptions] makes it possible for user to tap on the map and
/// select a point.
///
/// [CenterPointSelectorOptions] makes it possible for user to select the point
/// without tapping on the map it will be center of the viewport.
class PointSelectorPlugin extends MapPlugin {
  /// A plugin that allows the user to select a point on the map.
  ///
  /// behavior of the plugin is defined by the [LayerOptions] params.
  ///
  /// [PointSelectorOptions] makes it possible for user to tap on the map and
  /// select a point.
  ///
  /// [CenterPointSelectorOptions] makes it possible for user to select the point
  /// without tapping on the map it will be center of the viewport.
  PointSelectorPlugin();
  @override
  Widget createLayer(
    LayerOptions options,
    MapState mapState,
    Stream<void> stream,
  ) {
    if (options is PointSelectorOptions) {
      return _pointSelectorView(options);
    }
    if (options is CenterPointSelectorOptions) {
      return _centerPointSelector(stream, options, mapState);
    }
    throw Exception('options is not PointSelectorOptions');
  }

  Widget _centerPointSelector(
    Stream<void> stream,
    CenterPointSelectorOptions options,
    MapState mapState,
  ) {
    return BlocBuilder<CenterPointSelectorController, MapLocatorLayerState>(
      bloc: CenterPointSelectorController(stream, options, mapState),
      builder: (context, state) {
        final point = PointInfo(
          rotation: 0,
          position: mapState.center,
          iconId: null,
        );
        return Center(child: state.view.view(context, point));
      },
    );
  }

  _PointSelectorHandler? _handler;
  Widget _pointSelectorView(PointSelectorOptions options) {
    _handler = _handler ??
        _PointSelectorHandler(
          tapEvents: options.mapEventLink.stream,
          listener: options.onPointSelected,
        );

    return BlocBuilder<_PointSelectorHandler, PointSelectionEvent?>(
      bloc: _handler,
      builder: (context, state) {
        if (state == null) {
          return const SizedBox();
        }
        return MarkerLayerWidget(
            options: MarkerLayerOptions(
          rebuild: options.rebuild,
          markers: [
            if (state.state == PointSelectionState.select)
              Marker(
                point: state.point!,
                height: options.marker.viewSize.height,
                width: options.marker.viewSize.width,
                builder: (context) => GestureDetector(
                  onTap: options.removeOnTap
                      ? () {
                          _handler?.set(
                            PointSelectionEvent(
                              state: PointSelectionState.remove,
                              point: state.point,
                            ),
                          );
                        }
                      : null,
                  child: options.marker
                      .view(context, PointInfo(iconId: null, position: state.point ?? LatLng(0, 0), rotation: 0)),
                ),
              ),
          ],
        ));
      },
    );
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is PointSelectorOptions || //
        options is CenterPointSelectorOptions;
  }
}

class _PointSelectorHandler extends Cubit<PointSelectionEvent?> {
  _PointSelectorHandler({
    required this.tapEvents,
    required this.listener,
  }) : super(null) {
    tapEvents.listen((point) {
      set(
        PointSelectionEvent(state: PointSelectionState.select, point: point),
      );
    });
  }
  final void Function(PointSelectionEvent) listener;
  final Stream<LatLng?> tapEvents;
  void set(PointSelectionEvent event) {
    emit(event);
    listener(event);
  }
}
