//import 'dart:html';
import 'package:donation_nature/chat/domain/chatting_room.dart';
import 'package:donation_nature/screen/home/disaster_list.dart';
import 'package:donation_nature/screen/mypage/login_screen.dart';
import 'package:flutter/material.dart';
import './chat_detail_screen.dart';
import 'package:donation_nature/chat/service/chat_service.dart';
import 'package:donation_nature/mypage/user_manage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  User? user = UserManage().getUser(); //현재 유저정보
  String? _image;
  @override
  Widget build(BuildContext context) {
    return user != null
        ? Scaffold(
            appBar: AppBar(
              title: Text('채팅 목록',
                  style: TextStyle(
                    color: Colors.black,
                  )),
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
                    return ListView.separated(
                      itemCount: rooms.length,
                      itemBuilder: (BuildContext context, int index) {
                        String userUID = user!.uid; //현재 유저의 uid
                        ChattingRoom data = rooms[index]; //각각의 채팅방
                        return Builder(builder: (context) {
                          //채팅하는 상대방 이름 띄우기
                          return userUID == data.userUID!.first
                              //내가 채팅하기를 눌렀을 때

                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatDetailScreen(
                                                  chattingRoom: data,
                                                  userName: data.nickname!.last,
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
                                        // backgroundImage:
                                        //     NetworkImage("${data.profileImg}"),
                                        // backgroundColor: Colors.transparent,
                                        backgroundColor: Color(0xff416E5C),
                                        radius: 24,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3.0),
                                        child: Text(
                                          "${data.postTitle}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("${data.nickname!.last}"),
                                              Text(
                                                "${data.updatedMsg}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          //공통으로
                                          Spacer(),
                                          Text(
                                            "${data.updatedDate?.toDate().toLocal().toString().substring(5, 16)}",
                                          ),
                                        ],
                                      )),
                                )
                              : //상대방이 채팅하기를 눌렀을 때
                              GestureDetector(
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
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      dense: false,
                                      visualDensity: VisualDensity(
                                          horizontal: -4, vertical: -4),
                                      leading: CircleAvatar(
                                        // backgroundImage:
                                        //     NetworkImage("${data.profileImg}"),
                                        // backgroundColor: Colors.transparent,
                                        backgroundColor: Color(0xff416E5C),
                                        radius: 24,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3.0),
                                        child: Text(
                                          "${data.postTitle}",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("${data.nickname!.first}"),
                                              Text(
                                                "${data.updatedMsg}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          //공통으로
                                          Spacer(),
                                          Text(
                                            "${data.updatedDate?.toDate().toLocal().toString().substring(5, 16)}",
                                          ),
                                        ],
                                      )),
                                );
                        });
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(thickness: 1);
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
