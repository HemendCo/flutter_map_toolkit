library flutter_map_toolkit.point_selector;

import 'package:flutter/material.dart' //
    show
        Center,
        GestureDetector,
        Widget;
import 'package:flutter_bloc/flutter_bloc.dart' //
    show
        BlocBuilder;
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
import 'package:flutter_map_toolkit/src/point_selection/point_selector_options.dart' //
    show
        CenterPointSelectorOptions,
        PointSelectorOptions;

import '../core/point_event_handler.dart' //
    show
        MapTapEventHandler;

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
  @override
  Widget createLayer(LayerOptions options, MapState mapState, Stream<void> stream) {
    if (options is PointSelectorOptions) {
      return _pointSelectorView(options);
    }
    if (options is CenterPointSelectorOptions) {
      return _centerPointSelector(stream, options, mapState);
    }
    throw Exception('options is not PointSelectorOptions');
  }

  Widget _centerPointSelector(Stream<void> stream, CenterPointSelectorOptions options, MapState mapState) {
    return BlocBuilder<CenterPointSelectorController, MapLocatorLayerState>(
      bloc: CenterPointSelectorController(stream, options, mapState),
      builder: (context, state) {
        return Center(child: state.view.view(context));
      },
    );
  }

  Widget _pointSelectorView(PointSelectorOptions options) {
    return BlocBuilder<MapTapEventHandler, LatLng?>(
      bloc: options.mapPointLink,
      builder: (context, state) {
        options.onPointSelected(state);
        return MarkerLayerWidget(
            options: MarkerLayerOptions(
          rebuild: options.rebuild,
          markers: [
            if (state != null)
              Marker(
                point: state,
                height: options.marker.viewSize.height,
                width: options.marker.viewSize.width,
                builder: (context) => GestureDetector(
                  onTap: options.removeOnTap ? () => options.mapPointLink.update(null) : null,
                  child: options.marker.view(context),
                ),
              ),
          ],
        ));
      },
    );
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is PointSelectorOptions || options is CenterPointSelectorOptions;
  }
}
