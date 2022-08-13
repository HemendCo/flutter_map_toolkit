import 'package:bloc/bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_toolkit/src/point_selection/point_selector_options.dart';

import '../core/debouncer.dart';
import '../core/marker_info.dart';

/// [updateStream] is stream of map changes
///
/// [options] is settings of controller and view
///
/// [mapState] is used to get center of the map
class CenterPointSelectorController extends Cubit<MapLocatorLayerState> {
  /// stream of map changes
  final Stream<void> updateStream;

  /// settings of controller and view
  final CenterPointSelectorOptions options;

  /// used to get bounds of the map
  final MapState mapState;

  /// [updateStream] is stream of map changes
  ///
  /// [options] is settings of controller and view
  ///
  /// [mapState] is used to get center of the map
  CenterPointSelectorController(
    this.updateStream,
    this.options,
    this.mapState,
  ) : super(
          MapLocatorLayerState(options.selectedIcon),
        ) {
    updateStream.listen(
      (_) {
        options.onPointSelected(
          PointSelectionEvent(
            state: PointSelectionState.none,
          ),
        );
        emit(MapLocatorLayerState(options.floatingIcon));
        Debounce.debounce('MapSelector', options.selectionDelay, () {
          options.onPointSelected(
            PointSelectionEvent(
              state: PointSelectionState.select,
              point: mapState.center,
            ),
          );
          emit(MapLocatorLayerState(options.selectedIcon));
        });
      },
    );
  }
}

class MapLocatorLayerState {
  /// marker view options
  final MarkerInfo view;
  MapLocatorLayerState(this.view);
}
