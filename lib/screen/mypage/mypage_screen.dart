import 'package:flutter/material.dart';
import 'package:donation_nature/screen/mypage/mypage_header.dart';
import 'package:donation_nature/screen/mypage/mypage_menu.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => MyPageScreenState();
}

class MyPageScreenState extends State<MyPageScreen> {
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
        child: Column(children: [MyPageHeader(), MyPageMenu()]),
      ),
      // backgroundColor: Color(0xffededed),
    );
  }
}
