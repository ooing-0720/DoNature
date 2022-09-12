import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:donation_nature/screen/alarm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './post/post_add_screen.dart';
import './post/post_detail_screen.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:donation_nature/screen/board_search_screen.dart';

import './postListTile.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // _initPostData=
  }

  @override
  Widget build(BuildContext context) {
    User? user = UserManage().getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("나눔게시판"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BoardSearchScreen()));
              },
              icon: Icon(Icons.search)),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AlarmScreen()));
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() {
            setState(() {});
          });
        },
        child: FutureBuilder<List<Post>>(
          future: PostService().getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post> posts = snapshot.data!;
              return ListView.separated(
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    Post data = posts[index];
                    return postListTile(context, data);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(thickness: 1);
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return user != null
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostAddScreen()));
                },
                label: Text('글쓰기'),
                backgroundColor: Color(0xff416E5C),
                icon: Icon(Icons.add),
              )
            : Container();
      }),
    );
  }
}
