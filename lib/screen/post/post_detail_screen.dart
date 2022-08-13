import 'package:flutter/material.dart';
import '../chat/chat_detail_screen.dart';

class PostDetailScreen extends StatelessWidget {
  final int id;
  const PostDetailScreen(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "글 제목",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    //삭제버튼
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        Text(
                          "삭제",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    )),
                TextButton(
                    //수정버튼
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                        Text(
                          "수정",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ))
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Text("글 내용 " * 500),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(userName: "$id")));
        },
        label: Text('채팅하기'),
        backgroundColor: Color.fromARGB(255, 33, 33, 33),
        icon: Icon(Icons.chat_bubble),
      ),
    );
  }
}
