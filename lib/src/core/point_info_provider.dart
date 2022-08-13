import 'package:flutter_map_toolkit/src/core/map_information_request_params.dart';
import 'package:flutter_map_toolkit/src/core/point_info.dart';

abstract class PointInfoProvider {
  /// get points for given [params.viewPort]
  Future<List<PointInfo>> getPoints([MapInformationRequestParams? params]);

  /// get points for given [params.viewPort] via stream
  Stream<List<PointInfo>> getPointsStream(
    Stream<MapInformationRequestParams?> params,
  ) async* {
    MapInformationRequestParams? lastParams;
    await for (final params in params) {
      if (params != null) {
        lastParams = params;
      }
      yield await getPoints(lastParams);
    }
  }
}

abstract class PointInfoStreamedProvider {
  void invoke();
  Stream<List<PointInfo>> getPointStream(
    Stream<MapInformationRequestParams?> params,
  );
}
