import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:donation_nature/board/provider/post_provider.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:donation_nature/chat/domain/chatting_room.dart';
import 'package:donation_nature/chat/service/chat_service.dart';
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

  ChatService chatService = ChatService();

  Widget build(BuildContext context) {
    User? user = UserManage().getUser();
    DateTime dateTime = post.date!.toDate();

    return user != null //user가 로그인 해있을 때
        ? Builder(builder: (context) {
            bool userIsWriter = false;
            if (user.email == post.userEmail) userIsWriter = true;
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        //Text("작성자: " + post.writer!),
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
                                post.locationSiDo! +
                                    " " +
                                    post.locationGuGunSi!,
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Color(0xff9fc3a8),
                          ),
                          Spacer(),
                          if (userIsWriter == true)
                            Row(children: [
                              deleteButton(context),
                              editButton(context)
                            ]),
                        ],
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 1.5,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: post.imageUrl != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "${post.imageUrl}"),
                                            fit: BoxFit.cover)),
                                    height: 400,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(post.content!),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Text(post.content!),
                              ],
                            ),
                    ))
                  ],
                ),
              ),
              floatingActionButton: userIsWriter == false //본인이 작성한 글이 아니면 채팅 가능
                  ? FloatingActionButton.extended(
                      onPressed: () async {
                        ChattingRoom _chattingRoom;
                        if (PostService().isChatted(post, user)) {
                          _chattingRoom = await ChatService()
                              .getChattingRoom(post.chatUsers![user.email]);
                          // 채팅한적 있음
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ChatDetailScreen(
                                      userName: post.writer!,
                                      chattingRoom: _chattingRoom,
                                      reference:
                                          post.chatUsers![user.email]))));
                        } else {
                          // 채팅한적 없음
                          List<String> users = [];
                          users.add(user.email!);
                          users.add(post.userEmail!);
                          // print(UserManage().getUser()!.email! + post.userEmail!);
                          List<String> nicknames = [];
                          nicknames.add(user.displayName!);
                          nicknames.add(post.writer!);

                          _chattingRoom = ChattingRoom(
                              user: users, nickname: nicknames, post: post);

                          _chattingRoom.chatReference = await chatService
                              .createChattingRoom(_chattingRoom.toJson());
                          post.chatUsers![user.email] =
                              _chattingRoom.chatReference;
                          PostService().updatePost(
                              reference: post.reference!, json: post.toJson());
                          // print(_chattingRoom.chatReference);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ChatDetailScreen(
                                      userName: post.writer!,
                                      chattingRoom: _chattingRoom,
                                      reference:
                                          _chattingRoom.chatReference!))));
                        }
                      },
                      label: Text('채팅하기'),
                      backgroundColor: Color(0xff9fc3a8),
                      icon: Icon(Icons.chat_bubble),
                    )
                  : Container(),
            );
          })
        : //유저가 로그인 안 해있을 때
        Scaffold(
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //Text("작성자: " + post.writer!),
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
                        Spacer(),
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 1.5,
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: post.imageUrl != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              NetworkImage("${post.imageUrl}"),
                                          fit: BoxFit.cover)),
                                  height: 400,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(post.content!),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Text(post.content!),
                            ],
                          ),
                  ))
                ],
              ),
            ),
          );
  }

  TextButton editButton(BuildContext context) {
    return TextButton(
        //수정버튼
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostEditScreen(
                        post: post,
                      )));
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
                          PostService().deletePost(post);
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
