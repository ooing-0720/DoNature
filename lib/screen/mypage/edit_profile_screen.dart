import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/user_manage.dart';

import 'mypage_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => EditProfileScreenState();
}

// class EditProfileScreenState extends State<EditProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//       title: Text('프로필 수정',
//           style: TextStyle(
//             color: Colors.black,
//           )),
//       actions: [
//         IconButton(
//           onPressed: () {},
//           icon: Icon(Icons.notifications),
//         ),
//       ],
//     )
//     body:
//     );
//   }
// }

class EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController profileNameTextEditingController =
      TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  UserManage userManage = UserManage();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  bool loading = false;
  User? user;
  bool _profileNameValid = true;
  bool _bioValid = true;

  updateUserData() {
    setState(() {
      profileNameTextEditingController.text.trim().length < 3 ||
              profileNameTextEditingController.text.isEmpty
          ? _profileNameValid = false
          : _profileNameValid = true;

      bioTextEditingController.text.trim().length > 110 ||
              bioTextEditingController.text.isEmpty
          ? _bioValid = false
          : _bioValid = true;
    });

    // if (_bioValid && _profileNameValid) {
    //   userReference.doc(widget.currentOnlineUserId).update({
    //     'profileName': profileNameTextEditingController.text,
    //     'bio': bioTextEditingController.text,
    //   });

    //   SnackBar successSnackBar = SnackBar(
    //     content: Text('Profile has been updated successfully.'),
    //   );
    //   _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
    // }
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
    return Scaffold(
        key: _scaffoldGlobalKey,
        appBar: AppBar(
          title: Text('프로필 수정',
              style: TextStyle(
                color: Colors.black,
              )),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications),
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
                margin: EdgeInsets.all(50),
                child: Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        //padding: EdgeInsets.only(top: 16, bottom: 7),
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(221, 223, 223, 223),
                          radius: 54,
                          backgroundImage:
                              AssetImage('assets/images/default_profile.png'),

                          // backgroundImage: CachedNetworkImageProvider(user.url),
                        ),
                        Positioned(
                            bottom: 1,
                            right: 1,
                            child: Container(
                                height: 30,
                                width: 30,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))))),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          createProfileNameTextFormField(),
                          createBioTextFormField(),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(0),
                        child: ElevatedButton(
                          onPressed: updateUserData,
                          child: Text('완료'),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xffcddc39)),
                        )),
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
          style: TextStyle(color: Colors.white),
          controller: profileNameTextEditingController,
          decoration: InputDecoration(
              hintText: '변경할 닉네임을 작성하세요.',
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintStyle: TextStyle(color: Colors.grey),
              errorText: _profileNameValid ? null : '길이가 너무 짧습니다.'),
        )
      ],
    );
  }

  createBioTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: Text(
            '전화번호',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.white),
          controller: bioTextEditingController,
          decoration: InputDecoration(
              hintText: '변경할 전화번호를 작성하세요.',
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintStyle: TextStyle(color: Colors.grey),
              errorText: _bioValid ? null : '올바른 형식이 아닙니다.'),
        )
      ],
    );
  }
}
