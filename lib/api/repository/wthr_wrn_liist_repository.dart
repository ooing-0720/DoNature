import 'package:donation_nature/api/domain/wthr_wrn_list.dart';
import 'package:donation_nature/secret/api_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class WthrWrnListRepository {
  var serviceKey = wthrWrnServiceKey;

  Future<List<WthrWrnList>?> loadWthrWrnList() async {
    var url = Uri.parse(
        "http://apis.data.go.kr/1360000/WthrWrnInfoService/getPwnStatus?serviceKey=$serviceKey&numOfRows=10&pageNo=1&dataType=JSON");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final body = convert.utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResult = convert.json.decode(body);
      final jsonWthrWrnlist = jsonResult['response']['body']['items'];

      List<dynamic> list = jsonWthrWrnlist['item'];

      return list
          .map<WthrWrnList>((item) => WthrWrnList.fromJson(item))
          .toList();
    }
  }
}
