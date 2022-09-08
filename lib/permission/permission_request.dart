// import 'dart:html';

import 'package:geolocator/geolocator.dart';
// import 'package:permission/permission.dart' as permission;
import 'package:permission_handler/permission_handler.dart';

// 권한 요청 클래스
class PermissionRequest {
  // 위치 정보 사용 허가 여부
  static Future<bool> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
      if (permission == LocationPermission.deniedForever) {
        return false;
      }
    }

    return true;
  }

  // 갤러리, 파일 접근 권한
  static void getStoragePermission() async {
    await Permission.storage.request();
  }

  // 카메라 권한
  static void getCameraPermission() async {
    await Permission.camera.request();
  }
}
