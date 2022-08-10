import 'package:flutter/material.dart';

class MarkerInfo {
  final Widget Function(BuildContext context) view;
  final Size viewSize;
  const MarkerInfo({
    required this.view,
    this.viewSize = const Size(35, 35),
  });
}
