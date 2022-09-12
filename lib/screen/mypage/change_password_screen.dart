import 'package:donation_nature/screen/user_manage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _passwordTextEditingController = TextEditingController();
  final _changepasswordTextEditingController = TextEditingController();
  final _rechangepasswordTextEditingController = TextEditingController();
  UserManage userManage = UserManage();
  User? user;

  @override
  void initState() {
    super.initState();
    user = userManage.getUser();
  }

  @override
  void dispose() {
    _passwordTextEditingController.dispose();
    _changepasswordTextEditingController.dispose();
    _rechangepasswordTextEditingController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("비밀번호 변경"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _changePassword(_passwordTextEditingController.text,
                        _changepasswordTextEditingController.text);
                  }
                },
                child: Text('변경'),
                style: TextButton.styleFrom(
                  primary: Color(0xff416E5C),
                )),
          ],
        ),
        body: Container(
            margin: EdgeInsets.all(60),
            child: createProfileNameTextFormField()));
  }

  createProfileNameTextFormField() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            TextFormField(
              controller: _passwordTextEditingController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '비밀번호를 입력해주세요.';
                } else if (value.length < 8 || value.length > 12) {
                  return '8-12자로 입력해주세요.';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: '현재 비밀번호',
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _changepasswordTextEditingController,
              validator: (value) {
                if (value!.isEmpty) {
                  return '비밀번호를 입력해주세요.';
                } else if (value.length < 8 || value.length > 12) {
                  return '8-12자로 입력해주세요.';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: '새 비밀번호',
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _rechangepasswordTextEditingController,
              validator: (value) {
                if (_changepasswordTextEditingController.text != value) {
                  return '비밀번호가 일치하지 않습니다.';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: '새 비밀번호',
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
            ),
          ],
        ));
  }

  void _changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: (user!.email)!, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('비밀번호가 변경되었습니다.'),
          ),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('현재 비밀번호가 일치하지 않습니다.'),
          ),
        );
      });
    }).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('현재 비밀번호가 일치하지 않습니다.'),
        ),
      );
    });
  }
}
