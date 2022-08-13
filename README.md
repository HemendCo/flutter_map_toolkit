this package contains plugins for the [`flutter_map`](https://pub.dev/packages/flutter_map) package.

## Installation

- you must add plugins to `FlutterMap`

```Dart
final plugins = [
    PointSelectorPlugin(),
    DirectionsPlugin(),
    LiveMarkerPlugin(),
  ];
```

- then set `FlutterMap` widget's plugins property

```Dart
FlutterMap(
    plugins:plugins, 
    ...,
    )
```

- now you can use plugins in your app using `FlutterMap`'s layers property

```Dart
FlutterMap(
    plugins:plugins, 
    layers:[
        TileLayerOptions(
                ...,
            ),
        LiveMarkerOptionsWithStream(
                ...
            ),
        ...,
    ]
    ...,
    )
```

## Plugins

### Point Selector Plugin

- contains two modes

> Center point selector
>
>- Select a single point on the map
> Tap Point Selector
>
> ![center_point_selector](https://raw.githubusercontent.com/HemendCo/flutter_map_toolkit/main/.github_assets/center_point_selector.png)
>

> Tap Point Selector
>
>- select a point when user taps on the map
>
> ![tap_point_selector](https://raw.githubusercontent.com/HemendCo/flutter_map_toolkit/main/.github_assets/tap_point_selector.png)

### Live Markers Plugin

>- Live marker with refresh rate
>
> using a `LiveMarkerOptionsWithRefreshRate` to set the refresh rate and the markers info provider
>

>- Live marker with stream
>
> using a `LiveMarkerOptionsWithStream` and `PointInfoStreamedProvider`
>
>- this plugin will refresh the markers when the stream is updated
>
>- this plugin will send a new `MapInformationRequestParams` to the provider when the user interacted with the map

**there is no default provider for this plugin so you must implement `PointInfoProvider` or `PointInfoStreamedProvider` inside your code**

### Directions Plugin (WIP)

> ![center_point_selector](https://raw.githubusercontent.com/HemendCo/flutter_map_toolkit/main/.github_assets/directions.png)

this plugin can be used to draw routes on the map
and can be controlled with a `DirectionsLayerController`

**this plugin comes with a `MapboxDirectionProvider`**

>- this will use mapbox api to get directions for given waypoints

```Dart
DirectionsLayerOptions(
  provider: mapboxProvider,
  controller: directionController,
  loadingBuilder: (context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  },
  ...,
)
```
