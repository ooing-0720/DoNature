import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:donation_nature/board/provider/post_provider.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:donation_nature/screen/board_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';
import '../chat/chat_detail_screen.dart';
import './post_edit_screen.dart';

import 'package:donation_nature/board/domain/post.dart';

class PostDetailScreen extends StatelessWidget {
  Post post;

  PostService postService = PostService();
  PostDetailScreen(this.post);

//                   DateTime datetime = _editedPost.date!.toDate();
//                   _editedPost.content = contentEditingController.text;
//                   _editedPost.title = titleEditingController.text;
//                   print("date " + _editedPost.date.toString());
//                   print("datetime " + datetime.toString());
//                   _editedPost.date = Timestamp.now();
  @override
  Widget build(BuildContext context) {
    User? user = UserManage().getUser();
    DateTime dateTime = post.date!.toDate();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title!,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(dateTime.toLocal().toString().substring(5, 16)),
              ],
            ),
            Divider(
              height: 20,
              thickness: 1.5,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(post.tagDisaster!,
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Color(0xff9fc3a8),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.place,
                    color: Color(0xff9fc3a8),
                  ),
                  Chip(
                    label: Text(
                        post.locationSiDo! + " " + post.locationGuGunSi!,
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Color(0xff9fc3a8),
                  ),
                  // InputChip(
                  //   label: Text(post.locationGuGunSi!),
                  // ),
                  Spacer(),
                  if (post.userEmail == user?.email)
                    Row(children: [deleteButton(context), editButton(context)]),
                ],
              ),
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
        backgroundColor: Color(0xff9fc3a8),
        icon: Icon(Icons.chat_bubble),
      ),
    );
  }

  TextButton editButton(BuildContext context) {
    return TextButton(
        //수정버튼
        onPressed: () {
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => PostEditScreen(post: post),
          //     ),
          //     (route) => false);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostEditScreen(
                        post: post,
                      )));
          // PostService()
          //     .updatePost(reference: post.reference!, json: post.toJson());
          //Get.to(() => PostEditScreen(post: post));
        },
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

  TextButton deleteButton(BuildContext context) {
    return TextButton(
        //삭제버튼
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  content: Text("게시글을 삭제하시겠습니까?"),
                  actions: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          primary: Color(0xff9fc3a8),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          PostService().deletePost(post.reference!);
                          Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                  builder: ((context) => BoardScreen())));
                        },
                        child: Text("예")),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(40, 40),
                          primary: Color(0xff9fc3a8),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("아니오"))
                  ],
                );
              });
        },
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
