import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donation_nature/screen/mypage/mypage_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인',
            style: TextStyle(
              color: Colors.black,
            )),
        actions: [
          IconButton(
            onPressed: () => _login(),
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(child: _loginForm(context)),
    );
  }

  final _formkey = GlobalKey<FormState>();

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  Widget _loginForm(BuildContext context) {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(50),
              child: SizedBox(
                  height: 200,
                  width: 300,
                  child: Image.asset('assets/images/splash.png')),
            ),
            TextFormField(
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
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이메일',
              ),
            ),
            SizedBox(height: 12.0),
            TextFormField(
              controller: _passwordTextEditingController,
              validator: (value) {
                value!.isEmpty ? '비밀번호를 입력하세요.' : null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '비밀번호',
              ),
              obscureText: true,
            ),
            SizedBox(height: 30.0),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(400, 40),
                  primary: Color(0xff9fc3a8),
                ),
                child: Text('로그인'),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    _login();
                  }
                }),
          ],
        ));
  }

  _login() async {
    //키보드 숨기기
    if (_formkey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());

      // Firebase 사용자 인증, 사용자 등록
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTextEditingController.text,
          password: _passwordTextEditingController.text,
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyPageScreen()));
      } on FirebaseAuthException catch (e) {
        //logger.e(e);
        String message = '';

        if (e.code == 'user-not-found') {
          message = '사용자가 존재하지 않습니다.';
        } else if (e.code == 'wrong-password') {
          message = '비밀번호를 확인하세요';
        } else if (e.code == 'invalid-email') {
          message = '이메일을 확인하세요.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Color(0xffE4EFE7),
          ),
        );
      }
    }
  }
}
