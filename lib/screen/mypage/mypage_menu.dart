import 'package:donation_nature/mypage/login_platform.dart';
import 'package:donation_nature/screen/main_screen.dart';
import 'package:donation_nature/screen/mypage/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/screen/mypage/edit_profile_screen.dart';
import 'package:donation_nature/screen/mypage/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/mypage/user_manage.dart';
import 'package:donation_nature/screen/mypage/login_screen.dart';

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
        child: buildMypageListView());
  }

  Widget buildMypageListView() {
    return ListView(
      children: [
        Divider(height: 1, thickness: 1),
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
                            builder: (context) => EditProfileScreen()))
                    .then((value) {
                    setState(() {});
                  });
          },
        ),
        Divider(height: 1, thickness: 1),
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
        Divider(height: 1, thickness: 1),
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
        Divider(height: 1, thickness: 1),
      ],
      shrinkWrap: true,
    );
  }

  void _LogoutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            content: Text("정말 로그아웃 하시겠습니까?"),
            actions: [
              ButtonTheme(
                minWidth: 20.0,
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "닫기",
                      style: TextStyle(color: Color(0xff416E5C)),
                    )),
              ),
              ButtonTheme(
                minWidth: 20,
                child: FlatButton(
                    onPressed: () {
                      userManage.signOut();
                      userManage.setLoginPlatForm(LoginPlatform.none);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MainScreen()),
                          (route) => false);
                    },
                    child: Text(
                      "로그아웃",
                      style: TextStyle(color: Color(0xff416E5C)),
                    )),
              ),
            ],
          );
        });
  }
}
