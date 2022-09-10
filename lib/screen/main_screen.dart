import 'package:donation_nature/alarm/service/alarm_serivce.dart';
import 'package:donation_nature/firebase_options.dart';
import 'package:donation_nature/screen/alarm_screen.dart';
import 'package:donation_nature/screen/chat/chat_list_screen.dart';
import 'package:donation_nature/screen/login_screen.dart';
import 'package:donation_nature/screen/splash_screen.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/info_screen.dart';
import 'package:donation_nature/screen/board_screen.dart';
import 'package:donation_nature/screen/mypage/mypage_screen.dart';
import 'package:donation_nature/screen/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

User? user = UserManage().getUser();
Icon alarmIcon = Icon(Icons.notifications);

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ChatListScreen(),
    BoardScreen(),
    AlarmScreen(),
    MyPageScreen(),
  ];





  
  



void initState(){
        
      }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  // Future alarmIcon(User? user) async {
  //   if (user != null){
  //   bool isunreadalarm = await AlarmService.isUnreadAlarm(userUID: user.uid);
  //   print(isunreadalarm);
  //   if(isunreadalarm == false){
  //       //안 읽은 알람 없음
  //       print('안 읽은 알람 없음');
  //      // alarmIcon = Icons.notifications as Icons;
  //     }
  //     else{
  //       //안 읽은 알람 있음
  //       print('안 읽은 알람 있음');
  //     }
  //   }

  // }

   @override
  Widget build(BuildContext context) {
   // alarmIcon(user);
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: '나눔',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '알람',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '내 정보',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff003300),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
