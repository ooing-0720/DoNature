import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/alarm_model.dart';

class AlarmScreen extends StatelessWidget {
  //final DocumentReference reference;
  AlarmScreen({Key? key}) : super(key: key);
  User? user;


  @override
  Widget build(BuildContext context) {
    List<AlarmModel> alarms =[];
    return Scaffold(
        appBar: AppBar(
          title: Text('알람',
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
        body: StreamBuilder<List<AlarmModel>>(
          stream: streamAlarm(user!.uid),
              builder: (context, asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return const Center(
                    child: Text('오류 발생'),
                  );
                }else{
                  List<AlarmModel> alarms = asyncSnapshot.data!;

                  return Column(children: [
                    Expanded(child: ListView.separated(
          itemCount: alarms.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(alarms[index].text),
              subtitle: Text(alarms[index].time.toDate().toLocal().toString().substring(5,16)),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(thickness: 1);
          },
          shrinkWrap: true,
        ))
                  ],);
                } }));;
  }

  Stream<List<AlarmModel>> streamAlarm(String userUID){
    try {
      final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
          .collection('/alarm/${userUID}/alarm_list')
          .orderBy('time', descending: true)
          .snapshots();
      return snapshots.map((querySnapshot) {
        List<AlarmModel> alarms = [];
        for (var element in querySnapshot.docs) {
          alarms.add(AlarmModel.fromMap(
              //id: element.id,
              map: element.data() as Map<String, dynamic>));
        }
        return alarms;
      });
    } catch (ex) {
      log('error)', error: ex.toString(), stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }
  }

