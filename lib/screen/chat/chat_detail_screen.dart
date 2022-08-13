import 'package:flutter/material.dart';
import 'package:donation_nature/models/chat_users.dart';

class ChatDetailScreen extends StatefulWidget {
  final String userName;

  //나중에 userId로 받아야할것같음..
  ChatDetailScreen({Key? key, required this.userName}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName + '의 채팅'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Text(''),
      ),
    );
  }
}
