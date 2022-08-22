import 'package:flutter/material.dart';
import 'package:donation_nature/screen/mypage_header.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:donation_nature/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => MyPageScreenState();
}

class MyPageScreenState extends State<MyPageScreen> {
  UserManage userManage = UserManage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보',
            style: TextStyle(
              color: Colors.black,
            )),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: MyPageHeader(),
      ),
    );
  }
}
