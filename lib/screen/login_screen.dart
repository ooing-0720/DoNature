import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
      body: Container(margin: EdgeInsets.all(50), child: LoginForm()),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginFromState createState() {
    return LoginFromState();
  }
}

class LoginFromState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
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
              validator: (value) =>
                  value!.isEmpty ? "Please enter some text" : null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이메일',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
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
                    Navigator.pop(context);
                  }
                }),
          ],
        ));
  }
}
