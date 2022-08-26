import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/models/chat_model.dart';

class ChatTest extends StatefulWidget{
  const ChatTest({Key? key}) : super(key: key);

  @override
  State<ChatTest> createState() => _ChatTest();
}

class _ChatTest extends State<ChatTest> {
  TextEditingController controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅'),
      ),
      body: StreamBuilder<List<ChatModel>>(
          stream: streamChat(),
          builder:(context, asyncSnapshot){
            if(!asyncSnapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            }else if (asyncSnapshot.hasError){
              return const Center(child:Text('오류 발생'),);
            }else {
              List<ChatModel> chats = asyncSnapshot.data!;
              return Column(children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(chats[index].messageText),
                            subtitle: Text(chats[index].time.toDate().toLocal().toString().substring(5,16)),
                      );
                    }),
                  ),  getInputWidget()]);}
  })  
    );
  }

  Widget getInputWidget() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(color: Colors.black12, offset: Offset(0, -2), blurRadius: 3)
      ], color: Theme.of(context).bottomAppBarColor),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 15),
                  labelText: "내용을 입력하세요..",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.black26,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            RawMaterialButton(
              onPressed: _onPressedSendingButton, //전송버튼을 누를때 동작시킬 메소드
              constraints: BoxConstraints(
                minWidth: 0,
                minHeight: 0
              ),
              elevation: 2,
              fillColor: Theme.of(context).colorScheme.primary,
              shape: CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.send),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onPressedSendingButton(){
    try{
      ChatModel chatModel = ChatModel(messageText: controller.text,time: Timestamp.now());
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection('/chattingroom_list/TRyiSq9MTxcJiao5TcHL/message_list').add(chatModel.toMap());

    }catch(ex){
      log('error)',error: ex.toString(),stackTrace: StackTrace.current);
    }
  }
}
  

Stream<List<ChatModel>> streamChat(){
    try{

      final Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance.collection('chatrooms/YLCoRBj59XRsDdav2YV1/messages').orderBy('time').snapshots();
      return snapshots.map((querySnapshot){
        List<ChatModel> chats = [];
        querySnapshot.docs.forEach((element) { 
          chats.add(
              ChatModel.fromMap(
                  id:element.id,
                  map:element.data() as Map<String, dynamic>
              )
          );
        });
        return chats; 
      });
    }catch(ex){
      log('error)',error: ex.toString(),stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }

  }
