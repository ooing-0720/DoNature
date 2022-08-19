import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/provider/post_provider.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:flutter/material.dart';
import '../chat/chat_detail_screen.dart';
import 'package:donation_nature/board/domain/post.dart';

class PostDetailScreen extends StatelessWidget {
  Post post;
  PostDetailScreen(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  post.title!,
                  maxLines: 3,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
            Divider(
              height: 20,
              thickness: 1.5,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InputChip(
                  label: Text(post.tagDisaster!),
                  backgroundColor: Color(0xff9fc3a8),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.place),
                InputChip(
                  label: Text(post.locationSiDo! + " " + post.locationGuGunSi!),
                  backgroundColor: Color(0xff9fc3a8),
                ),
                // InputChip(
                //   label: Text(post.locationGuGunSi!),
                // ),
                Spacer(),
                deleteButton(),
                editButton()
              ],
            ),
            Divider(
              height: 20,
              thickness: 1.5,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Text(post.content!),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => ChatDetailScreen(userName: "$id")));
        },
        label: Text('채팅하기'),
        backgroundColor: Color.fromARGB(255, 7, 65, 29),
        icon: Icon(Icons.chat_bubble),
      ),
    );
  }

  TextButton editButton() {
    return TextButton(
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
        ));
  }

  TextButton deleteButton() {
    return TextButton(
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
        ));
  }
}
