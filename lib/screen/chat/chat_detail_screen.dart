import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/alarm/service/alarm_serivce.dart';
import 'package:donation_nature/chat/domain/chatting_room.dart';
import 'package:donation_nature/chat/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:donation_nature/models/chat_model.dart';

import 'package:donation_nature/mypage/user_manage.dart';

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
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Timer(Duration(milliseconds: 400), () => scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    //시작할 때 가장 아래로 스크롤 내리기
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(widget.userName + '의 채팅'),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: StreamBuilder<List<ChatModel>>(
              stream: streamChat(),
              builder: (context, asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return const Center(
                    child: Text('오류 발생'),
                  );
                } else {
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  }
                  List<ChatModel> chats = asyncSnapshot.data!;

                  return Column(children: [
                    Expanded(
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: chats.length + 1,
                          itemBuilder: (context, index) {
                            if (index == chats.length) {
                              return Container(
                                height: 60,
                              );
                            }
                            bool isMe =
                                true; //chats의 useruid와 chatmodel의 useruid 같으면 내가 보낸 것, isMe=true
                            if (chats[index].userUID != user!.uid) {
                              isMe = false;
                            }

                            return Container(
                              padding: EdgeInsets.only(
                                  left: 12, right: 12, top: 4, bottom: 4),
                              child: Column(
                                children: <Widget>[
                                  //내가 보낸 채팅 버블 오른쪽으로 정렬
                                  Align(
                                    alignment: (isMe
                                        ? Alignment.topRight
                                        : Alignment.topLeft),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          minWidth: 10,
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: (isMe
                                            ? Color(0xff416E5C)
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
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, bottom: 5, top: 5),
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
              }),
        ));
  }

  Align sendMessageField() {
    return Align(
      alignment: Alignment.bottomCenter,
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
              maxLines: null,
              controller: controller,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
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
              onPressed: () async {
                if (controller.value.text.isNotEmpty) {
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
                        .collection(
                            '/chattingroom_list/${widget.reference.id}/message_list')
                        .add(chatModel.toMap());
                    setState(() {});
                    List<dynamic>? userUID = widget.chattingRoom.userUID;
                    for (int i = 0; i < 2; i++) {
                      if (userUID![i] != user.uid) {
                        String otheruser = userUID[i];
                        AlarmService.newMsgAlarm(
                            otheruser, user.displayName!, controller.text);
                      }
                    }
                  } catch (ex) {
                    log('error)',
                        error: ex.toString(), stackTrace: StackTrace.current);
                  }
                  //채팅 보내고 나서 가장 아래로 내려오기
                  scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                  controller.clear();
                } else {
                  null;
                }
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Color(0xff416E5C),
              elevation: 0,
            ),
          ],
        ),
      ),
    );
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
