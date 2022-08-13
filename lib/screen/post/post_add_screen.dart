// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:donation_nature/models/post.dart';

class PostAddScreen extends StatefulWidget {
  const PostAddScreen({Key? key}) : super(key: key);

  @override
  State<PostAddScreen> createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController contentEditingController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("글쓰기"),
          ),
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleEditingController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '제목을 입력하세요',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return "제목은 비워둘 수 없습니다";
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: contentEditingController,
                    maxLines: 20,
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return "내용은 비워둘 수 없습니다";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: '내용을 입력하세요',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          )),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        print("사진 업로드 아직 구현 안 함 img picker 사용 예정");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 100,
                        width: 100,
                        child: Center(child: Icon(Icons.add_a_photo)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              //validation 성공하면 폼 저장하기
                              _formkey.currentState!.save();
                              //사용자입력값 확인
                              print(titleEditingController.text +
                                  ' ' +
                                  contentEditingController.text);

                              //showDialog
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text("게시글을 등록하시겠습니까?"),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            //저장되었습니다 스낵바 띄우기
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text('저장되었습니다')));
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("예")),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("아니오"))
                                    ],
                                  );
                                },
                              );
                            }

                            //포스트 모델에 전달..이거를 어떻게 이어줄지? 서비스를 만들어야하나..?
                            final Post post = Post(
                                title: titleEditingController.text,
                                contents: contentEditingController.text);
                          },
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          child: Text("글쓰기")))
                ],
              ),
            ),
          )),
    );
  }
}
