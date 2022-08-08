import 'dart:convert';

import 'package:donation_nature/permission/position_permission.dart';
import 'package:donation_nature/secret/api_key.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Action {
  Future<String> getAddress() async {
    PositionPermission.determinePosition();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var latitude = position.latitude;
    var longitude = position.longitude;

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$geoCodingKey');
    final response = await http.get(url);

    return jsonDecode(response.body)['results'][0]['formatted_address'];
  }
}
