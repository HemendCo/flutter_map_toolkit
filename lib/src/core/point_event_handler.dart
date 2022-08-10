import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart';

class MapTapEventHandler extends Cubit<LatLng?> {
  MapTapEventHandler([
    LatLng? initialState,
  ]) : super(
          initialState,
        );

  void update(LatLng? newPoint) {
    emit(newPoint);
  }

  bool get hasPoint => state != null;
  LatLng? get point => state;
}
