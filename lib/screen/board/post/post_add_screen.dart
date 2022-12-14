import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:donation_nature/media/media.dart';
import 'package:donation_nature/screen/board/board_screen.dart';
import 'package:donation_nature/mypage/user_manage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:donation_nature/board/domain/post.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:donation_nature/screen/board/post/location_list.dart';
import 'package:donation_nature/screen/home/disaster_list.dart';

class PostAddScreen extends StatefulWidget {
  const PostAddScreen(this.share);
  final int share;
  @override
  State<PostAddScreen> createState() => _PostAddScreenState();
}

class _PostAddScreenState extends State<PostAddScreen> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController contentEditingController = TextEditingController();
  TextEditingController itemEditingController = TextEditingController();
  TextEditingController itemCntEditingController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();

  Media _media = Media();
  User? user = UserManage().getUser();
  //List<String> tagMoreList = ['나눔하기', '나눔받기', '알리기'];
  List<String> locationGuList = [];
  String? _selectedDo = null;
  String? _selectedGu = null;
  bool image = false;
  int selectedDisasterIndex = -1;
  int? getShare;
  // int selectedTagIndex = -1;
  var _editedPost;

  @override
  void initState() {
    super.initState();
    getShare = widget.share;
    _editedPost = Post(share: getShare);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Container(
              child: Builder(builder: (context) {
                if (getShare == 0) {
                  return Text("나눔하기");
                } else if (getShare == 1)
                  return Text("나눔받기");
                else
                  return Text("알리기");
              }),
            ),
          ),
          body: postForm()),
    );
  }

  Form postForm() {
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "제목",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: titleEditingController,
              onChanged: (nextText) {
                setState(() {
                  titleEditingController.text = nextText.substring(0, 24);
                  titleEditingController.selection =
                      TextSelection.fromPosition(TextPosition(offset: 24));
                });
              },
              inputFormatters: [LengthLimitingTextInputFormatter(24)],
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
            // Divider(
            //   height: 20,
            //   thickness: 1.5,
            // ),
            SizedBox(
              height: 20,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 5, right: 5),
            //   child: Row(
            //     children: [
            //       Icon(
            //         Icons.label,
            //         color: Color(0xff416E5C),
            //       ),
            //       SizedBox(width: 12),
            //       Wrap(
            //         spacing: 12,
            //         children: List<Widget>.generate(
            //           tagMoreList.length,
            //           (int index) {
            //             return ChoiceChip(
            //               backgroundColor: Colors.grey.withOpacity(0.5),
            //               selectedColor: Color(0xff416E5C),
            //               label: Text(
            //                 tagMoreList[index],
            //                 style: TextStyle(color: Colors.white),
            //               ),
            //               selected: selectedTagIndex == index,
            //               onSelected: (bool selected) {
            //                 setState(() {
            //                   selectedTagIndex = selected ? index : -1;
            //                   _editedPost.tagMore = tagMoreList[index];
            //                 });
            //               },
            //             );
            //           },
            //         ).toList(),
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(
            //   height: 20,
            //   thickness: 1.5,
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "사진",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
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
                                  _editedPost.imageUrl =
                                      await _media.uploadImage(
                                          ImageSource.camera,
                                          titleEditingController.text.hashCode
                                              .toString());

                                  setState(() {
                                    image = true;
                                    Navigator.pop(context);
                                  });
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
                                  // 갤러리에서 가져오기 - 4sec
                                  _editedPost.imageUrl =
                                      await _media.uploadImage(
                                          ImageSource.gallery,
                                          titleEditingController.text.hashCode
                                              .toString());

                                  setState(() {
                                    print(_editedPost.imageUrl);
                                    image = true;
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
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 80,
                        width: 80,
                        child: Center(
                          child: Icon(Icons.add_to_photos,
                              color: Color(0xff416E5C)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: _editedPost.imageUrl != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Stack(children: [
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "${_editedPost.imageUrl}")),
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                              ),
                              Positioned(
                                  child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _editedPost.imageUrl = null;
                                  });
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.black.withOpacity(0.5),
                                  size: 18,
                                ),
                              ))
                            ]),
                          )
                        : Container()),
                // Divider(
                //   height: 20,
                //   thickness: 1.5,
                // ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "위치",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: Color(0xff416E5C),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    locationDropdown(),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                getShare != 2
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "품목/수량",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                controller: itemEditingController,
                                decoration: InputDecoration(
                                  hintText: '품목을 입력하세요',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.red),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                                validator: (String? val) {
                                  if (val!.isEmpty) {
                                    return "품목은 비워둘 수 없습니다";
                                  }
                                },
                              )),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                  child: TextFormField(
                                controller: itemCntEditingController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '수량을 입력하세요',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.red),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                                validator: (String? val) {
                                  if (val!.isEmpty) {
                                    return "수량은 비워둘 수 없습니다";
                                  }
                                },
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 5,
                      ),

                Text(
                  "내용",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
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
            Text(
              "재난",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: disasterChips()),
            ),
            Divider(
              height: 20,
              thickness: 1.5,
            ),
            Center(child: uploadButton())
          ],
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
                _editedPost.locationSiDo = _selectedDo;
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
                _editedPost.locationGuGunSi = _selectedGu;
              });
            },
          ),
        ),
      ],
    );
  }

  TextFormField titleForm() {
    return TextFormField(
      controller: titleEditingController,
      onChanged: (nextText) {
        setState(() {
          titleEditingController.text = nextText.substring(0, 24);
          titleEditingController.selection =
              TextSelection.fromPosition(TextPosition(offset: 24));
        });
      },
      inputFormatters: [LengthLimitingTextInputFormatter(24)],
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

  TextFormField contentForm() {
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

  ElevatedButton uploadButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate() &&
              selectedDisasterIndex != -1 &&
              //   selectedTagIndex != -1 &&
              (_editedPost.locationSiDo != '' &&
                  _editedPost.locationGuGunSi != '')) {
            //validation 성공하면 폼 저장하기
            _formkey.currentState!.save();
            addPost();
          } else if (_formkey.currentState!.validate() &&
              selectedDisasterIndex == -1) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('재난태그를 지정해주세요.')));
          } else if (_formkey.currentState!.validate() &&
              selectedDisasterIndex != -1 &&
              (_editedPost.locationSiDo == '' ||
                  _editedPost.locationGuGunSi == '')) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('위치태그를 지정해주세요.')));
          }
          // else if (_formkey.currentState!.validate() &&
          //     selectedTagIndex == -1) {
          //   ScaffoldMessenger.of(context)
          //       .showSnackBar(SnackBar(content: Text('글 종류를 지정해주세요.')));
          // }
        },
        style: ElevatedButton.styleFrom(primary: Color(0xff416E5C)),
        child: Text("글쓰기"));
  }

  List<Widget> disasterChips() {
    List<Widget> chips = [];
    for (int i = 0; i < disasterList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          backgroundColor: Colors.grey.withOpacity(0.5),
          selectedColor: Color(0xff416E5C),
          selected: selectedDisasterIndex == i,
          onSelected: (bool value) {
            setState(() {
              selectedDisasterIndex = i;
              _editedPost.disaster = disasterList[selectedDisasterIndex];
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

  void addPost() {
    PostService _postService = PostService();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("게시글을 등록하시겠습니까?"),
          actions: [
            ButtonTheme(
                minWidth: 20.0,
                child: FlatButton(
                    onPressed: () {
                      _editedPost.date = Timestamp.now();
                      DateTime datetime = _editedPost.date!.toDate();
                      _editedPost.content = contentEditingController.text;
                      _editedPost.title = titleEditingController.text;

                      _editedPost.writer = user?.displayName;
                      _editedPost.date = Timestamp.now();
                      _editedPost.writerUID = user?.uid;
                      _editedPost.share = getShare;
                      if (getShare != 2) {
                        _editedPost.item = itemEditingController.text;
                        _editedPost.itemCnt = itemCntEditingController.text;
                      }

                      // Firebase 연동
                      _postService.createPost(_editedPost.toJson());

                      //저장되었습니다 스낵바 띄우기
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('저장되었습니다')));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoardScreen(),
                          )).then((value) {
                        setState(() {});
                      });
                    },
                    child: Text(
                      "예",
                      style: TextStyle(color: Color(0xff416E5C)),
                    ))),
            ButtonTheme(
              minWidth: 20.0,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("아니오", style: TextStyle(color: Color(0xff416E5C))),
              ),
            )
          ],
        );
      },
    );
  }
}
