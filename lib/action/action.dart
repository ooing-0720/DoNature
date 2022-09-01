import 'dart:convert' as convert;

import 'package:donation_nature/permission/permission_request.dart';
import 'package:donation_nature/secret/api_key.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MainAction {
  Future<String> getAddress() async {
    // original return type is Future<String>
    PermissionRequest.determinePosition();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var latitude = position.latitude;
    var longitude = position.longitude;
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?sensor=false&language=ko&latlng=$latitude,$longitude&key=$geoCodingKey');

    final response = await http.get(url);
    final body = convert.utf8.decode(response.bodyBytes);
    Map<String, dynamic> jsonResult = convert.json.decode(body);
    final address = jsonResult['results'][0]['formatted_address'];

    return address;
  }
}
