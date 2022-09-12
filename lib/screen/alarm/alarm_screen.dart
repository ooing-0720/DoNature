import 'package:donation_nature/alarm/service/alarm_serivce.dart';
import 'package:donation_nature/models/alarm_model.dart';
import 'package:donation_nature/screen/mypage/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/mypage/user_manage.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  User? user = UserManage().getUser();

  @override
  void initState() {
    super.initState();
  }

//알람 목록 출력
  @override
  Widget build(BuildContext context) {
    return user != null
        ? Scaffold(
            appBar: AppBar(
              title: Text("알람 목록"),
            ),
            body: RefreshIndicator(
              onRefresh: () {
                return Future(() {
                  setState(() {});
                });
              },
              child: FutureBuilder<List<AlarmModel>>(
                  future: AlarmService.getAlarms(user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<AlarmModel> alarms = snapshot.data!;
                      return ListView.separated(
                          itemCount: alarms.length,
                          itemBuilder: (BuildContext context, int index) {
                            AlarmModel data = alarms[index];

                            return GestureDetector(
                              child: ListTile(
                                title: Text(
                                  "${data.text}",
                                  style: TextStyle(fontSize: 17.5),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  "${data.time.toDate().toLocal().toString().substring(5, 16)}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(thickness: 1);
                          });
                    } else if (snapshot.hasError) {
                      print('${snapshot.error}');
                      return Text('${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ))
        : LoginScreen();
    //비회원이면 로그인 페이지로 이동
  }
}
