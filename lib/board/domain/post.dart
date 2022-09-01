import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  String? title;
  String? userEmail;
  String? writer;
  Timestamp? date;
  bool isDone = false; // 나눔/받기 완료되었는지
  String? content;
  String? imageUrl; // firestore에 저장될 이미지 url
  String? locationSiDo; // 시/도
  String? locationGuGunSi; // 구/군/시
  String? tagDisaster; // 재난 태그
  String? tagMore; // 그 외 태그
  List<dynamic>? likeUsers; // 관심 누른 유저 email 배열
  final DocumentReference? reference; // Firebase에서 document의 위치

  Post({
    this.title,
    this.userEmail,
    this.writer,
    this.date,
    this.content,
    this.imageUrl,
    this.locationSiDo,
    this.locationGuGunSi,
    this.tagDisaster,
    this.tagMore,
    this.reference,
  });

  // Firebase -> Dart(Flutter)
  // READ
  Post.fromJson(dynamic json, this.reference) {
    title = json['title'];
    userEmail = json['user_email'];
    writer = json['writer'];
    date = json['date']; // format 맞게 출력되는지 확인해야함
    content = json['content'];
    imageUrl = json['image_url'];
    locationSiDo = json['location_si/do'];
    locationGuGunSi = json['location_gu/gun/si'];
    tagDisaster = json['tag_disaster'];
    tagMore = json['tag_more'];
    likeUsers = json['like_users'];
  }

  Post.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  Post.fromSnapShot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  // Dart(Flutter) -> Firebase
  // CREATE
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['user_email'] = userEmail;
    map['writer'] = writer;
    map['date'] = date;
    map['content'] = content;
    map['image_url'] = imageUrl;
    map['location_si/do'] = locationSiDo;
    map['location_gu/gun/si'] = locationGuGunSi;
    map['tag_disaster'] = tagDisaster;
    map['tag_more'] = tagMore;
    map['like_users'] = likeUsers ?? [];

    return map;
  }
}
