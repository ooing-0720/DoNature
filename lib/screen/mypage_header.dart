import 'package:donation_nature/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/likelist_screen.dart';
import 'package:donation_nature/activitylist_screen.dart';
import 'package:donation_nature/screen/certify_screen.dart';
import 'package:donation_nature/screen/signup_screen.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyPageHeader extends StatefulWidget {
  const MyPageHeader({Key? key}) : super(key: key);

  @override
  State<MyPageHeader> createState() => MyPageHeaderState();
}

class MyPageHeaderState extends State<MyPageHeader> {
  final UserManage userManage = UserManage();
  String userName = '';
  String userEmail = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Color(0xffE4EFE7),
          //   width: 2,
          // ),
          borderRadius: BorderRadius.circular(30),
          color: Color(0xffFFFFFF),
        ),
        padding: EdgeInsets.all(20),
        child: Column(children: [
          _buildMypageHeader(context),
          _buildMypageMenu(context),
          Divider(
            thickness: 4,
            color: Color(0xffE4EFE7),
          ),
          _buildMypageListView(),
        ]));
  }

  Widget _buildMypageHeader(BuildContext context) {
    User? user = userManage.getUser();

    if (user == null) {
      userName = "로그인하세요";
      userEmail = '';
    } else {
      userName = user.displayName! + '님';
      userEmail = user.email!;
    }

    return Row(children: [
      CircleAvatar(
        backgroundImage: AssetImage('assets/images/splash.png'),
        radius: 40.0,
      ),
      SizedBox(width: 20),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 10),
        if (user == null) ...[
          Container(
              margin: EdgeInsets.only(top: 20),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '로그인',
                    style: TextStyle(
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
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      )),
                ]),
              )),
        ] else ...[
          Text(
            userName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          )
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color(0xffE4EFE7),
          ),
          child: Text(
            userEmail,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(height: 30),
      ])
    ]);
  }

  Widget _buildMypageMenu(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        //mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActivitylistScreen()));
            },
            child: _buildMypageMenuItem(Icons.view_list, "활동내역"),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LikelistScreen()));
            },
            child: _buildMypageMenuItem(Icons.favorite, "관심목록"),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CertifyScreen()));
            },
            child: _buildMypageMenuItem(Icons.badge, "기관인증"),
          ),
        ],
      ),
    );
  }

  Widget _buildMypageMenuItem(IconData mIcon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffE4EFE7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(30)),
          child: FaIcon(
            mIcon,
            color: Color(0xff9fc3a8),
            size: 50,
          ),
        ),
        SizedBox(height: 10),
        Text(text)
      ],
    );
  }

  Widget _buildMypageListView() {
    return ListView(
      children: [
        ListTile(
          title: Container(
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text(
                '환경설정',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )),
          // trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
        ),
        Divider(thickness: 1),
        ListTile(
          title: Container(
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text(
                '회원정보',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )),
          // trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
        Divider(thickness: 1),
        ListTile(
          title: Container(
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text(
                '로그아웃',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )),
          // trailing: Icon(Icons.chevron_right),
          onTap: () => _LogoutDialog(),
        ),
        Divider(thickness: 1)
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }),
            ])
          ]);
        });
  }
}
