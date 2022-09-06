import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm{
  DocumentReference? alarmReference;
  String? userEmail;


  Alarm({
  this.alarmReference,
  this.userEmail

});

factory Alarm.fromMap({required Map<String,dynamic> map}){
	    return Alarm(
        userEmail:  map['userEmail']??''
	    );
	  } 
	
 Map<String,dynamic>toMap(){
	    Map<String, dynamic> data = {};
      data['userEmail'] = userEmail;
    return data;
	  }	 
}



