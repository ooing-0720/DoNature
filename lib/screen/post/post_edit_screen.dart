// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:donation_nature/media/media.dart';
import 'package:donation_nature/screen/board_screen.dart';
import 'package:donation_nature/screen/post/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:donation_nature/screen/location_list.dart';
import '../disaster_list.dart';

class PostEditScreen extends StatefulWidget {
  final Post post;

  const PostEditScreen({required this.post});

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  late TextEditingController titleEditingController;
  late TextEditingController contentEditingController;
  int selectedIndex = -1;
  List<String> locationGuList = [];
  String? _selectedDo = null;
  String? _selectedGu = null;
  final GlobalKey<FormState> _formkey = GlobalKey();
  Media _media = Media();
  @override
  void initState() {
    super.initState();
    titleEditingController = TextEditingController(text: widget.post.title);
    contentEditingController = TextEditingController(text: widget.post.content);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("글 수정하기")),
        body: Form(
          key: _formkey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleEditForm(),
                Divider(
                  height: 20,
                  thickness: 1.5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () async {
                                      // 카메라에서 가져오기
                                      widget.post.imageUrl =
                                          await _media.uploadImage(
                                              ImageSource.camera,
                                              titleEditingController
                                                  .text.hashCode
                                                  .toString());

                                      setState(() {
                                        print(widget.post.imageUrl);
                                        //image = true;

                                        Navigator.pop(context);
                                      });
                                      ;
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.photo_camera),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text("카메라에서 가져오기")
                                      ],
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () async {
                                      // 갤러리에서 가져오기
                                      widget.post.imageUrl =
                                          await _media.uploadImage(
                                              ImageSource.gallery,
                                              titleEditingController
                                                  .text.hashCode
                                                  .toString());

                                      setState(() {
                                        print(widget.post.imageUrl);
                                        //image = true;
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.image),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text("갤러리에서 가져오기")
                                      ],
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 80,
                        width: 80,
                        child: Center(child: Icon(Icons.add_to_photos)),
                      ),
                    ),
                    Container(
                        child: widget.post.imageUrl != null
                            ? Stack(children: [
                                Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${widget.post.imageUrl}")),
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  height: 400,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                Positioned(
                                    child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.post.imageUrl = null;
                                      print(widget.post.imageUrl);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.black.withOpacity(0.5),
                                    size: 18,
                                  ),
                                ))
                              ])
                            : Container(
                                child: Text("dd"),
                              )),
                    Divider(
                      height: 20,
                      thickness: 1.5,
                    ),
                    Row(
                      children: [
                        Chip(
                          backgroundColor: Color(0xff9fc3a8),
                          label:
                              Text("위치", style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        locationDropdown(),
                      ],
                    ),
                  ],
                ),
                contentEditForm(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Icon(Icons.local_offer),
                          SizedBox(width: 10),
                          Text("재난 태그: ")
                        ],
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: disasterChips()),
                ),
                Divider(
                  height: 20,
                  thickness: 1.5,
                ),
                Center(child: editButton(context))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row locationDropdown() {
    return Row(
      children: [
        Container(
          width: 100,
          child: DropdownButton(
            hint: Text("시/도"),
            value: _selectedDo,
            isExpanded: true,
            items: locationDoList.map((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
            onChanged: (dynamic value) {
              if (value == '서울') {
                locationGuList = locationGuSeoulList;
              } else if (value == '부산') {
                locationGuList = locationGuBusanList;
              } else if (value == '대구') {
                locationGuList = locationGuDaeguList;
              } else if (value == '인천') {
                locationGuList = locationGuIncheonList;
              } else if (value == '광주') {
                locationGuList = locationGuGwangjuList;
              } else if (value == '대전') {
                locationGuList = locationGuDaejeonList;
              } else if (value == '울산') {
                locationGuList = locationGuUlsanList;
              } else if (value == '세종') {
                locationGuList = locationGuSejongList;
                //전체로만
              } else if (value == '경기') {
                locationGuList = locationSiGyeonggiList;
              } else if (value == '강원') {
                locationGuList = locationSiGangwonList;
              } else if (value == '충북') {
                locationGuList = locationSiChungbukList;
              } else if (value == '충남') {
                locationGuList = locationSiChungnamList;
              } else if (value == '전북') {
                locationGuList = locationSiJeonbukList;
              } else if (value == '전남') {
                locationGuList = locationSiJeonnamList;
              } else if (value == '경북') {
                locationGuList = locationSiGyeongbukList;
              } else if (value == '경남') {
                locationGuList = locationSiGyeongnamList;
              } else if (value == '제주') {
                locationGuList = locationSiJejuList;
              }
              setState(() {
                _selectedDo = value;
                _selectedGu = null;
                widget.post.locationSiDo = _selectedDo;
              });
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 100,
          child: DropdownButton(
            hint: Text("구/군/시"),
            value: _selectedGu,
            isExpanded: true,
            items: locationGuList.map((String value) {
              return DropdownMenuItem(value: value, child: Text(value));
            }).toList(),
            onChanged: (dynamic value) {
              setState(() {
                _selectedGu = value;
                widget.post.locationGuGunSi = _selectedGu;
              });
            },
          ),
        ),
      ],
    );
  }

  TextFormField contentEditForm() {
    return TextFormField(
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
    );
  }

  TextFormField titleEditForm() {
    return TextFormField(
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
    );
  }

  ElevatedButton editButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate() &&
              selectedIndex != -1 &&
              (widget.post.locationSiDo != null ||
                  widget.post.locationGuGunSi != null)) {
            //validation 성공하면 폼 저장하기
            _formkey.currentState!.save();
            editPost();
          } else if (_formkey.currentState!.validate() && selectedIndex == -1) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('재난태그 지정필요')));
          } else if (_formkey.currentState!.validate() &&
              selectedIndex != -1 &&
              widget.post.locationSiDo == null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('위치태그 지정필요')));
          }
        },
        style: ElevatedButton.styleFrom(primary: Color(0xff9fc3a8)),
        child: Text("글 수정하기"));
  }

  List<Widget> disasterChips() {
    List<Widget> chips = [];
    for (int i = 0; i < disasterList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          backgroundColor: Color(0xff9fc3a8),
          selectedColor: Color.fromARGB(255, 7, 65, 29),
          selected: selectedIndex == i,
          onSelected: (bool value) {
            setState(() {
              selectedIndex = i;
              widget.post.tagDisaster = disasterList[selectedIndex];
            });
          },
          label: Text(
            disasterList[i],
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  void editPost() {
    PostService _postService = PostService();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("게시글을 수정하시겠습니까?"),
          actions: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(40, 40),
                  primary: Color(0xff9fc3a8),
                ),
                onPressed: () {
                  widget.post.date = Timestamp.now();
                  DateTime datetime = widget.post.date!.toDate();
                  widget.post.content = contentEditingController.text;
                  widget.post.title = titleEditingController.text;
                  widget.post.date = Timestamp.now();

                  // Firebase 연동
                  _postService.updatePost(
                      reference: widget.post.reference!,
                      json: widget.post.toJson());

                  //저장되었습니다 스낵바 띄우기
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('저장되었습니다')));

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostDetailScreen(widget.post)));
                },
                child: Text("예")),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(40, 40),
                  primary: Color(0xff9fc3a8),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("아니오"))
          ],
        );
      },
    );
  }
}
