import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final DocumentReference? reference;
  String? title;
  String? writerUID;
  String? writer;
  Timestamp? date;
  String? imageUrl;
  String? locationSiDo;
  String? locationGuGunSi;
  String? item;
  String? itemCnt;
  String? content;
  String? disaster;
  List<dynamic>? likeUsers;
  Map<dynamic, dynamic>? chatUsers;
  bool isDone = false;
  int? share; // 0: give, 1: take, 2: inform

  Post({
    this.reference,
    this.share,
  });

  Post.fromJson(dynamic json, this.reference) {
    title = json['title'];
    writerUID = json['writer_uid'];
    writer = json['writer'];
    date = json['date'];
    imageUrl = json['image_url'];
    locationSiDo = json['location_sido'];
    locationGuGunSi = json['location_gugunsi'];
    item = json['item'];
    itemCnt = json['item_cnt'];
    content = json['content'];
    disaster = json['disaster'];
    likeUsers = json['like_users'];
    chatUsers = json['chat_users'];
    isDone = json['is_done'];
    share = json['share'];
  }

  Post.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['writer_uid'] = writerUID;
    map['writer'] = writer;
    map['date'] = date;
    map['image_url'] = imageUrl;
    map['location_sido'] = locationSiDo;
    map['location_gugunsi'] = locationGuGunSi;
    map['item'] = item;
    map['item_cnt'] = itemCnt;
    map['content'] = content;
    map['disaster'] = disaster;
    map['like_users'] = likeUsers ?? [];
    map['chat_users'] = chatUsers ?? {};
    map['is_done'] = isDone;
    map['share'] = share;

    return map;
  }
}
