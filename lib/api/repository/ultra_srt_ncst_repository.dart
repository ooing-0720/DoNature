import 'dart:convert' as convert;
import 'package:donation_nature/API/domain/ultra_srt_ncst.dart';
import 'package:donation_nature/action/action.dart';
import 'package:donation_nature/action/conv_grid_gps.dart';
import 'package:donation_nature/secret/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:date_format/date_format.dart';

class UltraSrtNcstRepository {
  var serviceKey = ultraSrtNcstServiceKey;

  Future<dynamic?> loadUltraSrtNcst(Map<dynamic, dynamic> position) async {
    var latitude = position['latitude'];
    var longitude = position['longitude'];

    // 현재 위치 위도, 경도 값을 격자 x, y로 변환
    var grid = ConvGridGps.gpsToGRID(latitude!, longitude!);
    var nx = grid['x'];
    var ny = grid['y'];

    // 현재 날짜, 시간을 포맷에 맞게 변환
    var dateNow = DateTime.now();
    var dateStr = formatDate(dateNow, [yyyy, mm, dd]).toString();
    var timeStr;

    // API 동기화 시간에 맞게 설정
    if (dateNow.minute < 40) {
      timeStr = (dateNow.hour - 1).toString().padLeft(2, '0') + '00';
    } else {
      timeStr = formatDate(dateNow, [HH, '00']).toString();
    }

    var url = Uri.parse(
        "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst?serviceKey=$serviceKey&numOfRows=10&pageNo=1&dataType=JSON&base_date=$dateStr&base_time=$timeStr&nx=$nx&ny=$ny");

    var response = await http.get(url);

    // 정상적으로 데이터를 불러온 경우
    if (response.statusCode == 200) {
      final body = convert.utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResult = convert.json.decode(body);
      final jsonUltraSrtNcst = jsonResult['response']['body']['items'];

      return UltraSrtNcst.fromJson(jsonUltraSrtNcst);
    }
  }
}
