import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/provider/post_provider.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './post/post_add_screen.dart';
import './post/post_detail_screen.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';

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
    // PostService _postService = PostService();
    // Future<List<Post>> posts = _postService.getPosts();
    // final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("나눔게시판"),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(),
                );
              },
              icon: Icon(Icons.search)),
          IconButton(
            onPressed: () {},
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
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  Post data = posts[index];
                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailScreen(data),
                            ));
                      },
                      child: ListTile(
                        title: Text(
                          "${data.title}",
                          style: TextStyle(fontSize: 17.5),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data.date!.toDate().toLocal().toString().substring(5, 16)}",
                              style: TextStyle(fontSize: 12),
                            ),
                            Transform(
                              transform: new Matrix4.identity()..scale(0.95),
                              child: Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      "${data.tagDisaster}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Color(0xff5B7B6E),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Chip(
                                    label: Text(
                                      "${data.locationSiDo}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Color(0xff5B7B6E),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        trailing: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.favorite_border,
                            color: Color(0xff5B7B6E),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
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
                backgroundColor: Color(0xff5B7B6E),
                icon: Icon(Icons.add),
              )
            : Container();
      }),
    );
  }
  //Future <void> _refreshPosts() async {}
}

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate()
      : super(
            searchFieldLabel: "검색",
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      //검색어 지우는 기능
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //뒤로가기
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => const Text('suggestions');
  //검색결과 보여줌
  @override
  Widget buildResults(BuildContext context) => const Text('results');
}
