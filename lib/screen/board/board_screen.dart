import 'package:donation_nature/board/service/post_service.dart';
import 'package:donation_nature/screen/alarm/alarm_screen.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/screen/board/post/post_add_screen.dart';

///import 'package:donation_nature/screen/board/post/post_add_share_screen.dart';
//import 'package:donation_nature/screen/board/post/post_add_inform_screen.dart';
//import 'package:donation_nature/screen/board/post/post_add_take_screen.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/mypage/user_manage.dart';
import 'package:donation_nature/screen/board/board_search_screen.dart';
import 'package:donation_nature/screen/board/post/postListTile.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            ? SpeedDial(
                icon: Icons.add,
                backgroundColor: Color(0xff416E5C),
                children: [
                  SpeedDialChild(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostAddScreen(0)));
                    },
                    label: '나눔하기',
                    backgroundColor: Color(0xff416E5C),
                    child: const Icon(Icons.volunteer_activism),
                    foregroundColor: Colors.white,
                  ),
                  SpeedDialChild(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostAddScreen(1)));
                    },
                    label: '나눔받기',
                    backgroundColor: Color(0xff416E5C),
                    child: SvgPicture.asset(
                      'assets/icon/diversity1.svg',
                    ),
                    foregroundColor: Colors.white,
                  ),
                  SpeedDialChild(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostAddScreen(2)));
                    },
                    label: '알리기',
                    backgroundColor: Color(0xff416E5C),
                    child: const Icon(Icons.campaign),
                    foregroundColor: Colors.white,
                  ),
                ],
              )
            : Container();
      }),
    );
  }
}
