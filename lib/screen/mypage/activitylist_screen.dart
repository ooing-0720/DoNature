import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:donation_nature/board/service/post_service.dart';
import '../post/post_detail_screen.dart';
import 'package:donation_nature/board/domain/post.dart';
import '../postListTile.dart';

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

                    return ListView.separated(
                        itemCount: findPosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          Post data = findPosts[index];

                          return postListTile(context, data);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(thickness: 1);
                        });
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
