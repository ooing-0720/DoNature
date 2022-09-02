import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/chat/domain/chatting_room.dart';
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
                  onPressed: () {},
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

                        ChattingRoom data = rooms[index]; //채팅 목록 각각
                        // data.user!.first   //sender
                        return Card(
                          //상대방 이름 user list
                          child: Builder(builder: (context) {
                            return userEmail == data.user!.first
                                ? GestureDetector(
                                    onTap: () {
                                      if (user!.uid.toString() == data.lastSenderUID){
                                       ChatService().unreadMsg(reference: data.chatReference!);
                                      }
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
                                                  )
                                              //   ChatDetailScreen(
                                              //  chat  data
                                              //       // userName:
                                              //       //     data.nickname!.last
                                              //           ),
                                              ) );
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
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (user!.uid.toString() == data.lastSenderUID){
                                       ChatService().unreadMsg(reference: data.chatReference!);
                                      }
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

                                      //채팅하기를 먼저 누른 사람이 0 sender, 글 올린 사람이 1 receiver
                                      //user가 sender이면
                                      //user가 receiver이면
                                      // userEmail != data.
                                      //Text("${data.user!.last}"),
                                      //if user email == data.email[0] 유저가 sender 전부 1로 출력

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
        //비회원이면 로그인 페이지로 이동하게
        LoginScreen();
  }
}

// class ChatList extends StatefulWidget {
//   late String name;
//   late String messageText;
//   late String time;
//   late bool isMessageRead;

//   //프로필사진 추가?
//   @override
//   State<ChatList> createState() => _ChatListState();
// }

// class _ChatListState extends State<ChatList> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: ((context) =>
//                     ChatDetailScreen(userName: widget.name))));
//         //디테일페이지로 이동
//       },
//       child: Container(
//           padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//           child: Row(
//             children: [
//               Expanded(
//                   child: Row(
//                 children: [
//                   SizedBox(
//                     width: 16,
//                   ),
//                   Expanded(
//                       child: Container(
//                     color: Colors.transparent,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.name,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(
//                           height: 6,
//                         ),
//                         Text(
//                           widget.messageText,
//                           style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey.shade600,
//                               fontWeight: widget.isMessageRead
//                                   ? FontWeight.bold
//                                   : FontWeight.normal),
//                         ),
//                       ],
//                     ),
//                   ))
//                 ],
//               )),
//               Text(
//                 widget.time,
//                 style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: widget.isMessageRead
//                         ? FontWeight.bold
//                         : FontWeight.normal),
//               )
//             ],
//           )),
//     );
//   }
// }

// class _ChatListState extends State<ChatList> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: ((context) =>
//                     ChatDetailScreen(userName: widget.name))));
//         //디테일페이지로 이동
//       },
//             child: Container(
//           padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//           child: Row(
//             children: [
//               Expanded(
//                   child: Row(
//                 children: [
//                   Expanded(
//                       child: Container(
//                     color: Colors.transparent,
//                     child: Row(
//                       //crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           backgroundColor: Color(0xff9fc3a8),
//                           radius: 24,
//                           child: Icon(
//                             Icons.person,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Column(
//                           children: [
//                             Text(
//                               widget.name,
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             SizedBox(
//                               height: 6,
//                             ),
//                             Text(
//                               widget.messageText,
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey.shade600,
//                                   fontWeight: widget.isMessageRead
//                                       ? FontWeight.bold
//                                       : FontWeight.normal),
//                         ),
//                       ],
//                     ),
//                 ]))
//                   )],
//               )),
//               Text(
//                 widget.time,
//                 style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: widget.isMessageRead
//                         ? FontWeight.bold
//                         : FontWeight.normal),
//               )
//             ],
//           )),
//     );
//   }
// }

// */
