import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/models/alarm_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlarmService {
  static final AlarmService _alarmService = AlarmService._internal();
  factory AlarmService({required userUID}) => _alarmService;
  AlarmService._internal();

  //생성
    static Future<DocumentReference> createAlarmList(
      Map<String, dynamic> json, String userUID) async {
    var newAlarmRef = FirebaseFirestore.instance.collection("alarm").doc(userUID);
    await newAlarmRef.set(json);
    return newAlarmRef;
  }
  

  //새로운 채팅방 개설 시 알람
  static void createChattingRoomAlarm(String userUID, String? otheruserUID)async{
    AlarmModel alarmModel = AlarmModel(text: '${otheruserUID}님과의 채팅방이 생성되었습니다.', time: Timestamp.now());
    FirebaseFirestore.instance.collection('alarm/${userUID}/alarm_list').add(alarmModel.toMap());
  }


  //채팅방에서 메세지가 왔을 시 알람
   static void newMsgAlarm(String userUID) {
    AlarmModel alarmModel = AlarmModel(text: '새 메세지가 도착했습니다.', time: Timestamp.now());
    FirebaseFirestore.instance.collection('alarm/${userUID}/alarm_list').add(alarmModel.toMap());
  }

  //누군가가 내 글에 하트 눌렀을 시 알람
    static void newLikeAlarm(String? otheruser, String post, String userUID, ) {
    AlarmModel alarmModel = AlarmModel(text: '${otheruser}님이 ${post}에 하트를 눌렀습니다', time: Timestamp.now());
    FirebaseFirestore.instance.collection('alarm/${userUID}/alarm_list').add(alarmModel.toMap());
  }



}