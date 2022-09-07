import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/chat/domain/chatting_room.dart';
import 'package:donation_nature/screen/alarm_screen.dart';
import 'package:donation_nature/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/models/chat_model.dart';
import './chat_detail_screen.dart';
import 'package:donation_nature/chat/service/chat_service.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  User? user = UserManage().getUser(); //현재 유저정보

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Scaffold(
            appBar: AppBar(
              title: Text('채팅 목록',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AlarmScreen()));
                  },
                  icon: Icon(Icons.notifications),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () {
                return Future(() {
                  setState(() {});
                });
              },
              child: FutureBuilder<List<ChattingRoom>>(
                future: ChatService().getChattingRooms(user!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ChattingRoom> rooms = snapshot.data!;
                    // print(rooms.length);
                    return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (BuildContext context, int index) {
                        String userEmail = user!.email!; //현재 유저의 이메일
                        ChattingRoom data = rooms[index]; //각각의 채팅방
                        // data.user!.first   //sender
                        return Card(
                          //상대방 이름 user list
                          child: Builder(builder: (context) {
                            return userEmail == data.user!.first
                                //채팅하는 상대방 이름 띄우기
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatDetailScreen(
                                                    chattingRoom: data,
                                                    userName:
                                                        data.nickname!.last,
                                                    reference:
                                                        data.chatReference!,
                                                  )));
                                    },
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      dense: false,
                                      visualDensity: VisualDensity(
                                          horizontal: -4, vertical: -4),
                                      leading: CircleAvatar(
                                        backgroundColor: Color(0xff9fc3a8),
                                        radius: 24,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text("${data.postTitle}"),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${data.nickname!.last}"),
                                                  Text(
                                                      "마지막 메세지: ${data.updatedMsg}"),
                                                ],
                                              ),
                                              //공통으로
                                              Spacer(),
                                              Text(
                                                "${data.updatedDate?.toDate().toLocal().toString().substring(5, 16)}",
                                                //style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChatDetailScreen(
                                              chattingRoom: data,
                                              userName: data.nickname!.first,
                                              reference: data.chatReference!,
                                            ),
                                          ));
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Color(0xff9fc3a8),
                                        radius: 24,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text("${data.nickname!.first}"),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("제목: ${data.postTitle}"),
                                                  Text(
                                                      "마지막 메세지: ${data.updatedMsg}"),
                                                ],
                                              ), //공통으로
                                              Spacer(),
                                              Text(
                                                "${data.updatedDate?.toDate().toLocal().toString().substring(5, 16)}",
                                                //style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                          }),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ))
        :
        //비회원이면 로그인 페이지로 이동
        LoginScreen();
  }
}
