import 'dart:ui';
import 'package:donation_nature/API/domain/ultra_srt_ncst.dart';
import 'package:donation_nature/API/repository/ultra_srt_ncst_repository.dart';
import 'package:donation_nature/API/repository/wthr_wrn_liist_repository.dart';
import 'package:donation_nature/permission/permission_request.dart';

class WthrReport {
  final List<String> location = [
    '서울',
    '부산',
    '대구',
    '인천',
    '광주',
    '대전',
    '울산',
    '경기도',
    '강원도',
    '충청북도',
    '충청남도',
    '전라북도',
    '전라남도',
    '경상북도',
    '경상남도',
    '제주도',
    '세종'
  ];

  Future<String?> getTemp() async {
    PermissionRequest.determinePosition();

    UltraSrtNcstRepository ultraSrtNcstRepository = UltraSrtNcstRepository();
    var ultraSrtNcst = await ultraSrtNcstRepository.loadUltraSrtNcst();

    return ultraSrtNcst!.T1H;
  }

  Future<String?> getRainfall() async {
    PermissionRequest.determinePosition();

    UltraSrtNcstRepository ultraSrtNcstRepository = UltraSrtNcstRepository();
    var ultraSrtNcst = await ultraSrtNcstRepository.loadUltraSrtNcst();

    return ultraSrtNcst!.T1H;
  }

  Future<String?> getHumidity() async {
    PermissionRequest.determinePosition();

    UltraSrtNcstRepository ultraSrtNcstRepository = UltraSrtNcstRepository();
    UltraSrtNcst? ultraSrtNcst =
        await ultraSrtNcstRepository.loadUltraSrtNcst();

    return ultraSrtNcst!.T1H;
  }

  Future<List<String>> getWeatherReport() async {
    PermissionRequest.determinePosition();

    WthrWrnListRepository wthrWrnListRepository = WthrWrnListRepository();
    var wthrWrnList = await wthrWrnListRepository.loadWthrWrnList();

    List<String> reportList = [
      '${wthrWrnList?[0].FHWA} ${wthrWrnList?[0].HWA} ${wthrWrnList?[0].HWW}d',
      '${wthrWrnList?[0].FHRA} ${wthrWrnList?[0].HRA}',
      '${wthrWrnList?[0].FTYA} ${wthrWrnList?[0].TYA}',
      '${wthrWrnList?[0].FSWA}  ${wthrWrnList?[0].SWA}',
      '${wthrWrnList?[0].FSTA}  ${wthrWrnList?[0].STA}'
    ];

    return reportList;
    // 폭염, 호우, 태풍, 강풍, 풍랑
  }

  List<Color>? ClassifyLocation(String str) {
    List<Color>? colors = [
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223),
      Color.fromARGB(255, 223, 223, 223)
    ];

    for (int i = 0; i < location.length; i++) {
      if (str.contains(location[i])) {
        colors[i] = Color(0xff416E5C);
      } else {
        colors[i] = Color.fromARGB(255, 223, 223, 223);
      }
    }
    return colors;
  }
}
