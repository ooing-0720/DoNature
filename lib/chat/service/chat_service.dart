import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:donation_nature/chat/domain/chatting_room.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static final ChatService _chatService = ChatService._internal();
  factory ChatService() => _chatService;
  ChatService._internal();

  // CREATE
  Future<DocumentReference> createChattingRoom(
      Map<String, dynamic> json) async {
    var newChatRef =
        FirebaseFirestore.instance.collection("chattingroom_list").doc();
    await newChatRef.set(json);
    return newChatRef;
  }

  // READ
  Future<List<ChattingRoom>> getChattingRooms(User user) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("chattingroom_list");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference
            .where('user_uid', arrayContains: user.uid)
            .orderBy('updated_date', descending: true)
            .get();

    List<ChattingRoom> rooms = [];
    for (var doc in querySnapshot.docs) {
      ChattingRoom room = ChattingRoom.fromQuerySnapshot(doc);
      rooms.add(room);
    }

    return rooms;
  }

  // READ ONE
  Future<ChattingRoom> getChattingRoom(DocumentReference reference) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("chattingroom_list");
    var documentSnapshot = await collectionReference.doc(reference.id).get();

    return ChattingRoom.fromSnapshot(documentSnapshot);
  }

  // UPDATE
  // 메세지 전송할 때마다 updatedMsg, updatedDate에 값 업데이트하고 넘겨줘야함
  Future updateChat(
      {required DocumentReference reference,
      required Timestamp updatedDate,
      required String updatedMsg}) async {
    final collectionReference = FirebaseFirestore.instance
        .collection("chattingroom_list")
        .doc(reference.id);

    collectionReference
        .update({"updated_date": updatedDate, "updated_msg": updatedMsg});
  }

  //DELETE
  Future<void> deleteChattingRoom(DocumentReference reference) async {
    await reference.delete();
  }

  Future<void> updateProfileImage(
      User user, bool first, String imageUrl) async {
    final collectionReference =
        FirebaseFirestore.instance.collection("chattingroom_list");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference
            .where('user_uid', arrayContains: user.uid)
            .get();

    List<ChattingRoom> rooms = [];
    for (var doc in querySnapshot.docs) {
      ChattingRoom room = ChattingRoom.fromQuerySnapshot(doc);
      if (first) {
        room.profileImg![0] = imageUrl;
      } else {
        room.profileImg![1] = imageUrl;
      }
      doc.reference.set(room.toJson());
    }
  }
}
