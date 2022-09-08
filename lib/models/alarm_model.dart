import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModel{
  final String text;
  final bool read;
  final Timestamp time;
  

  AlarmModel({
	    this.text = '',
      this.read = false,
      Timestamp? time,
	  }): time = time??Timestamp(0,0);


  factory AlarmModel.fromMap({required Map<String,dynamic> map}){
	    return AlarmModel(
      text: map['text']??'',
      read: map['read']??false,
      time: map['time']??Timestamp(0, 0)
	    );
	  } 
	
	  Map<String,dynamic>toMap(){
	    Map<String, dynamic> data = {};
      data['text'] = text;
      data['read'] = read;
	    data['time'] = time;
    return data;
	  }

}