import 'package:donation_nature/action/action.dart';
import 'package:donation_nature/firebase_options.dart';
import 'package:donation_nature/screen/api_info.dart';
import 'package:donation_nature/screen/main_screen.dart';
import 'package:donation_nature/screen/splash_screen.dart';
import 'package:donation_nature/screen/weather_disaster_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
            return SplashScreen();
          } else if (snapshot.hasError) {
            return MaterialApp(home: SplashScreen());
          } else {
            FlutterNativeSplash.remove();
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  fontFamily: 'Pretendard',
                  scaffoldBackgroundColor: Colors.white,
                  appBarTheme: AppBarTheme(
                      elevation: 1.0,
                      color: Colors.white,
                      iconTheme: IconThemeData(color: Colors.black),
                      titleTextStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
              title: _title,
              home: snapshot.data!,
            );
          }
        });
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future<Widget> initialize(BuildContext context) async {
    WthrReport wthrReport = WthrReport();
    MainAction _mainAction = MainAction();

    final position = await _mainAction.getPosition();

    Static.wthrInfoList = await wthrReport.getWthrInfo(position);
    String? result = await _mainAction.getAddress(position);
    var location = result.split(' ');
    Static.userLocation = location[1] + ' ' + location[2] + ' ' + location[3];
    Static.reportList = await wthrReport.getWeatherReport();

    return MainScreen();
  }
}
