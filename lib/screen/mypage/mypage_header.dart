import 'dart:io';
import 'package:donation_nature/screen/mypage/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/screen/mypage/likelist_screen.dart';
import 'package:donation_nature/screen/mypage/activitylist_screen.dart';
import 'package:donation_nature/mypage/user_manage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

class MyPageHeader extends StatefulWidget {
  const MyPageHeader({Key? key}) : super(key: key);

  @override
  State<MyPageHeader> createState() => MyPageHeaderState();
}

class MyPageHeaderState extends State<MyPageHeader> {
  final UserManage userManage = UserManage();
  String userName = '';
  String userEmail = '';
  String userPhoto = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: buildMypageHeader(context),
    );
  }

  @override
  void initState() {
    super.initState();
    getAndDisplayUserInformation();
  }

  getAndDisplayUserInformation() async {
    setState(() {
      loading = true;
    });

    User? user = userManage.getUser();
    if (user == null) {
      userName = '';
      userEmail = '';
      userPhoto = 'default_profile';
    } else {
      userName = user.displayName! + '님';
      userEmail = user.email!;
      userPhoto = user.photoURL!;
    }

    // 셋팅 끝나면 loading은 false로 바뀌고 화면에 값들이 보임
    setState(() {
      loading = false;
    });
  }

  Widget buildMypageHeader(BuildContext context) {

    return Container(
        child: Column(children: [
      Row(children: [
        CircleAvatar(
          backgroundColor: Color.fromARGB(221, 223, 223, 223),
          backgroundImage: _imageProvider(),
          radius: 30.0,
        ),
        SizedBox(width: 30),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 15),
          if (userName == "") ...[
            Container(
                margin: EdgeInsets.only(top: 20),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '로그인',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                    ),
                    TextSpan(
                        text: '하세요',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        )),
                  ]),
                )),
          ] else ...[
            Text(
              userName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            )
          ],
          Container(
 
            child: Text(
              userEmail,
              style:
                  TextStyle(fontSize: 13, color: Color.fromARGB(255, 88, 88, 88)
                      ),
            ),
          ),
          SizedBox(height: 30),
        ])
      ]),
      SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              (userName == '')
                  ? Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityListScreen()));
            },
            child: _buildMypageMenuItem(Icons.view_list, "활동내역"),
          ),
          VerticalDivider(thickness: 2, color: Colors.grey),
          InkWell(
            onTap: () {
              (userName == '')
                  ? Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LikeListScreen()));
            },
            child: _buildMypageMenuItem(Icons.favorite, "관심목록"),
          )
        ],
      ),
    ]));
  }

  Widget _buildMypageMenuItem(IconData mIcon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(5),

          child: Icon(
            mIcon,
            color: Color(0xff416E5C),
            size: 30,
          ),
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 20))
      ],
    );
  }

  ImageProvider _imageProvider() {
    if (userPhoto == 'default_profile')
      return AssetImage('assets/images/default_profile.png');
    return Image.file(File(userPhoto)).image;
  }
}
