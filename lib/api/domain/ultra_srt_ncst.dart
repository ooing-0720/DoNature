// 단기예보API 단기실황
class UltraSrtNcst {
  String? T1H; // 기온, ℃
  String? RN1; // 1시간 강수량, mm
  String? REH; // 습도, %
  String? PTY; // 강수형태, 코드
  // String? SKY; // 하늘상태, 코드

  UltraSrtNcst({
    this.T1H,
    this.RN1,
    this.REH,
    this.PTY,
    // this.SKY,
  });

  factory UltraSrtNcst.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['item'];

    if (list[0]['obsrValue'] == "0") {
      list[0]['obsrValue'] = "없음";
    } else if (list[0]['obsrValue'] == "1") {
      list[0]['obsrValue'] = "비";
    } else if (list[0]['obsrValue'] == "2") {
      list[0]['obsrValue'] = "비/눈";
    } else if (list[0]['obsrValue'] == "3") {
      list[0]['obsrValue'] = "눈";
    } else if (list[0]['obsrValue'] == "5") {
      list[0]['obsrValue'] = "빗방울";
    } else if (list[0]['obsrValue'] == "6") {
      list[0]['obsrValue'] = "빗방울눈날림";
    } else if (list[0]['obsrValue'] == "7") {
      list[0]['obsrValue'] = "눈날림";
    }

    return UltraSrtNcst(
      T1H: list[3]['obsrValue'] as String,
      RN1: list[2]['obsrValue'] as String,
      REH: list[1]['obsrValue'] as String,
      PTY: list[0]['obsrValue'] as String,
      //   SKY: json["SKY"] as String,
    );
  }

/*
  factory UltraSrtNcst.fromJson(Map<String, dynamic> json) {
    // 강수형태 코드 변환
    if (json["category"] == "PTY") {
      if (list[0]['obsrValue'] == "0") {
        list[0]['obsrValue'] = "없음";
      } else if (list[0]['obsrValue'] == "1") {
        list[0]['obsrValue'] = "비";
      } else if (list[0]['obsrValue'] == "2") {
        list[0]['obsrValue'] = "비/눈";
      } else if (list[0]['obsrValue'] == "3") {
        list[0]['obsrValue'] = "눈";
      } else if (list[0]['obsrValue'] == "5") {
        list[0]['obsrValue'] = "빗방울";
      } else if (list[0]['obsrValue'] == "6") {
        list[0]['obsrValue'] = "빗방울눈날림";
      } else if (list[0]['obsrValue'] == "7") {
        list[0]['obsrValue'] = "눈날림";
      }
    }

/*
    // 하늘상태 코드 변환
    if (json["SKY"] == "1") {
      json["SKY"] = "맑음";
    } else if (json["SKY"] == "3") {
      json["SKY"] = "구름많음";
    } else if (json["SKY"] == "4") {
      json["SKY"] = "흐림";
    }
*/
    return UltraSrtNcst(
      T1H: json[3]["obsrValue"] as String,
      RN1: json[2]["obsrValue"] as String,
      REH: json[1]["obsrValue"] as String,
      PTY: list[0]['obsrValue'] as String,
      //   SKY: json["SKY"] as String,
    );
  }
  */
}
