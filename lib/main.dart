import 'package:donation_nature/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/screen/chat/chat_screen.dart';
import 'package:donation_nature/screen/info_screen.dart';
import 'package:donation_nature/screen/board_screen.dart';
import 'package:donation_nature/screen/mypage_screen.dart';
import 'package:donation_nature/screen/home_screen.dart';

import 'screen/chat/chat_detail_screen.dart';

void main() async {
  runApp(const MyApp());

  // firebase 초기화
  WidgetsFlutterBinding.ensureInitialized;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'DONATURE';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color.fromARGB(255, 7, 65, 29), // 임의로 지정
          appBarTheme: AppBarTheme(
              centerTitle: true,
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18))),
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    InfoScreen(),
    ChatDetailScreen(userName: 'test'),
    BoardScreen(),
    MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: '재난',
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
            icon: Icon(Icons.person_outline),
            label: '내 정보',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 7, 65, 29),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
