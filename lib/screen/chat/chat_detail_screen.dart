import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/chat/domain/chatting_room.dart';
import 'package:donation_nature/chat/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:donation_nature/models/chat_model.dart';
import 'package:donation_nature/models/chatMessageModel.dart';
import 'package:provider/provider.dart';

import 'chat_bubble.dart';
import 'chat_provider.dart';

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
  TextEditingController controller = TextEditingController();

  //채팅만든사람이 0-

/*  List<ChatMessage> messages = [
    ChatMessage(messageContent: "받는사람", messageType: "receiver"),
    ChatMessage(messageContent: "받는사람2", messageType: "receiver"),
    ChatMessage(messageContent: "보내는사람", messageType: "sender"),
    ChatMessage(messageContent: "받는사람3", messageType: "receiver"),
    ChatMessage(messageContent: "보내는사람2", messageType: "sender"),
  ];*/

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
                    Expanded(
                      child: ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(chats[index].messageText),
                              //subtitle: Text(chats[index].time.toDate().toLocal().toString().substring(5,16)),
                            );
                          }),
                    ),
                    sendMessageField()
                  ]);
                }
              })
          // Padding(
          //   padding: EdgeInsets.all(10),
          //   child: Text(''),
          // ),
          // Stack(
          // children: [chatBubble(), sendMessageField()],)
          ),
    );
  }

  /*ListView chatBubble() {
    var isMe = ChatModel().userUID != Provider.of<ChatProvider>(context).userUID;


    return ListView.builder(
      itemCount: chatModel.messageText.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 8, bottom: 8),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
          child: Align(
            alignment: (isMe//messages[index].messageType == "receiver"
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (isMe//messages[index].messageType == "receiver"
                    ? Colors.grey.shade200
                    : Color(0xff9fc3a8)),
              ),
              padding: EdgeInsets.all(12),
              child: Text(
                chatModel.messageText,
                style: (isMe//messages[index].messageType == "receiver"
                    ? TextStyle(fontSize: 15, color: Colors.black)
                    : TextStyle(fontSize: 15, color: Colors.white)),
                //TextStyle(fontSize: 15),
              ),
            ),
          ),
        );
      },
    );
  }*/

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
              onPressed: _onPressedSendingButton,
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
    } catch (ex) {
      log('error)', error: ex.toString(), stackTrace: StackTrace.current);
    }
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
