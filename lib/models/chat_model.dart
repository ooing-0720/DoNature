import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

	class ChatModel {
	  final String id;
	  //final String name;
	  final String messageText;
	  //final String imageURL;
	  final Timestamp time;
	
	  ChatModel({
	    this.id = '',
	    //this.name = '',
	    this.messageText='',
	    Timestamp? time,
	  }): time = time??Timestamp(0,0);
	
	  factory ChatModel.fromMap({required String id,required Map<String,dynamic> map}){
	    return ChatModel(
	      id: id,
      //name: name,
	      messageText: map['messageText']??'',
      time: map['time']??Timestamp(0, 0)
	    );
	  } 
	
	  Map<String,dynamic>toMap(){
	    Map<String, dynamic> data = {};
	    data['messageText'] = messageText;
	    data['time'] = time;
    return data;
	  }}
