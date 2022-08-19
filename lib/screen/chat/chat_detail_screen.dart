import 'package:flutter/material.dart';
import 'package:donation_nature/models/chat_model.dart';
import 'package:donation_nature/models/chatMessageModel.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;

  //나중에 userId로 받아야할것같음..
  ChatDetailScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "받는사람", messageType: "receiver"),
    ChatMessage(messageContent: "받는사람2", messageType: "receiver"),
    ChatMessage(messageContent: "보내는사람", messageType: "sender"),
    ChatMessage(messageContent: "받는사람3", messageType: "receiver"),
    ChatMessage(
        messageContent: "보내는사람2", messageType: "sender"),
  ];

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
          body:
              // Padding(
              //   padding: EdgeInsets.all(10),
              //   child: Text(''),
              // ),
              Stack(
            children: [chatBubble(), sendMessageField()],
          )),
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
              onPressed: () {},
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

  ListView chatBubble() {
    return ListView.builder(
      itemCount: messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 8, bottom: 8),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
          child: Align(
            alignment: (messages[index].messageType == "receiver"
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (messages[index].messageType == "receiver"
                    ? Colors.grey.shade200
                    : Color(0xff9fc3a8)),
              ),
              padding: EdgeInsets.all(12),
              child: Text(
                messages[index].messageContent,
                style: (messages[index].messageType == "receiver"
                    ? TextStyle(fontSize: 15, color: Colors.black)
                    : TextStyle(fontSize: 15, color: Colors.white)),
                //TextStyle(fontSize: 15),
              ),
            ),
          ),
        );
      },
    );
  }
}
