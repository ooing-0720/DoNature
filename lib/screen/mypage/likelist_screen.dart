import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/mypage/user_manage.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:donation_nature/board/domain/post.dart';
import '../post/postListTile.dart';

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
