library flutter_map_toolkit.directions;
// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/map/map.dart';
import 'package:latlong2/latlong.dart';

import 'direction_provider.dart';

class DirectionsPlugin extends MapPlugin {
  @override
  Widget createLayer(
    LayerOptions options,
    MapState mapState,
    Stream<void> stream,
  ) {
    if (options is DirectionsLayerOptions) {
      return _DirectionsLayer(
        options: options,
      );
    }
    return Container();
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is DirectionsLayerOptions;
  }
}

class _DirectionsLayer extends StatelessWidget {
  const _DirectionsLayer({
    required this.options,
  });
  final DirectionsLayerOptions options;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DirectionsLayerController, _IDirectionCommand>(
      bloc: options.controller,
      builder: (context, command) {
        if (command is _NoCommands || command is _RemoveDirectionCommand) {
          return const SizedBox();
        }
        if (command is _RequestDirectionCommand) {
          return FutureBuilder<DirectionProviderResponse>(
            future: options.provider.getDirections(
              DirectionsRequest(command.points),
            ),
            builder: (context, snapshot) {
              if (options.useCachedRoute) {
                options.controller._saveLastPoints(
                  snapshot.data?.path ?? options.controller.lastPath,
                );
              } else {
                options.controller._saveLastPoints(snapshot.data?.path);
              }
              if (snapshot.connectionState == ConnectionState.done || //
                  options.controller.lastPath != null) {
                if (options.controller.lastPath != null) {
                  return PolylineLayerWidget(
                    options: PolylineLayerOptions(polylines: [
                      Polyline(
                        points: options.controller.lastPath ?? [],
                        strokeWidth: options.pathWidth,
                        color: options.pathColor,
                        borderColor: options.pathStrokeColor,
                        borderStrokeWidth: options.strokeWidth,
                      ),
                    ]),
                  );
                }

                return options.errorBuilder?.call(context, snapshot.error) ?? //
                    const SizedBox();
              }
              return (options.loadingBuilder ?? //
                  (_) => const SizedBox())(context);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

/// [provider] is a [DirectionsProvider] that will be used to get the directions
/// of selected waypoints
///
/// [controller] is a [DirectionsLayerController] that will be used to manage
/// the plugin's state and will be used to handle route requests
///
/// [useCachedRoute] is a boolean that will be used to determine if the plugin
/// should use the cached route or not (if it's true, the plugin will use the
/// last cached route, if it's false, the plugin will use loading builder)
///
/// [errorBuilder] used to build the error widget when the plugin is in error
///
/// [loadingBuilder] used to build the loading widget when the plugin is in load
/// state
///
/// [pathColor] is the color of the path
///
/// [pathStrokeColor] is the color of the path's stroke
///
/// [strokeWidth] is the width of the path's stroke
///
/// [pathWidth] is the width of the path
///
/// [pathGradientColors] is the gradient colors of the path
///
/// [pathGradientStops] is the gradient stops of the path
class DirectionsLayerOptions extends LayerOptions {
  /// loading widget builder
  final Widget Function(BuildContext context)? loadingBuilder;

  /// error widget builder can be null if you want to capture error only
  final Widget? Function(BuildContext context, Object? error)? errorBuilder;

  /// controller of direction layer
  final DirectionsLayerController controller;

  /// direction information provider
  final DirectionsProvider provider;

  /// [solid] color of the path
  final Color pathColor;

  /// width of the path
  final double pathWidth;

  /// [solid] color of the path's stroke
  final Color pathStrokeColor;

  ///  width of the path's stroke
  final double strokeWidth;

  /// [gradient] colors of the path
  final List<Color>? pathGradientColors;

  /// [gradient] stops of the path
  final List<double>? pathGradientStops;

  /// when requesting for new route if this is true, the plugin will not remove
  /// the path from the map and show loading instead it will update the path
  /// after getting the new route
  final bool useCachedRoute;

  /// [provider] is a [DirectionsProvider] that will be used to get the directions
  /// of selected waypoints
  ///
  /// [controller] is a [DirectionsLayerController] that will be used to manage
  /// the plugin's state and will be used to handle route requests
  ///
  /// [useCachedRoute] is a boolean that will be used to determine if the plugin
  /// should use the cached route or not (if it's true, the plugin will use the
  /// last cached route, if it's false, the plugin will use loading builder)
  ///
  /// [errorBuilder] used to build the error widget when the plugin is in error
  ///
  /// [loadingBuilder] used to build the loading widget when the plugin is in load
  /// state
  ///
  /// [pathColor] is the color of the path
  ///
  /// [pathStrokeColor] is the color of the path's stroke
  ///
  /// [strokeWidth] is the width of the path's stroke
  ///
  /// [pathWidth] is the width of the path
  ///
  /// [pathGradientColors] is the gradient colors of the path
  ///
  /// [pathGradientStops] is the gradient stops of the path
  DirectionsLayerOptions({
    required this.provider,
    required this.controller,
    this.useCachedRoute = false,
    this.errorBuilder,
    this.loadingBuilder,
    this.pathColor = Colors.blue,
    this.pathStrokeColor = Colors.black,
    this.strokeWidth = 0,
    this.pathWidth = 5,
    this.pathGradientColors,
    this.pathGradientStops,
  });
}

/// [removeDirection] remove path from the map
///
/// [requestDirections] request new path from the provider
class DirectionsLayerController extends Cubit<_IDirectionCommand> {
  /// [removeDirection] remove path from the map
  ///
  /// [requestDirections] request new path from the provider
  DirectionsLayerController() : super(_IDirectionCommand.noCommands);

  /// remove path from the map
  void removeDirection() {
    emit(_IDirectionCommand.removeCommand);
  }

  /// request new path from the provider using [points] as waypoints
  void requestDirections(List<LatLng> points) {
    emit(_IDirectionCommand.requestDirectionFor(points));
  }

  List<LatLng>? _lastPath;

  /// get last route
  List<LatLng>? get lastPath => _lastPath;

  void _saveLastPoints(List<LatLng>? points) => _lastPath = points;
}

class _IDirectionCommand {
  const _IDirectionCommand();
  static const noCommands = _NoCommands();
  static const removeCommand = _RemoveDirectionCommand();
  // ignore: prefer_constructors_over_static_methods
  static _RequestDirectionCommand requestDirectionFor(List<LatLng> points) => //
      _RequestDirectionCommand(points);
}

class _NoCommands implements _IDirectionCommand {
  const _NoCommands() : super();
}

class _RemoveDirectionCommand implements _IDirectionCommand {
  const _RemoveDirectionCommand() : super();
}

class _RequestDirectionCommand implements _IDirectionCommand {
  final List<LatLng> points;

  const _RequestDirectionCommand(this.points);
}
