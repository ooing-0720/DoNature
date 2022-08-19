import 'package:donation_nature/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/likelist_screen.dart';
import 'package:donation_nature/activitylist_screen.dart';
import 'package:donation_nature/screen/certify_screen.dart';
import 'package:donation_nature/screen/signup_screen.dart';

class MyPageHeader extends StatelessWidget {
  const MyPageHeader({Key? key}) : super(key: key);

  final String userName = "홍길동";
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
          _buildMypageHeader(),
          _buildMypageMenu(context),
          Divider(
            thickness: 4,
            color: Color(0xffE4EFE7),
          ),
          MypageList(),
        ]));
  }

  Widget _buildMypageHeader() {
    return Row(children: [
      CircleAvatar(
        backgroundImage: AssetImage('assets/images/splash.png'),
        radius: 40.0,
      ),
      SizedBox(width: 20),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 10),
        Text(
          userName + '님',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color(0xffE4EFE7),
          ),
          child: Text(
            'gildong@mail.com',
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
          child: Icon(
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
}

class MypageList extends StatefulWidget {
  _MypageListState createState() {
    return _MypageListState();
  }
}

class _MypageListState extends State<MypageList> {
  @override
  Widget build(BuildContext context) {
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
                    Navigator.pop(context);
                  }),
            ])
          ]);
        });
  }
}
