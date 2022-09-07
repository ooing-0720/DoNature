import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/alarm/service/alarm_serivce.dart';
import 'package:donation_nature/chat/domain/chatting_room.dart';
import 'package:donation_nature/chat/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:donation_nature/models/chat_model.dart';
import 'package:donation_nature/models/chatMessageModel.dart';
import 'package:provider/provider.dart';
import 'package:donation_nature/screen/user_manage.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;
  final ChattingRoom chattingRoom;
  final DocumentReference reference;

  ChatDetailScreen(
      {Key? key,
      required this.userName,
      required this.chattingRoom,
      required this.reference})
      : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  User? user = UserManage().getUser();
  TextEditingController controller = TextEditingController();

//uid랑 비교

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.userName + '의 채팅'),
          ),
          body: StreamBuilder<List<ChatModel>>(
              stream: streamChat(),
              builder: (context, asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return const Center(
                    child: Text('오류 발생'),
                  );
                } else {
                  List<ChatModel> chats = asyncSnapshot.data!;

                  return Column(children: [
                    //채팅 버블 - expanded

                    Expanded(
                      child: ListView.builder(
                          itemCount: chats.length,
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isMe =
                                true; //chats의 useruid와 chatmodel의 useruid 같으면 내가 보낸것, isMe=true
                            if (chats[index].userUID != user!.uid) {
                              isMe = false;
                            }
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 12, right: 12, top: 8, bottom: 8),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: (isMe
                                        ? Alignment.topRight
                                        : Alignment.topLeft),
                                    child: Container(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: (isMe
                                              ? Color(0xff9fc3a8)
                                              : Colors.grey.shade200),
                                        ),
                                        padding: EdgeInsets.all(12),
                                        child: Text(
                                          chats[index].messageText,
                                          style: (isMe
                                              ? TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white)
                                              : TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black)),

                                          //TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      // Padding(
                                      //     padding: EdgeInsets.only(
                                      //   bottom: 5,
                                      // )),
                                    ),
                                  ),
                                  Container(
                                    alignment: isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, bottom: 5, top: 5),
                                    // margin: isMe
                                    //     ? EdgeInsets.only(right: 10)
                                    //     : EdgeInsets.only(
                                    //         bottom: 10, left: 5),
                                    //padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      chats[index]
                                          .time
                                          .toDate()
                                          .toLocal()
                                          .toString()
                                          .substring(5, 16),
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),

                    sendMessageField()
                  ]);
                }
              })),
    );
  }

  Align sendMessageField() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 8, bottom: 8, top: 8),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  // enabledBorder: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(15)),
                  hintText: "메세지를 입력하세요",
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 13),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black54),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black54),
                      borderRadius: BorderRadius.circular(20))),
            )),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: controller.value.text.isNotEmpty
                  ? _onPressedSendingButton
                  : null,
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Color(0xff9fc3a8),
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }

  void _onPressedSendingButton() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      ChatModel chatModel = ChatModel(
          userUID: user!.uid,
          messageText: controller.text,
          time: Timestamp.now());

      widget.chattingRoom.updatedDate = Timestamp.now();
      widget.chattingRoom.updatedMsg = controller.text;

      await ChatService().updateChat(
          reference: widget.reference,
          updatedDate: Timestamp.now(),
          updatedMsg: controller.text);

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      firestore
          .collection('/chattingroom_list/${widget.reference.id}/message_list')
          .add(chatModel.toMap());
      List<dynamic>? userUID = widget.chattingRoom.userUID;
      for(int i=0; i<2; i++){
        if(userUID![i] != user.uid){
          String otheruser = userUID[i];
          AlarmService.newMsgAlarm(otheruser, user.displayName!, controller.text);
        }
      }
      
    } catch (ex) {
      log('error)', error: ex.toString(), stackTrace: StackTrace.current);
    }

    controller.clear();
  }

  Stream<List<ChatModel>> streamChat() {
    
    try {
      
      final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
          .collection('/chattingroom_list/${widget.reference.id}/message_list')
          .orderBy('time')
          .snapshots();
      return snapshots.map((querySnapshot) {
        List<ChatModel> chats = [];
        for (var element in querySnapshot.docs) {
          chats.add(ChatModel.fromMap(
              id: element.id, map: element.data() as Map<String, dynamic>));
        }
        return chats;
      });
    } catch (ex) {
      log('error)', error: ex.toString(), stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }
}