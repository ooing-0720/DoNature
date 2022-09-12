import 'dart:ui';
import 'package:donation_nature/screen/disaster_list.dart';
import 'package:donation_nature/API/repository/ultra_srt_ncst_repository.dart';
import 'package:donation_nature/API/repository/wthr_wrn_liist_repository.dart';

class WthrReport {
  Future<List<String>> getWthrInfo(Map<dynamic, dynamic> position) async {
    UltraSrtNcstRepository ultraSrtNcstRepository = UltraSrtNcstRepository();
    var ultraSrtNcst = await ultraSrtNcstRepository.loadUltraSrtNcst(position);

    List<String> WthrInfoList = [
      '${ultraSrtNcst?.T1H}',
      '${ultraSrtNcst?.REH}',
      '${ultraSrtNcst?.RN1}',
      '${ultraSrtNcst?.PTY}'
    ];

    return WthrInfoList;
  }

  Future<List<String>> getWeatherReport() async {
    //PermissionRequest.determinePosition();

    WthrWrnListRepository wthrWrnListRepository = WthrWrnListRepository();
    var wthrWrnList = await wthrWrnListRepository.loadWthrWrnList();

    List<String> reportList = [
      '${wthrWrnList?[0].FHWA} ${wthrWrnList?[0].HWA} ${wthrWrnList?[0].HWW}',
      '${wthrWrnList?[0].FHRA} ${wthrWrnList?[0].HRA}',
      '${wthrWrnList?[0].FTYA} ${wthrWrnList?[0].TYA}',
      '${wthrWrnList?[0].FSWA}  ${wthrWrnList?[0].SWA}',
      '${wthrWrnList?[0].FSTA}  ${wthrWrnList?[0].STA}'
    ];

    return reportList;
    // 폭염, 호우, 태풍, 강풍, 풍랑
  }

  List<Color>? classifyLocation(String str) {
    List<Color>? colors = [
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0),
      Color.fromARGB(255, 223, 223, 223).withOpacity(0.0)
    ];

    for (int i = 0; i < location.length; i++) {
      if (str.contains(location[i])) {
        colors[i] = Color(0xff416E5C);
      } else {
        colors[i] = Color.fromARGB(255, 223, 223, 223).withOpacity(0.0);
      }
    }
    return colors;
  }
}
