import 'package:donation_nature/screen/alarm_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/screen/mypage/mypage_header.dart';
import 'package:donation_nature/screen/mypage/mypage_menu.dart';
import 'package:donation_nature/alarm/service/alarm_serivce.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => MyPageScreenState();
}

User? user;

class MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보',
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(children: [MyPageHeader(), MyPageMenu()]),
      ),
      // backgroundColor: Color(0xffededed),
    );
  }
}
