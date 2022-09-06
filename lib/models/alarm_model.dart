import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModel{
  final String text;
  final Timestamp time;

  AlarmModel({
	    this.text = '',
      Timestamp? time,
	  }): time = time??Timestamp(0,0);


  factory AlarmModel.fromMap({required Map<String,dynamic> map}){
	    return AlarmModel(
      text: map['text']??'',
      time: map['time']??Timestamp(0, 0)
	    );
	  } 
	
	  Map<String,dynamic>toMap(){
	    Map<String, dynamic> data = {};
      data['text'] = text;
	    data['time'] = time;
    return data;
	  }

}