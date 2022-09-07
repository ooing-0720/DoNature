import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:donation_nature/board/service/post_service.dart';
import '../post/post_detail_screen.dart';
import 'package:donation_nature/board/domain/post.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({Key? key}) : super(key: key);

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
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
          title: Text("활동내역"),
        ),
        body: RefreshIndicator(
            child: FutureBuilder<List<Post>>(
                future: PostService().getWrittenPosts(user!),
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
                                          backgroundColor: Color(0xff90B1A4),
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
                                          backgroundColor: Color(0xff90B1A4),
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
