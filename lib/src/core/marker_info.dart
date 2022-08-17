import 'package:flutter/material.dart';
import 'package:flutter_map_toolkit/flutter_map_toolkit.dart';

class MarkerInfo {
  final Widget Function(BuildContext context, PointInfo point) view;
  final Size viewSize;
  const MarkerInfo({
    required this.view,
    this.viewSize = const Size(35, 35),
  });
}
