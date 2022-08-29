import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_nature/models/user_info_model.dart';
import 'package:donation_nature/screen/user_manage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _repasswordTextEditingController = TextEditingController();
  final _nicknameTextEditingController = TextEditingController();
  final _numberTextEditingController = TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _repasswordTextEditingController.dispose();
    _nicknameTextEditingController.dispose();
    _numberTextEditingController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 1, child: Text("이메일")),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: TextFormField(
                        controller: _emailTextEditingController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '이메일을 입력하세요.';
                          } else if (!RegExp(
                                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(value)) {
                            return '올바른 이메일 형식이 아닙니다.';
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          isDense: true,
                          hintText: "이메일 입력",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text("비밀번호")),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: TextFormField(
                        controller: _passwordTextEditingController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '비밀번호를 입력해주세요.';
                          } else if (value.length < 8 || value.length > 12) {
                            return '8-12자로 입력해주세요..';
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          isDense: true,
                          hintText: "비밀번호 입력",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text("")),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: TextFormField(
                        controller: _repasswordTextEditingController,
                        validator: (value) {
                          if (_passwordTextEditingController.text != value) {
                            return '비밀번호가 일치하지 않습니다.';
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          isDense: true,
                          hintText: "비밀번호 재입력",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text("닉네임")),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: TextFormField(
                        controller: _nicknameTextEditingController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '닉네임를 입력해주세요.';
                          } else if (value.length < 2 || value.length > 10) {
                            return '2-10자로 입력해주세요.';
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          isDense: true,
                          hintText: "닉네임",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: Text("휴대폰")),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: TextFormField(
                          controller: _numberTextEditingController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '휴대폰 번호를 입력하세요.';
                            } else if (!RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$')
                                .hasMatch(value)) {
                              return '올바른 전화번호 형식이 아닙니다.';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            isDense: true,
                            hintText: "010-0000-0000",
                          )),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    join();
                  }
                },
                child: Text('회원가입'),
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    primary: Color(0xff416E5C),
                    minimumSize: const Size.fromHeight(50)),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  join() async {
    String message = '';
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailTextEditingController.text,
        password: _passwordTextEditingController.text,
      )
          .then((value) {
        if (value.user!.email == null) {
        } else {
          User? user = value.user;
          user?.updateDisplayName(_nicknameTextEditingController.text);
          // user?.updatePhoneNumber(_numberTextEditingController.text);
          user?.updatePhotoURL('assets/images/default_profile.png');
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
        return value;
      });

      FirebaseAuth.instance.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          message = "비밀번호 보안성이 낮습니다. 다시 입력해주세요.";
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          message = "중복된 이메일입니다. 다른이메일를 입력해주세요.";
        });
      } else {
        setState(() {
          message = "오류가 발생하였습니다.\n 잠시후 다시 시도해주세요.";
        });
      }
    } catch (e) {
      setState(() {
        message = "오류가 발생하였습니다.\n 잠시후 다시 시도해주세요.";
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xffE4EFE7),
      ),
    );
  }

  // void createUserInfo() {
  //   try {
  //     UserInfoModel userinfoModel = UserInfoModel(
  //         nickname: _nicknameTextEditingController.text,
  //         number: _numberTextEditingController.text);

  //     FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     firestore
  //         .collection('user/${_emailTextEditingController.text}/userinfo')
  //         .add(userinfoModel.toMap());
  //   } catch (ex) {
  //     log('error)', error: ex.toString(), stackTrace: StackTrace.current);
  //   }
  // }

  // void _onPressedJoinButton() {
  //   try {
  //     UserInfoModel userinfoModel = UserInfoModel(
  //         email: _emailTextEditingController.text,
  //         password: _passwordTextEditingController.text,
  //         nickname: _nicknameTextEditingController.text,
  //         number: _numberTextEditingController.text);
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     firestore.collection('/user_info').add(userinfoModel.toMap());
  //   } catch (ex) {
  //     log('error)', error: ex.toString(), stackTrace: StackTrace.current);
  //   }
  // }
}
