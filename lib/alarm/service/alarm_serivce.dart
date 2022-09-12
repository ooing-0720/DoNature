import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/models/alarm_model.dart';

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
  }

  //채팅방에서 메세지가 왔을 시 알람
  static void newMsgAlarm(String userUID, String sender, String text) {
    AlarmModel alarm =
        AlarmModel(text: '[새 메세지] ${sender}: ${text}', time: Timestamp.now());
    FirebaseFirestore.instance
        .collection('alarm/${userUID}/alarm_list')
        .add(alarm.toMap());
  }

  //누군가가 내 글에 하트 눌렀을 시 알람
  static void newLikeAlarm(String? otheruser,String post,String userUID) {
    AlarmModel alarm = AlarmModel(
        text: '${otheruser}님이 \'${post}\'에 하트를 눌렀습니다.', time: Timestamp.now());
    FirebaseFirestore.instance
        .collection('alarm/${userUID}/alarm_list')
        .add(alarm.toMap());
  }

}

