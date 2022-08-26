/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/models/chat_model.dart';
import './chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  //예시
  List<ChatModel> chatUsers = [
    ChatModel(name: "ㅇㅇㅇ", messageText: "ㄱㄴㄷㄹ", time: "하루 전"),
    ChatModel(name: "ㅁㅁㅁ", messageText: "dㅁㄴㅇ", time: "지금"),
    ChatModel(name: "ㄱㄱㄱ", messageText: "dddd", time: "지금"),
    ChatModel(name: "ㅇㅇㅇ", messageText: "dddd", time: "지금"),
    ChatModel(name: "ㅇㅇㅇ", messageText: "ㅁㅇㄴd", time: "지금"),
    ChatModel(name: "ㅇㅇㅇ", messageText: "dddd", time: "지금"),
    ChatModel(name: "ㅇㅇㅇ", messageText: "dddd", time: "지금"),
    ChatModel(name: "ㅇㅇㅇ", messageText: "ㅁㅇㄴd", time: "지금"),
    ChatModel(name: "ㅇㅇㅇ", messageText: "dddd", time: "지금"),
    ChatModel(name: "ㅇㅇㅇ", messageText: "dddd", time: "이틀 전"), 
    
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
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
*/