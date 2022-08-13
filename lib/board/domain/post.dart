import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

class Post {
  String? title;
  String? writer;
  Timestamp? date;
  bool isDone = false; // 나눔/받기 완료되었는지
  String? content;
  String? locationDo; // 도
  String? locationSi; // 시
  String? locationGu; // 구
  String? locationDong; // 동
  String? tagDisaster; // 재난 태그
  String? tagMore; // 그 외 태그
  DocumentReference? reference; // Firebase에서 document의 위치

  Post({
    this.title,
    this.writer,
    this.date,
    this.content,
    this.locationDo,
    this.locationSi,
    this.locationGu,
    this.locationDong,
    this.tagDisaster,
    this.tagMore,
    this.reference,
  });

  // Firebase -> Dart(Flutter)
  // READ
  Post.fromJson(dynamic json, this.reference) {
    title = json['title'];
    writer = json['writer'];
    date = json['date']; // format 맞게 출력되는지 확인해야함
    content = json['content'];
    locationDo = json['location_do'];
    locationSi = json['location_si'];
    locationGu = json['location_gu'];
    locationDong = json['location_dong'];
    tagDisaster = json['tag_disaster'];
    tagMore = json['tag_more'];
  }

  Post.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  // Dart(Flutter) -> Firebase
  // CREATE
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['writer'] = writer;
    map['date'] = date;
    map['content'] = content;
    map['location_do'] = locationDo;
    map['location_si'] = locationSi;
    map['location_gu'] = locationGu;
    map['location_dong'] = locationDong;
    map['tag_disaster'] = tagDisaster;
    map['tag_more'] = tagMore;

    return map;
  }
}
