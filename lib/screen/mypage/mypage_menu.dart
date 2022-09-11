import 'package:donation_nature/screen/main_screen.dart';
import 'package:donation_nature/screen/mypage/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/screen/mypage/edit_profile_screen.dart';
import 'package:donation_nature/screen/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:donation_nature/screen/login_screen.dart';

class MyPageMenu extends StatefulWidget {
  const MyPageMenu({Key? key}) : super(key: key);

  @override
  State<MyPageMenu> createState() => MyPageMenuState();
}

class MyPageMenuState extends State<MyPageMenu> {
  UserManage userManage = UserManage();
  User? user;

  @override
  Widget build(BuildContext context) {
    user = userManage.getUser();
    return Container(
        decoration: BoxDecoration(
          color: Color(0xffFFFFFF),
        ),
        // padding: EdgeInsets.only(top: 10),
        child: buildMypageListView());
  }

  Widget buildMypageListView() {
    return ListView(
      children: [
        // ListTile(
        //   title: Container(
        //       alignment: Alignment.centerLeft,
        //       height: 20,
        //       child: Text(
        //         '알람',
        //         textAlign: TextAlign.start,
        //         style: TextStyle(
        //           fontSize: 15,
        //           fontWeight: FontWeight.w400,
        //         ),
        //       )),
        //   onTap: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => SignUpScreen()));
        //   },
        // ),
        Divider(height: 1),
        ListTile(
          title: Container(
              alignment: Alignment.centerLeft,
              height: 20,
              child: Text(
                '프로필 수정',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              )),
          onTap: () {
            (user == null)
                ? Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen()));
          },
        ),
        Divider(height: 1),
        ListTile(
          title: Container(
              alignment: Alignment.centerLeft,
              height: 20,
              child: Text(
                '비밀번호 변경',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              )),
          // trailing: Icon(Icons.chevron_right),
          onTap: () {
            (user == null)
                ? Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()));
          },
        ),
        Divider(height: 1),
        ListTile(
          title: Container(
              alignment: Alignment.centerLeft,
              height: 20,
              child: Text(
                '로그아웃',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              )),
          onTap: () => (user == null)
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()))
              : _LogoutDialog(),
        ),
      ],
      shrinkWrap: true,
    );
  }

  void _LogoutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(content: Text("정말 로그아웃 하시겠습니까?"), actions: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Color(0xff9fc3a8),
                  ),
                  child: Text('닫기'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Color(0xff9fc3a8),
                  ),
                  child: Text('로그아웃'),
                  onPressed: () {
                    userManage.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen()),
                        (route) => false);
                  }),
            ])
          ]);
        });
  }
}
