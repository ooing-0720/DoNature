import 'package:donation_nature/screen/chat/chat_test.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( 
      title: Text('채팅',
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
    body: Center(
      child: ElevatedButton(
        child: const Text('chat test'),
        onPressed: (){
          Navigator.push(context, 
          MaterialPageRoute(builder: (context)=> const ChatTest()),);
        },
      )
    ,));
  }
}
