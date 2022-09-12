// 기상특보정보 조회서비스 API
class WthrWrnList {
  // 특보발효현황내용
  String? HWA; // 폭염주의보
  String? HWW; // 폭염경보
  String? HRA; // 호우주의보
  String? HRW; // 호우경보
  String? TYA; // 태풍주의보
  String? SWA; // 강풍주의보
  String? STA; // 풍랑주의보

  // 예비특보 발효현황
  List<Map<String, String>>? FHWA; // 폭염 예비특보 <일시, 장소>
  List<Map<String, String>>? FHRA; // 호우 예비특보
  List<Map<String, String>>? FTYA; // 태풍 예비특보
  List<Map<String, String>>? FSWA; // 강풍 예비특보
  List<Map<String, String>>? FSTA; // 풍랑 예비특보

  WthrWrnList({
    this.HWA,
    this.HWW,
    this.HRA,
    this.HRW,
    this.TYA,
    this.SWA,
    this.STA,
    this.FHWA,
    this.FHRA,
    this.FTYA,
    this.FSWA,
    this.FSTA,
  });

  factory WthrWrnList.fromJson(Map<String, dynamic> json) {
    //  t6: 특보발효현황내용
    List<String> t6 = json['t6'].substring(2).split('\r\no');
    final map = {
      for (var item in t6)
        if (item.contains(':'))
          item.split(':')[0].trim(): item.split(':')[1].trim(),
    };

    // t7: 예비특보 발효현황
    RegExp basicReg = RegExp(r"\([0-9]\)");
    List<String> t7 = json['t7'].substring(4).split(basicReg);

    final listMap = {
      for (var item in t7)
        item.split('\r\no')[0].trim(): [
          for (var map in item.split('\r\no'))
            {
              if (map.contains(':'))
                map.split(':')[0].trim(): map.split(':')[1].trim(),
            }
        ],
    };

    return WthrWrnList(
      HWA: map['폭염주의보'],
      HWW: map['폭염경보'],
      HRA: map['호우주의보'],
      HRW: map['호우경보'],
      TYA: map['태풍주의보'],
      SWA: map['강풍주의보'],
      STA: map['풍랑주의보'],
      FHWA: listMap['폭염 예비특보'],
      FHRA: listMap['호우 예비특보'],
      FTYA: listMap['태풍 예비특보'],
      FSWA: listMap['강풍 예비특보'],
      FSTA: listMap['풍랑 예비특보'],
    );
  }
}
