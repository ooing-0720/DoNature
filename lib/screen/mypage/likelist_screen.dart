import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:donation_nature/board/service/post_service.dart';
import '../post/post_detail_screen.dart';
import 'package:donation_nature/board/domain/post.dart';

class LikeListScreen extends StatefulWidget {
  const LikeListScreen({Key? key}) : super(key: key);

  @override
  State<LikeListScreen> createState() => _LikeListScreenState();
}

class _LikeListScreenState extends State<LikeListScreen> {
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
          title: Text("관심목록"),
        ),
        body: RefreshIndicator(
            child: FutureBuilder<List<Post>>(
                future: PostService().getLikedPosts(user!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Post> findPosts = snapshot.data!;

                    return ListView.builder(
                      itemCount: findPosts.length,
                      itemBuilder: (BuildContext context, int index) {
                        Post data = findPosts[index];

                        return Card(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PostDetailScreen(data),
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
                                    transform: new Matrix4.identity()
                                      ..scale(0.95),
                                    child: Row(
                                      children: [
                                        Chip(
                                          label: Text(
                                            "${data.tagDisaster}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Color(0xff5B7B6E),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Chip(
                                          label: Text(
                                            "${data.locationSiDo}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Color(0xff5B7B6E),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    print('${snapshot.error}');
                    return Text('${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
            onRefresh: () {
              return Future(() {
                setState(() {});
              });
            }));
  }
}
