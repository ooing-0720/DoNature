import 'dart:convert' as convert;

import 'package:donation_nature/permission/permission_request.dart';
import 'package:donation_nature/secret/api_key.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MainAction {
  Future<Map<String, double>> getPosition() async {
    // original return type is Future<String>
    var permissionValue = PermissionRequest.determinePosition();
    var latitude, longitude;
    var nowPosition = {'latitude': 0.0, 'longitude': 0.0};

    if (permissionValue == true) {
      // 위치 권한 허용한 경우 -> 현재 위치
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      nowPosition['latitude'] = position.latitude;
      nowPosition['longitude'] = position.longitude;
    } else {
      // 위치 권한 거부한 경우 -> 임의 지정
      nowPosition['latitude'] = 37.566;
      nowPosition['longitude'] = 126.978;
    }
    print(nowPosition);
    return nowPosition;
  }

  Future<String> getAddress() async {
    var position = await getPosition();
    var latitude = position['latitude'];
    var longitude = position['longitude'];

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?sensor=false&language=ko&latlng=$latitude,$longitude&key=$geoCodingKey');

    final response = await http.get(url);
    final body = convert.utf8.decode(response.bodyBytes);
    Map<String, dynamic> jsonResult = convert.json.decode(body);
    final address = jsonResult['results'][0]['formatted_address'];

    return address;
  }
}
