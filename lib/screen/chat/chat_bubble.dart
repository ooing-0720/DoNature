import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat_model.dart';
import 'chat_provider.dart';

class chatBubble extends StatelessWidget{
  const chatBubble({Key? key, required this.chatModel}) : super(key: key);
  final ChatModel chatModel;
  
  @override
  Widget build(BuildContext context) {
    var isMe = ChatModel().userUID != Provider.of<ChatProvider>(context).userUID;

    return Container(
      child: ListView.builder(
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
    ));
   
  }


  
}