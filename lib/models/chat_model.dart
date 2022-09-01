import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

	class ChatModel {
	  final String id;
    final String userUID;
	  final String messageText;
	  //final String imageURL;
	  final Timestamp time;
	
	  ChatModel({
	    this.id = '', //채팅 문서 id
      this. userUID = '',
	    this.messageText='',
	    Timestamp? time,
	  }): time = time??Timestamp(0,0);
	
	  factory ChatModel.fromMap({required String id,required Map<String,dynamic> map}){
	    return ChatModel(
	    id: id,
      userUID:  map['userUID']??'',
	    messageText: map['messageText']??'',
      time: map['time']??Timestamp(0, 0)
	    );
	  } 
	
	  Map<String,dynamic>toMap(){
	    Map<String, dynamic> data = {};
      data['userUID'] = userUID;
	    data['messageText'] = messageText;
	    data['time'] = time;
    return data;
	  }}
