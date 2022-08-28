import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:donation_nature/chat/domain/chatting_room.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  static final ChatService _chatService = ChatService._internal();
  factory ChatService() => _chatService;
  ChatService._internal();

  // CREATE
  Future createChattingRoom(Map<String, dynamic> json) async {
    await FirebaseFirestore.instance.collection("chattingroom_list").add(json);
  }

  // READ
  Future<List<ChattingRoom>> getChattingRoom(User user) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("chattingroom_list");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference
            .where('user', arrayContains: user.email)
            .orderBy('date', descending: true)
            .get();

    List<ChattingRoom> rooms = [];
    for (var doc in querySnapshot.docs) {
      ChattingRoom room = ChattingRoom.fromQuerySnapshot(doc);
      rooms.add(room);
    }

    return rooms;
  }

  // UPDATE
  // 메세지 전송할 때마다 updatedMsg, updatedDate에 값 업데이트하고 넘겨줘야함
  Future updateChat(
      {required DocumentReference reference,
      required Map<String, dynamic> json}) async {
    await reference.set(json);
  }

  //DELETE
  Future<void> deleteChattingRoom(DocumentReference reference) async {
    await reference.delete();
  }
}
