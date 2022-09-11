import 'dart:io';
import 'package:donation_nature/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/screen/mypage/likelist_screen.dart';
import 'package:donation_nature/screen/mypage/activitylist_screen.dart';
import 'package:donation_nature/screen/user_manage.dart';
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
      userName = "";
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
    // setState(() {
    //   if (mounted) {
    //     User? user = userManage.getUser();
    //     if (user == null) {
    //       userName = "";
    //       userEmail = '';
    //       userPhoto = 'default_profile';
    //     } else {
    //       userName = user.displayName! + '님';
    //       userEmail = user.email!;
    //       userPhoto = user.photoURL!;
    //     }
    //   }
    // });

    return Container(
        // decoration: BoxDecoration(
        //   color: Color(0xffFFFFFF),
        // ),
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            )
          ],
          Container(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(5),
            //   color: Color(0xff416E5C),
            // ),
            child: Text(
              userEmail,
              style:
                  TextStyle(fontSize: 13, color: Color.fromARGB(255, 88, 88, 88)
                      // decoration: TextDecoration.underline,
                      // decorationColor: Color(0xff416E5C),
                      // decorationThickness: 3
                      ),
            ),
          ),
          SizedBox(height: 30),
        ])
      ]),
      SizedBox(height: 15),
      Row(
        // mainAxisSize: MainAxisSize.max,
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
          // decoration: BoxDecoration(
          //     border: Border.all(
          //       color: Color(0xffbadc58),
          //       width: 2,
          //     ),
          //     borderRadius: BorderRadius.circular(30)),
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

  // Widget _buildMypageMenu(BuildContext context) {
  //   return Container(
  //     margin: EdgeInsets.all(20),
  //     child: Row(
  //       //mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         InkWell(
  //           onTap: () {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => ActivitylistScreen()));
  //           },
  //           child: _buildMypageMenuItem(Icons.view_list, "활동내역"),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => LikelistScreen()));
  //           },
  //           child: _buildMypageMenuItem(Icons.favorite, "관심목록"),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => CertifyScreen()));
  //           },
  //           child: _buildMypageMenuItem(Icons.badge, "기관인증"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  ImageProvider _imageProvider() {
    if (userPhoto == 'default_profile')
      return AssetImage('assets/images/default_profile.png');
    return Image.file(File(userPhoto)).image;
    // return Image.file(File(userPhoto)).image;
  }
}
