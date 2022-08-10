import 'package:flutter_map_hemend/src/core/map_information_request_params.dart';
import 'package:flutter_map_hemend/src/core/point_info.dart';

abstract class PointInfoProvider {
  Future<List<PointInfo>> getPoints([MapInformationRequestParams? params]);
  Stream<List<PointInfo>> getPointsStream(Stream<MapInformationRequestParams?> params) async* {
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
  Stream<List<PointInfo>> getPointStream(Stream<MapInformationRequestParams?> params);
}
