import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(flex: 1, child: Text("이메일")),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: TextFormField(
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
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(400, 40),
                    primary: Color(0xff9fc3a8),
                  ),
                  child: Text('가입하기'),
                  onPressed: () {},
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
