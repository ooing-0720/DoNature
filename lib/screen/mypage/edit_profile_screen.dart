import 'dart:io';
import 'package:donation_nature/screen/mypage/mypage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';
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
      if (_image == null) {
        _image = user!.photoURL;
      }
      user?.updatePhotoURL(_image);
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

  // @override
  // void initState() {
  //   super.initState();
  //   getAndDisplayUserInformation();
  // }

  // getAndDisplayUserInformation() async {
  //   setState(() {
  //     loading = true;
  //   });

  //   // DB에서 사용자 정보 가져오기
  //   user = userManage.getUser();
  //   // profile, bio 입력란에 사용자 정보로 채워주기
  //   // profileNameTextEditingController.text = user.displayName;
  //   // bioTextEditingController.text = user.bio;

  //   // 셋팅 끝나면 loading은 false로 바뀌고 화면에 값들이 보임
  //   setState(() {
  //     loading = false;
  //   });
  // }

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
                          //padding: EdgeInsets.only(top: 16, bottom: 7),
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
    // 접근 권한인데 갤럭시는 필요없다함?
    // PermissionRequest.getStoragePermission();

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
