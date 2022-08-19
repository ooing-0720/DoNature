import 'package:flutter/material.dart';
import 'package:donation_nature/models/chat_users.dart';
import './chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //예시
  List<ChatUsers> chatUsers = [
    ChatUsers(name: "ㅇㅇㅇ", messageText: "ㄱㄴㄷㄹ", time: "하루 전"),
    ChatUsers(name: "ㅁㅁㅁ", messageText: "dㅁㄴㅇ", time: "지금"),
    ChatUsers(name: "ㄱㄱㄱ", messageText: "dddd", time: "지금"),
    ChatUsers(name: "ㅇㅇㅇ", messageText: "dddd", time: "지금"),
    ChatUsers(name: "ㅇㅇㅇ", messageText: "ㅁㅇㄴd", time: "지금"),
    ChatUsers(name: "ㅇㅇㅇ", messageText: "dddd", time: "지금"),
    ChatUsers(name: "ㅇㅇㅇ", messageText: "dddd", time: "지금"),
    ChatUsers(name: "ㅇㅇㅇ", messageText: "ㅁㅇㄴd", time: "지금"),
    ChatUsers(name: "ㅇㅇㅇ", messageText: "dddd", time: "지금"),
    ChatUsers(name: "ㅇㅇㅇ", messageText: "dddd", time: "이틀 전"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: ListView.separated(
          itemCount: chatUsers.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: ChatList(
                name: chatUsers[index].name, //이름
                messageText: chatUsers[index].messageText, //메세지텍스트
                time: chatUsers[index].time, //보낸 시간
                isMessageRead:
                    ((index == 0 || index == 3) ? true : false), //읽음표시
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 2,
            );
          },
        ));
  }
}

class ChatList extends StatefulWidget {
  late String name;
  late String messageText;
  late String time;
  late bool isMessageRead;

  //ChatUsers chatUsers;

  ChatList(
      {required this.name,
      required this.messageText,
      required this.time,
      required this.isMessageRead});

  //프로필사진 추가?
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) =>
                    ChatDetailScreen(userName: widget.name))));
        //디테일페이지로 이동
      },
      child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: Container(
                    color: Colors.transparent,
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xff9fc3a8),
                          radius: 24,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.messageText,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: widget.isMessageRead
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
                ],
              )),
              Text(
                widget.time,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: widget.isMessageRead
                        ? FontWeight.bold
                        : FontWeight.normal),
              )
            ],
          )),
    );
  }
}
