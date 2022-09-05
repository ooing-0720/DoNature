import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm{
  String? userUID; // 어떤 유저의 알람인지 uid저장
  DocumentReference? alarmReference;

  Alarm({
  this.userUID,
  this.alarmReference
});


Alarm.fromMap(dynamic json){
  userUID = json['userUID'];
}

Map<String,dynamic>toJson(){
  final map = <String, dynamic>{};
  map['userUID'] = userUID;

return map;
}
}



