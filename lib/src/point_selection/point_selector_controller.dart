import 'package:bloc/bloc.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_hemend/src/point_selection/point_selector_options.dart';

import '../core/debouncer.dart';
import '../core/marker_info.dart';

/// [updatePoint] is stream of map changes
///
/// [options] is settings of controller and view
///
/// [mapState] is used to get center of the map
class CenterPointSelectorController extends Cubit<MapLocatorLayerState> {
  final Stream<void> updatePoint;
  final CenterPointSelectorOptions options;
  final MapState mapState;

  CenterPointSelectorController(
    this.updatePoint,
    this.options,
    this.mapState,
  ) : super(
          MapLocatorLayerState(options.selectedIcon),
        ) {
    updatePoint.listen(
      (_) {
        emit(MapLocatorLayerState(options.floatingIcon));
        Debounce.debounce('MapSelector', options.selectionDelay, () {
          options.onPointSelected(mapState.center);
          emit(MapLocatorLayerState(options.selectedIcon));
        });
      },
    );
  }
}

class MapLocatorLayerState {
  final MarkerInfo view;

  MapLocatorLayerState(this.view);
}
