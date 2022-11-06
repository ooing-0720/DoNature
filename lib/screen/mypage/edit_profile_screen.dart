import 'dart:io';
import 'package:donation_nature/board/service/post_service.dart';
import 'package:donation_nature/chat/service/chat_service.dart';
import 'package:donation_nature/screen/mypage/mypage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/mypage/user_manage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nicknameTextEditingController = TextEditingController();
  UserManage userManage = UserManage();

  static final GlobalKey<ScaffoldState> _scaffoldGlobalKey =
      new GlobalKey<ScaffoldState>();

  bool loading = false;
  User? user;
  bool _profileNameValid = true;

  String? _image;

  updateUserData() {
    setState(() {
      nicknameTextEditingController.text.trim().length < 2 ||
              nicknameTextEditingController.text.trim().length > 10 ||
              nicknameTextEditingController.text.isEmpty
          ? _profileNameValid = false
          : _profileNameValid = true;
    });

    if (_profileNameValid) {
      user?.updateDisplayName(nicknameTextEditingController.text);
      // print("profilename ${user!.displayName}");
      PostService().updateNickname(user!);
      ChatService().updateNickname(user!);
//      print(user!.displayName);

      if (_image == null) {
        _image = user!.photoURL;
      }
      user?.updatePhotoURL(_image);
      print("********profile image*******");
      print(_image);
      ChatService().updateProfileImg(user!, _image!);

      Navigator.pop(context);
      SnackBar successSnackBar = SnackBar(
        content: Text('Profile has been updated successfully.'),
      );
      _scaffoldGlobalKey.currentState?.showSnackBar(successSnackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    user = userManage.getUser();
    _image = user?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    user = userManage.getUser();

    return Scaffold(
        key: _scaffoldGlobalKey,
        appBar: AppBar(
          title: Text('프로필 수정',
              style: TextStyle(
                color: Colors.black,
              )),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  updateUserData();
                  //print(user!.displayName);
                },
                child: Text('변경'),
                style: TextButton.styleFrom(
                  primary: Color(0xff416E5C),
                )),
          ],
        ),
        body: Column(
          children: [
            Container(
                margin: EdgeInsets.all(60),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getImageFromGallery(ImageSource.gallery);
                      },
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Color.fromARGB(221, 223, 223, 223),
                            radius: 54,
                            backgroundImage: _imageProvider(),
                          ),
                          Positioned(
                              bottom: 1,
                              right: 1,
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Icon(
                                    Icons.photo_camera,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))))),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      child: createProfileNameTextFormField(),
                    ),
                  ],
                ))
          ],
        ));
  }

  createProfileNameTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: Text(
            '닉네임',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: nicknameTextEditingController,
          decoration: InputDecoration(
              hintText: user!.displayName,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              hintStyle: TextStyle(color: Colors.grey),
              errorText: _profileNameValid ? null : '2-10자로 입력해주세요.'),
        )
      ],
    );
  }

  Future getImageFromGallery(ImageSource source) async {
    var image = await ImagePicker()
        .pickImage(source: source, imageQuality: 100, maxWidth: 150);

    setState(() {
      if (image != null) {
        _image = image.path;
      }
    });
  }

  ImageProvider _imageProvider() {
    if (_image == 'default_profile')
      return AssetImage('assets/images/default_profile.png');

    return Image.file(File(_image!)).image;
  }
}
