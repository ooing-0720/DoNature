import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/alarm/domain/alarm.dart';
import 'package:donation_nature/models/alarm_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlarmService {
  static final AlarmService _alarmService = AlarmService._internal();
  factory AlarmService({required userUID}) => _alarmService;
  AlarmService._internal();

  //생성
  static Future<DocumentReference> createAlarmList(
      Map<String, dynamic> map, String userUID) async {
    var newAlarmRef =
        FirebaseFirestore.instance.collection("alarm").doc(userUID);
    await newAlarmRef.set(map);
    return newAlarmRef;
  }

  //알람 목록 출력 및 알람 읽음 처리
  static Future<List<AlarmModel>> getAlarms(String userUID) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('/alarm/${userUID}/alarm_list');

    //알람 목록 출력
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.orderBy("time", descending: true).get();

    List<AlarmModel> alarms = [];
    for (var element in querySnapshot.docs) {
      var alarm =
          AlarmModel.fromMap(map: element.data() as Map<String, dynamic>);
      alarms.add(alarm);

    //알람 읽음 처리
    collectionReference
        .where("read", isEqualTo: false)
        .get()
        .then((QuerySnapshot qs) {
      for (var element in qs.docs) {
        element.reference.update({"read": true});
      }
    });
     
    }

    return alarms;
  }

  //새로운 채팅방 개설 시 알람
  static void createChattingRoomAlarm(
      String userUID, String? writerUID, String? userName, String? writer) {
    AlarmModel alarmforUser =
        AlarmModel(text: '${writer}님과의 채팅방이 생성되었습니다.', time: Timestamp.now());
    AlarmModel alarmforWriter =
        AlarmModel(text: '${userName}님과의 채팅방이 생성되었습니다.', time: Timestamp.now());
    FirebaseFirestore.instance
        .collection('alarm/${userUID}/alarm_list')
        .add(alarmforUser.toMap());
    FirebaseFirestore.instance
        .collection('alarm/${writerUID}/alarm_list')
        .add(alarmforWriter.toMap());
   // isUnreadAlarm(userUID: userUID);
  }

  //채팅방에서 메세지가 왔을 시 알람
  static void newMsgAlarm(String userUID, String sender, String text) {
    AlarmModel alarm =
        AlarmModel(text: '[새 메세지] ${sender}: ${text}', time: Timestamp.now());
    FirebaseFirestore.instance
        .collection('alarm/${userUID}/alarm_list')
        .add(alarm.toMap());
    //isUnreadAlarm(userUID: userUID);
  }

  //누군가가 내 글에 하트 눌렀을 시 알람
  static void newLikeAlarm(String? otheruser,String post,String userUID) {
    AlarmModel alarm = AlarmModel(
        text: '${otheruser}님이 \'${post}\'에 하트를 눌렀습니다.', time: Timestamp.now());
    FirebaseFirestore.instance
        .collection('alarm/${userUID}/alarm_list')
        .add(alarm.toMap());
    //isUnreadAlarm(userUID: userUID);
  }



//  //안 읽은 알람 유무에 따라 알람 아이콘 표시
//   static Future<String> isUnreadAlarm({required String userUID})async{
//     CollectionReference<Map<String, dynamic>> collectionReference =
//         FirebaseFirestore.instance.collection('/alarm/${userUID}/alarm_list');

//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionReference
//         .where("read", isEqualTo: false)
//         .get();

//     String alarm = '없음';
//     //안 읽은 알람이 없을 경우 false
//     if(querySnapshot.size == 0) {
//       //alarmIcon = Icon(Icons.notifications);
//       print(alarm);
//     }
//     else{
//           //안 읽은 알람이 있을 경우 true
//     //alarmIcon = Icon(Icons.notifications_on);
//     alarm = '있음';
//     print(alarm);
//     }
//   return alarm;
// }

}

