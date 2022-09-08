import 'package:donation_nature/action/action.dart';
import 'package:donation_nature/firebase_options.dart';
import 'package:donation_nature/screen/api_info.dart';
import 'package:donation_nature/screen/main_screen.dart';
import 'package:donation_nature/screen/splash_screen.dart';
import 'package:donation_nature/screen/weather_disaster_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/screen/info_screen.dart';
import 'package:donation_nature/screen/board_screen.dart';
import 'package:donation_nature/screen/mypage/mypage_screen.dart';
import 'package:donation_nature/screen/home_screen.dart';
import 'screen/chat/chat_detail_screen.dart';
import 'screen/chat/chat_list_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  runApp(const MyApp());
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
    return FutureBuilder(
        future: Init.instance.initialize(context),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(home: SplashScreen());
          } else if (snapshot.hasError) {
            print('error');
            return MaterialApp(home: SplashScreen()); // 초기 로딩 에러 시 Error Screen
          } else {
            FlutterNativeSplash.remove();
            return MaterialApp(
              theme: ThemeData(
                  // primaryColor: Color.fromARGB(255, 7, 65, 29),

                  appBarTheme: AppBarTheme(
                      elevation: 1.0,
                      centerTitle: true,
                      color: Colors.white,
                      iconTheme: IconThemeData(color: Colors.black),
                      titleTextStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
              title: _title,
              home: snapshot.data!,
            );
            // 초기 로딩 시 Splash Screen
          }
        });
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future<Widget> initialize(BuildContext context) async {
    // await Future.delayed(Duration(milliseconds: 1000));

    // . . .
    // 초기 로딩 작성
    // . . .

    WthrReport wthrReport = WthrReport();
    MainAction _mainAction = MainAction();

    Static.wthrInfoList = await wthrReport.getWthrInfo();
    String? result = await _mainAction.getAddress();
    var location = result.split(' ');
    Static.userLocation = location[1] + ' ' + location[2] + ' ' + location[3];
    Static.reportList = await wthrReport.getWeatherReport();
    // 초기 로딩 완료 시 띄울 앱 첫 화면

    return MainScreen();
  }
}

// return MaterialApp(
//   theme: ThemeData(
//       // primaryColor: Color.fromARGB(255, 7, 65, 29),

//       appBarTheme: AppBarTheme(
//           elevation: 1.0,
//           centerTitle: true,
//           color: Colors.white,
//           iconTheme: IconThemeData(color: Colors.black),
//           titleTextStyle: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 18))),
//   title: _title,
//   home: MyStatefulWidget(),

//     );
//   }
// }

// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key? key}) : super(key: key);

//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }

// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static List<Widget> _widgetOptions = <Widget>[
//     HomeScreen(),
//     InfoScreen(),
//     ChatListScreen(),
//     BoardScreen(),
//     MyPageScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: '홈',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.library_books_outlined),
//             label: '재난',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat_outlined),
//             label: '채팅',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.library_books_outlined),
//             label: '나눔',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             label: '내 정보',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Color(0xff003300),
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }
