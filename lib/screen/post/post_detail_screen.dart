import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/provider/post_provider.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:flutter/material.dart';
import '../chat/chat_detail_screen.dart';
import 'package:donation_nature/board/domain/post.dart';

class PostDetailScreen extends StatelessWidget {
  DocumentReference reference;
  PostDetailScreen(this.reference);
  //var post = FirebaseFirestore.instance.collection("bulletin_board").doc(reference.id);

  // var _detailPost = Post(
  //   title: '글 제목ddddddddddddddddddddddddddddddddddddddddd',
  //   writer: '',
  //   date: null,
  //   content: '',
  //   locationSiDo: '서울', // 시/도
  //   locationGuGunSi: '', // 구/군/시
  //   tagDisaster: '지진', // 재난 태그
  //   tagMore: '', // 그 외 태그

  //   //시도 - 구군시-동읍면 이 낫지 않을까
  // );

  @override
  Widget build(BuildContext context) {
    PostService _postService = PostService();
    Future<Post> post = _postService.getPost(this.reference.id);

    // String id = this.reference.id;

    // String title = "";
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    // firestore
    //     .collection("bulletin_board")
    //     .doc("$reference")
    //     .get()
    //     .then((DocumentSnapshot ds) {
    //   print(ds.data());
    // });
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
                  "ddd",
                  maxLines: 3,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ],
            ),
            Divider(
              height: 20,
              thickness: 1.5,
            ),
            // Row(
            //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     InputChip(label: Text(_detailPost.tagDisaster!)),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Icon(Icons.place),
            //     InputChip(
            //       label: Text(_detailPost.locationSiDo!),
            //     ),
            //     Spacer(),
            //     deleteButton(),
            //     editButton()
            //   ],
            // ),
            Divider(
              height: 20,
              thickness: 1.5,
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
