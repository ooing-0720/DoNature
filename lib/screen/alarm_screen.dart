import 'package:donation_nature/alarm/service/alarm_serivce.dart';
import 'package:donation_nature/models/alarm_model.dart';
import 'package:donation_nature/screen/mypage/mypage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:donation_nature/main.dart' as main;

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  User? user = UserManage().getUser();
  bool mustPop = true;
  @override
  void initState() {
    super.initState();
    main.openAlarmScreen = true;
    AlarmService.readAlarm(
      userUID: user!.uid,
    );
    // _initPostData=
  }

  @override
  Widget build(BuildContext context) {
    User? user = UserManage().getUser();
    return WillPopScope(
        onWillPop: () async {
          return mustPop;
        },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  main.openAlarmScreen = false;
                },
              ),
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
                      return ListView.builder(
                        itemCount: alarms.length,
                        itemBuilder: (BuildContext context, int index) {
                          AlarmModel data = alarms[index];

                          return Card(
                            child: GestureDetector(
                              child: ListTile(
                                title: Text(
                                  "${data.text}",
                                  style: TextStyle(fontSize: 17.5),
                                ),
                                subtitle: Text(
                                  "${data.time.toDate().toLocal().toString().substring(5, 16)}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      print('${snapshot.error}');
                      return Text('${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            )));
  }
}
