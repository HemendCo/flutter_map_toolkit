import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_hemend/src/point_selection/point_selector_controller.dart';

import 'package:flutter_map_hemend/src/point_selection/point_selector_options.dart';

import 'package:latlong2/latlong.dart';

import '../core/point_event_handler.dart';

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
