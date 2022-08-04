import 'package:geolocator/geolocator.dart';

// 위치 정보 사용 허가 여부
class PositionPermission {
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location Services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied.");
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error("Location permissions are permanently denined.");
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
