import 'package:flutter/material.dart';
import 'package:donation_nature/screen/mypage_header.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  final String userName = "홍길동";
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
      body: Container(
        //color: Color(0xffE4EFE7),
        child: Column(
          // 코드 정리
          children: [
            MyPageHeader(),
          ],
        ),
      ),
    );
  }
}
