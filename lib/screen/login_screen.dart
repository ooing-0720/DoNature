import 'package:donation_nature/screen/mypage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
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
            onPressed: () {},
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Container(margin: EdgeInsets.all(50), child: _loginForm(context)),
    );
  }
  
  final _formkey = GlobalKey<FormState>();

  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();


var logger = Logger(
  printer: PrettyPrinter(),
);

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
            Flexible(
              child: SizedBox(
                  height: 200,
                  width: 300,
                  child: Image.asset('assets/images/splash.png')),
            ),
            TextFormField(
              controller: _emailTextEditingController,
              validator: (value) =>
                  value!.isEmpty ? "Please enter some text" : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이메일',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordTextEditingController,
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
                    print(_passwordTextEditingController.text);
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
        logger.e(e);
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
            backgroundColor: Colors.deepOrange,
          ),
        );
      }
    }
  }

  
}