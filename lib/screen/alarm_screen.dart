import 'package:donation_nature/alarm/service/alarm_serivce.dart';
import 'package:donation_nature/models/alarm_model.dart';
import 'package:donation_nature/screen/chat/chat_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // _initPostData=
  }

  @override
  Widget build(BuildContext context) {
    User? user = UserManage().getUser();
    return Scaffold(
        appBar: AppBar(
          title: Text("알람 목록"),
        ),
        body: RefreshIndicator(
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
                            onTap: () {
                              /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatDetailScreen(data),
                                  ));*/
                            },
                            child: ListTile(
                              title: Text(
                                "${data.text}",
                                style: TextStyle(fontSize: 17.5),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data.time.toDate().toLocal().toString().substring(5, 16)}",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  /*Transform(
                                    transform: new Matrix4.identity()
                                      ..scale(0.95),
                                    child: Row(
                                      children: [
                                        Chip(
                                          label: Text(
                                            "${data.tagDisaster}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Color(0xff5B7B6E),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Chip(
                                          label: Text(
                                            "${data.locationSiDo}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Color(0xff5B7B6E),
                                        ),
                                      ],
                                    ),
                                  ),*/
                                ],
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
            onRefresh: () {
              return Future(() {
                setState(() {});
              });
            }));
  }
}
