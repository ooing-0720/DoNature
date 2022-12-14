import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChattingRoom {
  // List<dynamic>? user; // 채팅방에 포함된 유저 2명의 이메일
  List<dynamic>? nickname; // 채팅방에 포함된 유저 2명의 닉네임
  List<dynamic>? userUID; // 채팅방에 포함된 유저 2명의 UID
  List<dynamic>? profileImg; // 채팅방에 포함된 유저 2명의 프로필 사진
  String? postTitle; // 채팅이 생성된 게시글 제몰
  Timestamp? updatedDate; // 가장 최근에 메세지 보낸 시간
  String? updatedMsg; // 가장 최근에 보낸 메세지 내용
  Post? post; // 어떤 게시글 채팅인지
  String? postReference;
  DocumentReference? chatReference;

  ChattingRoom({
    // this.user,
    this.nickname,
    this.userUID,
    this.post,
    this.chatReference,
  });

  ChattingRoom.fromJson(dynamic json, this.chatReference) {
    // user = json['user'];
    nickname = json['nickname'];
    userUID = json['user_uid'];
    profileImg = json['profile_image'];
    postTitle = json['post_title'];
    updatedDate = json['updated_date'];
    updatedMsg = json['updated_msg'];
    postReference = json['post_reference'];
  }

  ChattingRoom.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  ChattingRoom.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data(), snapshot.reference);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // map['user'] = user;
    map['nickname'] = nickname;
    map['user_uid'] = userUID;
    map['profile_image'] = profileImg ?? [];
    map['post_title'] = post!.title;
    map['updated_date'] = updatedDate ?? Timestamp.now();
    map['updated_msg'] = updatedMsg ?? '';
    map['post_reference'] = post?.reference?.id;

    return map;
  }
}
